//
//  SettingsVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 21.03.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "RouteSelectionVC.h"
#import "AppDelegate.h"
#import "RouteSelectionTCCell.h"
#import "BSUpdateDBHandler.h"

#import "IIViewDeckController.h"

#import "GWUtils.h"

@interface RouteSelectionVC ()

@property(nonatomic, retain)IBOutlet UITableView *_tvTableView;

@end

@implementation RouteSelectionVC

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
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // init the delegate
    
    
    /* NavigationBar */
    self.title = @"Routen";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonSystemItemEdit target:self action:@selector(menuButtonTriggered:) ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    updateHandler = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlist:) name:@"successLoadingPlist" object:updateHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlist:) name:@"errorLoadingPlist" object:updateHandler];
    
    self.viewDeckController.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
-(void)downloadRouteList{
        
    NSString *downloadUrl = [NSString stringWithFormat:@"action=getAllRoutes"];
    NSString *fileName = [NSString stringWithFormat:@"allroutes.plist"]; //, lastShownGender, currentDiscipline];
    [updateHandler createDestinationPathWithDirectoryName:@"routes" andFileName:fileName];
    
    NSLog(@"downloadURL: %@", downloadUrl);
    
    updateHandler.successNotification = @"successLoadingPlist";
    updateHandler.errorNotification = @"errorLoadingPlist";
    //[updateHandler notificationString:@"LoadingGroupMatches"]
    [updateHandler setDownloadUrl:downloadUrl];
    
    [updateHandler startUpdateProcess];
    
}

-(void)successLoadingPlist:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
      
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Routes/allroutes.plist"];
    [mdRoutes removeAllObjects];
    mdRoutes = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    [self._tvTable reloadData];
}

-(void)errorLoadingPlist:(NSNotification *)notification{
    NSLog(@"errorLoadingPlist");
    
    }*/


//////////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma mark ViewDeck Delegate
//////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDeckController:(IIViewDeckController*)viewDeckController didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animate
{
    // reload the data for the table
    
    /* if ([appDelegate.events hasFilter])
     mdEventsForTable = [appDelegate.events eventsByGenderFilter:nil andByDisciplineFilter:nil];
     else
     mdEventsForTable = [appDelegate.events sectionedEventsArray: nil];
     
     [self.tvTableView reloadData];
     
     [self.tvTableView setContentOffset:CGPointMake(0, 44)];*/
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated{
    
}

- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide{
    return YES;
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  NavigationBar Actions
/////////////////////////////////////////////////////////////////////////////////////////
-(void)menuButtonTriggered:(NSNotification *)notification{
    NSLog(@"mneuButtonTriggered");
    [appDelegate menuButtonMainViewTriggered];
}


/////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source
//////////////////////////////////////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if (indexPath.row%2 == 0)
         [cell setBackgroundColor:[UIColor whiteColor]];
     else
         [cell setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:0.5]];
    
    
    //[cell setBackgroundColor:[UIColor clearColor]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int row = indexPath.row;
    NSLog(@"mdAllRoutes: %@", appDelegate.mdAllRoutes);
    NSString *dummyString = [[appDelegate.mdAllRoutes  objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] objectForKey:@"description"];
    NSString *text =  dummyString; //[self.items objectAtIndex:indexPath.row];
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    float textLines = textSize.width/220;
    return textSize.height*textLines+70;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    /*  UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 28)] autorelease];
     [v setBackgroundColor:[UIColor clearColor]];
     return v; */
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 23)];
    //[v setBackgroundColor:[UIColor whiteColor]];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_header.png"]];
    [v addSubview:iv];
    return v;
	//return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [appDelegate.mdAllRoutes  count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RouteSelectionTCCell";
	
    RouteSelectionTCCell *cell = (RouteSelectionTCCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RouteSelectionTCCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (RouteSelectionTCCell *) currentObject;
				//cell.contentView.backgroundColor = [ UIColor greenColor ];
				break;
			}
		}
	}
    
    
    if (cell != nil){
        
        UIView *tSelectionView = [[UIView alloc] initWithFrame:cell.frame];
        tSelectionView.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];// [UIColor colorWithRed:142.0/255.0 green:180.0/255.0 blue:227.0/255.0 alpha:0.25];
        cell.selectedBackgroundView = tSelectionView;
    
        cell._lblRouteName.text = [[appDelegate.mdAllRoutes objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] objectForKey:@"title"];
        cell._lblRouteDescription.text = [[appDelegate.mdAllRoutes  objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] objectForKey:@"description"];
        cell._lblNumber.text = [NSString stringWithFormat:@"%d", indexPath.row]; //[[appDelegate.mdAllRoutes  objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] objectForKey:@"id"];
        cell._lblNumber.backgroundColor = [GWUtils yellowColor];
        
        
        cell._lblRouteDescription.frame = CGRectMake(70,40,220,50);
        
        [cell._lblRouteDescription sizeToFit];
    }
    
    return cell;
    
}


/////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate
//////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int routeid = [[[appDelegate.mdAllRoutes  objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] objectForKey:@"id"] intValue];
    [appDelegate routeWasSelected:routeid];

}

@end
