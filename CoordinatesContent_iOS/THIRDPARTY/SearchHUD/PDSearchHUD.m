
#import "PDSearchHUD.h"

@interface PDSearchHUD ()

@property (nonatomic, strong) NSArray *revisedList;

- (IBAction)tappedOnClose:(id)sender;
@end

@implementation PDSearchHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithMutableSearchList:(NSMutableArray *)list andDelegate:(id)aDelegate {
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [[[NSBundle mainBundle] loadNibNamed:@"PDSearchHUD" owner:self options:nil] lastObject];
    [self setFrame:frame];
    if (self) {
        // Initialization code
        _delegate = aDelegate;
        _searchList = list;
        _revisedList = list;
        _searchType = PDSearchTypeContains;
        
        // [_searchBar setBackgroundImage:[UIImage imageNamed:@"sb_searchbar.png"]];
        //[_searchBar setTranslucent:YES];
        
        for (UIView *searchBarSubview in [_searchBar subviews]) {
            if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
                @try {
                    
                    [(UITextField *)searchBarSubview setBorderStyle:UITextBorderStyleRoundedRect];
                }
                @catch (NSException * e) {
                    // ignore exception
                }
            }
        }
        
        _searchBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];
        
        
    }
    return self;
}

- (id)initWithSearchList:(NSArray *)list andDelegate:(id)aDelegate {
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [[[NSBundle mainBundle] loadNibNamed:@"PDSearchHUD" owner:self options:nil] lastObject];
    [self setFrame:frame];
    if (self) {
        // Initialization code
        _delegate = aDelegate;
        _searchList = list;
        _revisedList = list;
        _searchType = PDSearchTypeContains;
        
       // [_searchBar setBackgroundImage:[UIImage imageNamed:@"sb_searchbar.png"]];
        //[_searchBar setTranslucent:YES];
        
        for (UIView *searchBarSubview in [_searchBar subviews]) {
            if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
                @try {
                    
                    [(UITextField *)searchBarSubview setBorderStyle:UITextBorderStyleRoundedRect];
                }
                @catch (NSException * e) {
                    // ignore exception
                }
            }
        }
        
        _searchBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];

        
    }
    return self;
}


-(void)setSearchList:(NSArray *)searchList{
    _searchList = searchList;
}

- (void)layoutSubviews {
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.30 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {

    }];
    [super layoutSubviews];
}

-(void)closeView{
    [UIView animateWithDuration:0.30 animations:^{
        self.alpha = 0.1f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.delegate searchViewClosed];
    }];

}

-(void)reloadData{
    [_tableView reloadData];
}

/*git
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - TableView DataSource
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [cell setBackgroundColor:[UIColor whiteColor]];
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0; // no footer to display
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.revisedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell layout
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    //assign cell properties
    cell.textLabel.text = [self.revisedList objectAtIndex:indexPath.row];
    
    
    UIView *tSelectionView = [[UIView alloc] initWithFrame:cell.frame];
    tSelectionView.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = tSelectionView;
    
    return cell;
}

#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedItem = [self.revisedList objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndex:)]) {
        int index = [self.searchList indexOfObject:selectedItem];
        [self.delegate didSelectRowAtIndex:index];
    } else {
        NSLog(@"Sorry didSelectRowAtIndex: not implemented");
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:selectedItem];
    } else {
        NSLog(@"Sorry didSelectItem: not implemented");
    }
    
    if (_dismissWhenRowSelected) {
        [self tappedOnClose:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -
#pragma mark SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        _revisedList = self.searchList;
    } else {
        
        NSPredicate *predicate;
        switch (self.searchType) {
            case PDSearchTypeContains:
                predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
                break;
            case PDSearchTypeBeginsWith:
                predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[cd] %@", searchText];
                break;
            default:
                break;
        }
        
        _revisedList = [self.searchList filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //_revisedList = self.searchList;
    //[self.tableView reloadData];
    
     [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Actions

- (IBAction)tappedOnClose:(id)sender {

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeView];
        
}

@end
