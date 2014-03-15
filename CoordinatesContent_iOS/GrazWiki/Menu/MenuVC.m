//
//  MenuVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 10.01.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "MenuVC.h"
#import "MenuTCCell.h"

@interface MenuVC ()

@end

@implementation MenuVC

@synthesize tvTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // init the de
    
    maMenuItems = [[NSMutableArray alloc] init];
    maMenuSubItems = [[NSMutableArray alloc] init];
    
    sectionHeaders = [[NSMutableArray alloc] initWithObjects:@"Karten und Routen", @"Allgemein", nil];
    sectionFooters = [[NSMutableArray alloc] initWithObjects:@"Karte oder Routen auswählen", @"Allgemeines zur App", nil];
    
    NSArray *arMenuItemsSection01 = [[NSArray alloc] initWithObjects:@"Karte",@"Routen", nil];
    NSArray *arMenuItemsSection01SubItems = [[NSArray alloc] initWithObjects:@"Strassen- und Gebäudekarte",@"Ausgewählte Gebäude Routen", nil];
    NSArray *arMenuItemsSection02 = [[NSArray alloc] initWithObjects:@"Impressum", nil];
     NSArray *arMenuItemsSection02SubItems = [[NSArray alloc] initWithObjects:@"Informationen über diese App", @"just for test",nil];
    [maMenuItems addObject:arMenuItemsSection01];
    [maMenuItems addObject:arMenuItemsSection02];
    
    [maMenuSubItems addObject:arMenuItemsSection01SubItems];
    [maMenuSubItems addObject:arMenuItemsSection02SubItems];
    
    self.title = @"";
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];
    
  
    
    UIView *navBarView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationbar
    [navBarView setBackgroundColor:[UIColor clearColor]];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_80x80.png"]];
    titleImageView.frame = CGRectMake(5, 6,50 , 32); // Here I am passing origin as (45,5) but can pass them as your requirement.
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [navBarView addSubview:titleImageView];
    
    UILabel *lblNavBarText = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 320, 44)];
    lblNavBarText.textAlignment = NSTextAlignmentLeft;
    lblNavBarText.backgroundColor = [UIColor clearColor];
    lblNavBarText.text = @"Baugeschichte";
    lblNavBarText.font = [UIFont boldSystemFontOfSize:18.0];
    lblNavBarText.textColor = [UIColor whiteColor];
    [navBarView addSubview:lblNavBarText];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
          lblNavBarText.textColor = [UIColor darkGrayColor];
    }
    else{
        tvTableView.frame = CGRectMake(0, tvTableView.frame.origin.y, tvTableView.frame.size.width, tvTableView.frame.size.height);
    }

    
    //titleImageView.contentMode = UIViewContentModeCenter;
    [self.navigationController.navigationBar addSubview:navBarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)infoTriggered:(id)sender{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"infoTriggered" object:self];
}

-(IBAction)mapTriggered:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mapViewTriggered" object:self];
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source
//////////////////////////////////////////////////////////////////////////////////////////

/*-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [cell setBackgroundColor:[UIColor clearColor]];
    
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
   /* UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 23)];
    //[v setBackgroundColor:[UIColor whiteColor]];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_header.png"]];
    [v addSubview:iv];
    return v;*/
    return nil;
}


/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
         return 30.0f;
     else
         return 0.0;
    
}


- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionHeaders objectAtIndex:section];
}

- (NSString *) tableView:(UITableView *) tableView titleForFooterInSection:(NSInteger)section {
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        return [sectionFooters objectAtIndex:section];

    else return nil;

    
   }


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
        return 2;
    else if (section == 1)
        return 1;
    else return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /* static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *detailText = [[maMenuSubItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *text = [[maMenuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@.png", text]];
    
    cell.detailTextLabel.text = detailText;
    cell.textLabel.text = text;
    cell.imageView.image = icon;

    
    return cell;*/
    
    
   static NSString *CellIdentifier = @"MenuTCCell";
	
    MenuTCCell *cell = (MenuTCCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuTCCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (MenuTCCell *) currentObject;
				//cell.contentView.backgroundColor = [ UIColor greenColor ];
				break;
			}
		}
	}
    
    
    UIView *tSelectionView = [[UIView alloc] initWithFrame:cell.frame];
    //tSelectionView.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];// [UIColor colorWithRed:142.0/255.0 green:180.0/255.0 blue:227.0/255.0 alpha:0.25];
    UIImageView *tImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_highlighted.png"]];
    [tSelectionView addSubview:tImageView];
    cell.selectedBackgroundView = tSelectionView;
    
    cell.lblDetailText.text = [[maMenuSubItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.lblText.text = [[maMenuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.ivIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@.png", cell.lblText.text]];
    
    return cell;

}


/////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate
//////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"mapViewTriggered" object:self];
                break;
            case 1:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"settingsTriggered" object:self];
                break;
            case 2:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"settingsTriggered" object:self];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"infoTriggered" object:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
