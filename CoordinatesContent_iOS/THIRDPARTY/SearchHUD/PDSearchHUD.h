#import <UIKit/UIKit.h>

typedef enum {
    PDSearchTypeBeginsWith,
    PDSearchTypeContains
} PDSearchType;

@protocol PDSearchHUDDelegate <NSObject>



//Called after User taps on the List and index of the item is returned
- (void)didSelectRowAtIndex:(int)index;

//Called after User taps on the List and value is returned
- (void)didSelectItem:(NSString *)item;

// Called after User closed the search view
-(void)searchViewClosed;
@end

@interface PDSearchHUD : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) __unsafe_unretained id <PDSearchHUDDelegate>delegate;
@property (nonatomic, strong) NSArray *searchList;

// Value that determines whether the HUD to dismiss after row selection
@property (nonatomic, assign) BOOL dismissWhenRowSelected;

//Used to determine the Comparision type
@property (nonatomic, assign) PDSearchType searchType;

- (id)initWithSearchList:(NSArray *)list andDelegate:(id)aDelegate;
- (id)initWithMutableSearchList:(NSMutableArray *)list andDelegate:(id)aDelegate;

-(void)closeView;

-(void)reloadData;

@end
