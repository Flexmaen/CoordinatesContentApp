//
//  MainViewController.m
//  SampleMap : Diagnostic map
//

#import "ViewController.h"
#import "MarkerMurderAppDelegate.h"

#import "MainView.h"

#import "RMOpenStreetMapSource.h"
#import "RMOpenSeaMapLayer.h"
#import "RMMapView.h"
#import "RMMarker.h"
#import "RMCircle.h"
#import "RMProjection.h"
#import "RMAnnotation.h"
#import "RMQuadTree.h"
#import "RMCoordinateGridSource.h"
#import "RMOpenCycleMapSource.h"
#import "RMUserLocation.h"
#import "RMPath.h"

#import "PDSearchHUD.h"

#import "BSUtils.h"

#import "BuildingAnnotation.h"


#import "GWUtils.h"

#import "InternetConnectionHandler.h"
#import "BSUpdateDBHandler.h"

#import "AppDelegate.h"

#import "DetailViewVC.h"
#import "DetailViewContainerVC.h"

#import "YRDropdownView.h"

#import "RTLabel.h"

#import "IIViewDeckController.h"

@implementation ViewController
{
    CLLocationCoordinate2D center;
    
    BOOL tapped;
    NSUInteger tapCount;
    bool bFollowMe;

}

@synthesize mapView;
@synthesize infoTextView;
@synthesize mppLabel, mppImage, btnLocate, vNavigation, vcDetailViewContainer, vWarning, btnRotate, vRouteInformation, lblRouteInformation, vNavigationBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    //Notifications for tile requests.  This code allows for a class to know when a tile is requested and retrieved
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tileRequested:) name:@"RMTileRequested" object:nil ];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tileRetrieved:) name:@"RMTileRetrieved" object:nil ];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    tapped = NO;
    tapCount = 0;
    bFollowMe = NO;
    isShowingRoute = NO;
    isShowingSearchBuilding = NO;
    
    updateHandler = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlist:) name:@"successLoadingPlist" object:updateHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlist:) name:@"errorLoadingPlist" object:updateHandler];
   
    updateHandlerRoute = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlistRoute:) name:@"successLoadingPlistRoute" object:updateHandlerRoute];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlistRoute:) name:@"errorLoadingPlistRoute" object:updateHandlerRoute];
    
    updateHandlerCategories = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlistCategories:) name:@"successLoadingPlistCategories" object:updateHandlerCategories];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlistCategories:) name:@"errorLoadingPlistCategories" object:updateHandlerCategories];

    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // init the delegate
    
    

    
   // [self.navigationItem setRightBarButtonItem:favorite];
    
    
   // NSString *sample_text = @"<b>bold</b>,<i>italic</i> and <u>underlined</u> text, and <font face='HelveticaNeue-CondensedBold' size=20 color='#CCFF00'>text with custom font and color</font>";
   /* NSString *sample_text = @"<font face='Helvetica' size=10> Data, imagery and map information provided by MapQuest, <a href='http://www.openstreetmap.org/copyright'> OpenStreetMap</a> and contributors, ODbL</font>";
   // NSString *sample_text  = @"clickable link - <a href='http://store.apple.com'>link to apple store</a> <a href='http://www.google.com'>link to google</a> <a href='http://www.yahoo.com'>link to yahoo</a> <a href='https://github.com/honcheng/RTLabel'>link to RTLabel in GitHub</a> <a href='http://www.wiki.com'>link to wiki.com website</a>";
    
    RTLabel *rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(100, 473, 216, 30)];
    rtLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:rtLabel];
    [rtLabel setText:sample_text];*/
 
    
    // init the detail view
    vcDetailViewContainer = [[DetailViewContainerVC alloc] init];

    // setup the map view
    cllCoordinate2dGraz =  CLLocationCoordinate2DMake(47.070297,15.439997);
    maAnnotationArray = [[NSMutableArray alloc] init];
    
    map = [[MQMapView alloc] initWithFrame:self.view.bounds];
    map.zoomEnabled = YES;
    map.delegate = self;
    map.mapType = MQMapTypeStandard;
    map.userTrackingMode = RMUserTrackingModeNone;
    map.mapZoomLevel = 18;
    
    
    [self.view addSubview:map];
  //  [self.view sendSubviewToBack:map];
    [self centerMap];


    [self downloadBuildings];

    // set the list for the search View
    NSArray *searchArray = (NSArray*)appDelegate.searchArray;
    searchHUD = [[PDSearchHUD alloc] initWithSearchList:searchArray andDelegate:self];

    // set the list for the search View
    NSArray *searchArrayCategories = (NSArray*)appDelegate.searchArrayCategories;
    searchHUDCategories = [[PDSearchHUD alloc] initWithSearchList:searchArrayCategories andDelegate:self];
    
    int yPosOfVNavigation = 300;
    int yPOsOfWarinngCorrector = 0;

    /* NavigationBar */
    self.title = nil; //@"Graz Wiki";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
       // self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];; //:navbarTitleTextAttributes];
        //searchHUD.frame = CGRectMake(searchHUD.frame.origin.x, searchHUD.frame.origin.y+22, searchHUD.frame.size.width, searchHUD.frame.size.height);
        yPosOfVNavigation = yPosOfVNavigation+62;
        // position the warning view
        yPOsOfWarinngCorrector = yPOsOfWarinngCorrector + 62;
    }
    
    if ([BSUtils isIphone5]){
        yPosOfVNavigation = 420;
    }else{
        yPOsOfWarinngCorrector = yPOsOfWarinngCorrector -88;
        // rtLabel.frame = CGRectMake(rtLabel.frame.origin.x, rtLabel.frame.origin.y-88, rtLabel.frame.size.width, rtLabel.frame.size.height);
    }
    
    
    // position the navigation view
    vNavigation.frame = CGRectMake(290, yPosOfVNavigation, 300, 48);
    self.vNavigation.layer.masksToBounds = NO;
    self.vNavigation.layer.cornerRadius = 8; // if you like rounded corners
    self.vNavigation.layer.shadowOffset = CGSizeMake(-5, 5);
    self.vNavigation.layer.shadowRadius = 2;
    self.vNavigation.layer.shadowOpacity = 0.3;
    [self.view addSubview:vNavigation];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                   style:UIBarButtonSystemItemEdit target:self action:@selector(menuButtonTriggered:) ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonTriggered:)];
    
    
    UIBarButtonItem *categoriesButton =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(categoriesButtonTriggered:)];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:categoriesButton,searchButton, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
       //[navBarView addSubview:lblNavBarText];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
      //  self.edgesForExtendedLayout = UIRectEdgeNone;
    
        
        
        UIView *navBarView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationbar
        [navBarView setBackgroundColor:[UIColor clearColor]];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_80x80.png"]];
        titleImageView.frame = CGRectMake(5, 6,50 , 32); // Here I am passing origin as (45,5) but can pass them as your requirement.
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        //[navBarView addSubview:titleImageView];
        
        UILabel *lblNavBarText = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 160, 44)];
        lblNavBarText.textAlignment = NSTextAlignmentLeft;
        lblNavBarText.backgroundColor = [UIColor clearColor];
        lblNavBarText.text = @"Graz Wiki";
        lblNavBarText.font = [UIFont boldSystemFontOfSize:18.0];
        lblNavBarText.textColor = [UIColor darkGrayColor];
        lblNavBarText.textColor = [UIColor whiteColor];
        vNavigationBar.backgroundColor = [UIColor clearColor];
        vNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.navigationController.navigationBar insertSubview:vNavigationBar atIndex:1];

    }
    else{
        self.title = @"Graz Wiki";
    }
    
   /* UIView* ctrl = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];;*/
  
    
   // self.navigationItem.titleView = navBarView;

}

- (void)didReceiveMemoryWarning
{
    // RMLog(@"didReceiveMemoryWarning %@", self);
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
      searchHUD.frame = CGRectMake(searchHUD.frame.origin.x, 64, searchHUD.frame.size.width, searchHUD.frame.size.height);
      searchHUDCategories.frame = CGRectMake(searchHUD.frame.origin.x, 64, searchHUD.frame.size.width, searchHUD.frame.size.height);
    }
    
    self.vWarning.frame = CGRectMake(self.vWarning.frame.origin.x, 100, self.vWarning.frame.size.width, 43);
    
        self.viewDeckController.delegate = self;


}

- (void)viewDidUnload
{
    [self setMppLabel:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (appDelegate.isRouteMode){
        isShowingRoute = NO;
        [self downloadRoute];
    }
    
 
}

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
    [searchHUD closeView];
    [searchHUDCategories closeView];
    isSearchMode = NO;
    isSearchCategoriesMode = NO;
}

- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide{
    return YES;
}

#pragma mark -
#pragma mark init of search array
-(void)setSearchModeAllBuildings:(bool)tIsAllBuildingsSearchmode{
   isAllBuildingsSearchMode = tIsAllBuildingsSearchmode;
    
    if (tIsAllBuildingsSearchmode)
        [searchHUD setSearchList:(NSArray*)appDelegate.searchArray];
    else
        [searchHUD setSearchList:(NSArray*)appDelegate.searchArrayCategories];
    
}


#pragma mark -
#pragma mark Download And Handle Route

-(void)downloadRoute{

    if (!appDelegate.isRouteMode) return;
    if (isShowingRoute) return;
    
    [map removeOverlay:polyline];
    [map removeAnnotations:maAnnotationArray];
    [maAnnotationArray removeAllObjects];

    
    [[NSNotificationCenter defaultCenter] removeObserver:updateHandlerRoute];
    
    int routeId = appDelegate.routeid;
    NSString *downloadUrl = [NSString stringWithFormat:@"action=getRouteInformation&rid=%d", routeId];
    NSString *fileName = [NSString stringWithFormat:@"route_%d.plist", routeId]; //, lastShownGender, currentDiscipline];
    [updateHandlerRoute createDestinationPathWithDirectoryName:@"Routes" andFileName:fileName];
    
    NSLog(@"downloadURL: %@", downloadUrl);
    
    updateHandlerRoute.successNotification = @"successLoadingPlistRoute";
    updateHandlerRoute.errorNotification = @"errorLoadingPlistRoute";
    [updateHandlerRoute setDownloadUrl:downloadUrl];
    
    [updateHandlerRoute startUpdateProcess];
    
}

-(void)successLoadingPlistRoute:(NSNotification *)notification{
    NSLog(@"successLoadingPlistRoute");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistName = [NSString stringWithFormat:@"/Routes/route_%d.plist", appDelegate.routeid];
    NSString *filePath = [documentsDirectory stringByAppendingString:plistName];
    mdRoute = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
        
    [YRDropdownView hideDropdownInView:vWarning];
    
    
    [self showRoute];
    [self addMarkersForRoute];
    
}

-(void)errorLoadingPlistRoute:(NSNotification *)notification{
    NSLog(@"errorLoadingPlistRoute");
    
    // if there is no connection to the internet show warining view
    if (![BSUtils isConnectedToInternet]){
        [YRDropdownView showDropdownInView:vWarning
                                     title:@"Achtung"
                                    detail:@"Fehler beim Herunterladen der Daten! Bitte überprüfen Sie ihre Internetverbindung."
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:NO
                                 hideAfter:0.0];
    }
}


/*
-(void)routeLoadFinished
{
    // get the raw xml passed back from the server:
    NSLog(@"%@", route.rawXML);
    
    // do something with all the maneuvers
    for ( MQManeuver *maneuver in route.maneuvers )
    {
        NSLog(@"%@", maneuver.narrative);
    }

}*/


-(void)showRoute{

    NSMutableDictionary *tLineDict; 
    for (int i=0;i<[mdRoute count];i++){
        NSMutableDictionary *tDict =  [mdRoute objectForKey:[NSString stringWithFormat:@"%d", i]];
        NSString *sID = [tDict objectForKey:@"id"];
        if ([sID isEqualToString:@"line"]){
            tLineDict = [tDict objectForKey:@"points"];
            break;
        }
       
    }
    
    
    int size = [tLineDict count];
    CLLocationCoordinate2D polyCoords_line[size];
    CLLocationCoordinate2D centerCoordinate;
    for (int i=0;i<[tLineDict count];i++){
     
     int current = i;
     int next = i+1;
     if (next >= [tLineDict count]) next = 0;
     
     NSMutableDictionary *tCurrentBuilding = [tLineDict objectForKey:[NSString stringWithFormat:@"%d", current]];
   //  NSMutableDictionary *tNextBuilding = [tLineDict objectForKey:[NSString stringWithFormat:@"%d", next]];
     
     float longitudeStart = [[tCurrentBuilding objectForKey:@"point_longitude"] floatValue];
    // float lonigitudeEnd = [[tNextBuilding objectForKey:@"point_longitude"] floatValue];
     float latitudeStart = [[tCurrentBuilding objectForKey:@"point_latitude"] floatValue];
   //  float latitudeEnd = [[tNextBuilding objectForKey:@"point_latitude"] floatValue];
        
        if (i == 0){
            centerCoordinate = CLLocationCoordinate2DMake(latitudeStart, longitudeStart);
        }
           polyCoords_line[i] = CLLocationCoordinate2DMake(latitudeStart, longitudeStart);
     
     }
    
    [self centerMapAtCoordinate:centerCoordinate];

    polyline = [MQPolyline polylineWithCoordinates:polyCoords_line count:size];
    [map setRegion:MQCoordinateRegionBetweenCoords(polyCoords_line[0], polyCoords_line[size-1])];
    map.mapType = MQMapTypeStandard;
    [map addOverlay:polyline];
     isShowingRoute = YES;
    return;
    
}

#pragma mark -
#pragma mark Download And Handle  Buildings

-(void)downloadBuildings{
    
    if (appDelegate.isRouteMode){
        [self downloadRoute];
        return;
    }
    
    if (isShowingSearchBuilding)return;

    
    [[NSNotificationCenter defaultCenter] removeObserver:updateHandler];
  
 
    // http://bitschmiede.no-ip.org/~thas/grazwiki/restService.php?action=getBuildingsOfRegion&min_lat=47.075&max_lat=47.076&min_long=15.4&max_long=15.5
    
    
    MQCoordinateRegion region = map.region;
    
    float latitudeMax = region.center.latitude + region.span.latitudeDelta/2;
    float latitudeMin = region.center.latitude - region.span.latitudeDelta/2;
    float longitudeMax = region.center.longitude + region.span.longitudeDelta/2;
    float longitudeMin = region.center.longitude - region.span.longitudeDelta/2;

    NSString *downloadUrl = [NSString stringWithFormat:@"action=getBuildingsOfRegion&min_lat=%f&max_lat=%f&min_long=%f&max_long=%f",latitudeMin,latitudeMax,longitudeMin, longitudeMax];
    NSString *fileName = [NSString stringWithFormat:@"regionbuildings.plist"]; //, lastShownGender, currentDiscipline];
    [updateHandler createDestinationPathWithDirectoryName:@"Buildings" andFileName:fileName];
    
    NSLog(@"downloadURL: %@", downloadUrl);
    
    updateHandler.successNotification = @"successLoadingPlist";
    updateHandler.errorNotification = @"errorLoadingPlist";
    //[updateHandler notificationString:@"LoadingGroupMatches"];
    [updateHandler setDownloadUrl:downloadUrl];
    
    [updateHandler startUpdateProcess];

}

-(void)successLoadingPlist:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
    
    
    [map removeOverlay:polyline];
    [map removeAnnotations:maAnnotationArray];
    [maAnnotationArray removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Buildings/regionbuildings.plist"];
    mdRegionBuildings = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];

    [self addMarkersForRegion];
    //[map addAnnotations:maAnnotationArray];
    
    [YRDropdownView hideDropdownInView:vWarning];
}

-(void)errorLoadingPlist:(NSNotification *)notification{
    NSLog(@"errorLoadingPlist");
    
    // if there is no connection to the internet show warining view
    if (![BSUtils isConnectedToInternet]){
        [YRDropdownView showDropdownInView:vWarning
                                     title:@"Achtung"
                                    detail:@"Fehler beim Herunterladen der Daten! Bitte überprüfen Sie ihre Internetverbindung."
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:NO
                                 hideAfter:0.0];
    }
}

#pragma mark -
#pragma mark Download And Handle Buildings of Category

-(void)downloadBuildingsOfCategory:(NSString *)categoryName{
    
      
   // if (isShowingSearchBuilding)return;
    
    [[NSNotificationCenter defaultCenter] removeObserver:updateHandlerCategories];
    
    
    // http://bitschmiede.no-ip.org/~thas/grazwiki/restService.php?action=getBuildingsOfRegion&min_lat=47.075&max_lat=47.076&min_long=15.4&max_long=15.5
    
    
       
    NSString *downloadUrl = [NSString stringWithFormat:@"action=getBuildingsOfCategory&category=%@",[self encodeURL:categoryName]];

    // there is no encoding/decoding function for nsstring, so we do the replacment by ourselve
    /*[[[[[[downloadUrl stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;amp;"]
        stringByReplacingOccurrencesOfString: @" " withString: @"%20"]
       stringByReplacingOccurrencesOfString: @"'" withString: @"&amp;#39;"]
      stringByReplacingOccurrencesOfString: @">" withString: @"&amp;gt;"]
     stringByReplacingOccurrencesOfString: @"<" withString: @"&amp;lt;" ]   stringByReplacingOccurrencesOfString: @" " withString: @"%20" ];*/
    //downloadUrl = [self encodeURL:downloadUrl];
    
    NSString *fileName = [NSString stringWithFormat:@"categorybuildings.plist"]; //, lastShownGender, currentDiscipline];
    [updateHandlerCategories createDestinationPathWithDirectoryName:@"Categories" andFileName:fileName];
    
    NSLog(@"downloadURL: %@", downloadUrl);
    
    updateHandlerCategories.successNotification = @"successLoadingPlistCategories";
    updateHandlerCategories.errorNotification = @"errorLoadingPlistCategories";
    //[updateHandler notificationString:@"LoadingGroupMatches"];
    [updateHandlerCategories setDownloadUrl:downloadUrl];
    
    [updateHandlerCategories startUpdateProcess];
    
    
}

-(void)successLoadingPlistCategories:(NSNotification *)notification{
    NSLog(@"successLoadingPlistCategories");
    
    
    [map removeOverlay:polyline];
    [map removeAnnotations:maAnnotationArray];
    [maAnnotationArray removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Categories/categorybuildings.plist"];
    mdCategoryBuildings = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    [self addMarkersForCategory];
    //[map addAnnotations:maAnnotationArray];
    
    [YRDropdownView hideDropdownInView:vWarning];
    
    isShowingRoute = YES;
}

-(void)errorLoadingPlistCategories:(NSNotification *)notification{
    NSLog(@"errorLoadingPlistCategories");
    
    // if there is no connection to the internet show warining view
    if (![BSUtils isConnectedToInternet]){
        [YRDropdownView showDropdownInView:vWarning
                                     title:@"Achtung"
                                    detail:@"Fehler beim Herunterladen der Daten! Bitte überprüfen Sie ihre Internetverbindung."
                                     image:[UIImage imageNamed:@"dropdown-alert"]
                                  animated:NO
                                 hideAfter:0.0];
    }
}

- (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}


#pragma mark -
#pragma mark Search Delegate

- (void)didSelectRowAtIndex:(int)index {
    NSLog(@"Index of Tapped item : %i", index);
    NSLog(@"building: %@",   [appDelegate.mdAllBuildings objectForKey:[NSString stringWithFormat:@"%d", index+1]] );
}

- (void)didSelectItem:(NSString *)item {
    NSLog(@"Selected Item %@", item);
    
    
    if (isSearchMode){

        NSEnumerator *enumerator = [appDelegate.mdAllBuildings keyEnumerator];
        id key;
        while ((key = [enumerator nextObject])) {
            NSDictionary *tmp = [appDelegate.mdAllBuildings  objectForKey:key];
            if ([[tmp objectForKey:@"title"] isEqualToString:item]){
                NSLog(@"selected building is: %@", tmp);
                [map removeAnnotations:maAnnotationArray];
                [maAnnotationArray removeAllObjects];
                [self addMarkerWithDictionaryItemToAnnotionArray:tmp AndZoomToMarker:YES];
                [map addAnnotations:maAnnotationArray];
                [searchHUD closeView];
                isSearchMode = NO;
                appDelegate.isRouteMode = NO;
                isShowingRoute = NO;
                isShowingSearchBuilding = YES;
                [self showRouteInformation:@"Hier tippen um alle Gebäude anzuzeigen"];
                break;
            }
        }
    }else if (isSearchCategoriesMode){
        [map removeAnnotations:maAnnotationArray];
        [maAnnotationArray removeAllObjects];
       [searchHUDCategories closeView];
        isSearchCategoriesMode = NO;
        isShowingSearchBuilding = YES;
        appDelegate.isRouteMode = NO;
        isShowingRoute = NO;
        [self downloadBuildingsOfCategory:item];
        [self showRouteInformation:@"Hier tippen um alle Gebäude anzuzeigen"];

    }
}

-(void)searchViewClosed{
    isSearchMode = NO;
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  Map Methods
/////////////////////////////////////////////////////////////////////////////////////////
-(void)centerMap{
    MQCoordinateRegion myRegion = MQCoordinateRegionMakeWithDistance(cllCoordinate2dGraz, 200, 200);
    [map setRegion:myRegion];
}

-(void)centerMapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    MQCoordinateRegion myRegion = MQCoordinateRegionMakeWithDistance(coordinate, 200, 200);
    [map setRegion:myRegion];
}


-(void)addMarkersForRoute{
    

   // MQCoordinateRegion region = map.region;
    NSMutableDictionary *tAllBuildings =  mdRoute; // appDelegate.mdAllBuildings;
    NSEnumerator *enumerator = [tAllBuildings keyEnumerator];
    id key;
    int n =0;
    CLLocationCoordinate2D centerCoordinate; // = CLLocationCoordinate2DMake(latitude, longitude);
    while ((key = [enumerator nextObject])) {
        if (n > 500) break;
        NSDictionary *tmp = [tAllBuildings objectForKey:key];
        
        /* check if annotation is in visible region of mapview */
        float latitude = [[tmp objectForKey:@"latitude"] floatValue];
        float longitude = [[tmp objectForKey:@"longitude"] floatValue];
        
    /*    float latitudeMax = region.center.latitude + region.span.latitudeDelta;
        float latitudeMin = region.center.latitude - region.span.latitudeDelta;
        
        float longitudeMax = region.center.longitude + region.span.longitudeDelta;
        float longitudeMin = region.center.longitude - region.span.longitudeDelta;*/
        
        
        [self addMarkerWithDictionaryItemToAnnotionArray:tmp];
        
        
      /*  if (latitude < latitudeMax && latitude > latitudeMin){
            if (longitude < longitudeMax && longitude > longitudeMin){
                
                //check if current building/annotation is already on screen
                //if (![self markerIsAlreadyOnMap:tmp])
                [self addMarkerWithDictionaryItemToAnnotionArray:tmp];
            }
        }*/
        
        centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);        
        //n++;
    }
    
    // center the map 
    //[self centerMapAtCoordinate:centerCoordinate];
    [map addAnnotations:maAnnotationArray];
    isShowingRoute = YES;
    [self setupRouteInformationView];
    [self showRouteInformation:@"Hier tippen um Route zu verlassen"];
    
}

-(void)addMarkersForCategory{
    
    NSMutableDictionary *tAllBuildings =  mdCategoryBuildings; // appDelegate.mdAllBuildings;
    NSEnumerator *enumerator = [tAllBuildings keyEnumerator];
    id key;
    int n =0;
    while ((key = [enumerator nextObject])) {
        if (n > 500) break;
        NSDictionary *tmp = [tAllBuildings objectForKey:key];
        
        // check if annotation is in visible region of mapview 
      //  float latitude = [[tmp objectForKey:@"latitude"] floatValue];
      //  float longitude = [[tmp objectForKey:@"longitude"] floatValue];
        //   CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        
        [self addMarkerWithDictionaryItemToAnnotionArray:tmp];
                 
              
        //n++;
    }
    
    [map addAnnotations:maAnnotationArray];
    
}

-(void)addMarkersForRegion{
    
    MQCoordinateRegion region = map.region;
    NSMutableDictionary *tAllBuildings =  mdRegionBuildings; // appDelegate.mdAllBuildings;
    NSEnumerator *enumerator = [tAllBuildings keyEnumerator];
    id key;
    int n =0;
    while ((key = [enumerator nextObject])) {
        if (n > 500) break;
        NSDictionary *tmp = [tAllBuildings objectForKey:key];
        
        /* check if annotation is in visible region of mapview */
        float latitude = [[tmp objectForKey:@"latitude"] floatValue];
        float longitude = [[tmp objectForKey:@"longitude"] floatValue];
     //   CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        float latitudeMax = region.center.latitude + region.span.latitudeDelta;
        float latitudeMin = region.center.latitude - region.span.latitudeDelta;
        
        float longitudeMax = region.center.longitude + region.span.longitudeDelta;
        float longitudeMin = region.center.longitude - region.span.longitudeDelta;
        
        
        [self addMarkerWithDictionaryItemToAnnotionArray:tmp];

        
        if (latitude < latitudeMax && latitude > latitudeMin){
            if (longitude < longitudeMax && longitude > longitudeMin){
                
                //check if current building/annotation is already on screen
                //if (![self markerIsAlreadyOnMap:tmp])
                    [self addMarkerWithDictionaryItemToAnnotionArray:tmp];
            }
        }
     
        //n++;
    }
    
    [map addAnnotations:maAnnotationArray];

}

-(bool)markerIsAlreadyOnMap:(NSDictionary*)item{
    for (BuildingAnnotation * object in maAnnotationArray) {
        NSString *sBuildingID = [NSString stringWithFormat:@"%d", object.buildingID];
        if ([sBuildingID isEqualToString:[item objectForKey:@"id"]])
            return YES;
    }
    
    return NO;
}

-(void)addMarkerWithDictionaryItemToAnnotionArray:(NSDictionary*)mdItem{
    
    NSString *theID;
    NSString *title;
    float latitude, longitude;
    
    theID = [mdItem objectForKey:@"id"];
    title = [mdItem objectForKey:@"title"];
    latitude = [[mdItem objectForKey:@"latitude"] floatValue];
    longitude = [[mdItem objectForKey:@"longitude"] floatValue];
    

    BuildingAnnotation *annotation;
    annotation = [[BuildingAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                                          title:title
                                                       subTitle:nil];
    annotation.buildingID = [theID intValue];
    [maAnnotationArray addObject:annotation];
   
    
}

-(void)addMarkerWithDictionaryItemToAnnotionArray:(NSDictionary*)mdItem AndZoomToMarker:(bool)zoomToMarker{
    
    
    NSString *theID;
    NSString *title;
    float latitude, longitude;
    
    theID = [mdItem objectForKey:@"id"];
    title = [mdItem objectForKey:@"title"];
    latitude = [[mdItem objectForKey:@"latitude"] floatValue];
    longitude = [[mdItem objectForKey:@"longitude"] floatValue];
    
    
    BuildingAnnotation *annotation;
    annotation = [[BuildingAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                                          title:title
                                                       subTitle:nil];
    annotation.buildingID = [theID intValue];
    [maAnnotationArray addObject:annotation];

    
    if (zoomToMarker){
        [self centerMapAtCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    }

}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  Route Information View
/////////////////////////////////////////////////////////////////////////////////////////
-(void)setupRouteInformationView{
   /* CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = vRouteInformation.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [vRouteInformation.layer insertSublayer:gradient atIndex:0];*/
}

-(void)showRouteInformation:(NSString*)infoText{
    int y = 568-vRouteInformation.frame.size.height-44-20;
    if (![BSUtils isIphone5]){
        y = y-88;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        y = y+64;
    }

    
    
    CGRect rect = CGRectMake(0, y, vRouteInformation.frame.size.width, vRouteInformation.frame.size.height);
    vRouteInformation.frame = rect;
    lblRouteInformation.text = infoText;
    [self.view addSubview:vRouteInformation];
}

-(void)hideRouteInformation{
    [vRouteInformation removeFromSuperview];
}

-(IBAction)closeRouteTriggered:(id)sender{
    appDelegate.isRouteMode = NO;
    isShowingSearchBuilding = NO;
    [self hideRouteInformation];
    [self downloadBuildings];
    
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  Context Navigation Actions
/////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)contextMenuButtonTriggered:(id)sender{
    UIButton *button = (UIButton*)sender;
    int tag = button.tag;
    
    if (![self checkIfUserLocationIsEnabled] && tag != 1){
        [self showEnableUserLoactionDialog];
        return;
    }

    switch (tag) {
        case 1: // button open
            if (vNavigation.frame.origin.x < 290)
                [self animateContextMenuOut];
            else
                [self animateContextMenuIn];
            break;
        case 2: // button locate
            
            if (map.showsUserLocation){
                map.showsUserLocation = NO;
                [btnLocate setImage:[UIImage imageNamed:@"btn_locate.png"] forState:UIControlStateNormal];
            }
            else{
                map.showsUserLocation = YES;
                [btnLocate setImage:[UIImage imageNamed:@"btn_locate_highlight.png"] forState:UIControlStateNormal];
            }
            break;
        case 3: // button center
            if (map.showsUserLocation)
                [self centerMapAtCoordinate:map.userLocation.coordinate];
            break;
        case 4:
            if (map.userTrackingMode == MQUserTrackingModeFollowWithHeading){
                [map rotateToHeading:0 animated:YES rotationOffset:CGPointMake(0, 0)];
                map.userTrackingMode = MQUserTrackingModeFollow;
                map.showsHeading = NO;
                [btnRotate setImage:[UIImage imageNamed:@"btn_rotate.png"] forState:UIControlStateNormal];
                
            }
            else{
                                
                return;
                
                map.userTrackingMode = MQUserTrackingModeFollowWithHeading;
                map.showsHeading = YES;
                [btnRotate setImage:[UIImage imageNamed:@"btn_rotate_highlight.png"] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

-(bool)checkIfUserLocationIsEnabled{
    
    return YES;
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        return NO;
    }else
        return YES;
    
    
    /*   MQUserLocation *userLocation = map.userLocation;
    if (!userLocation.location)
        return NO;
    else
        return YES;
    
 BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    BOOL locationAvailable = userLocation.location;
    
    if (locationAllowed==NO) {
        return NO;
              
    } else {
        if (locationAvailable==NO){
            return NO;
        }
          
    }
    
    return YES;*/
}

-(void)showEnableUserLoactionDialog{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Standortdienste nicht aktiviert"
                                                    message:@"Bitte aktivieren Sie diese in den Systemeinstellungen, um diese Funktion nutzen zu können."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  Context Navigation Animation
/////////////////////////////////////////////////////////////////////////////////////////
-(void)animateContextMenuIn{
    CGRect endPosition = CGRectMake(105, vNavigation.frame.origin.y, vNavigation.frame.size.width, vNavigation.frame.size.height);

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.4];
    vNavigation.frame = endPosition;
    [UIView commitAnimations];

}

-(void)animateContextMenuOut{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.2];
    vNavigation.frame =  CGRectMake(290, vNavigation.frame.origin.y,  vNavigation.frame.size.width, vNavigation.frame.size.height);
    [UIView commitAnimations];

}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  NavigationBar Actions
/////////////////////////////////////////////////////////////////////////////////////////
-(void)menuButtonTriggered:(NSNotification *)notification{
    NSLog(@"mneuButtonTriggered");
    [appDelegate menuButtonMainViewTriggered];
    
    //[self addMarkersForRegion];
}

-(void)searchButtonTriggered:(NSNotification *)notification{

    [self setSearchModeAllBuildings:YES];

    if (isSearchMode){
        [searchHUD closeView];
        isSearchMode = NO;
        return;
    }

    if (isSearchCategoriesMode){
        [searchHUDCategories closeView];
        isSearchCategoriesMode = NO;
    }

    
    
    [searchHUD layoutSubviews];
    [searchHUD setDismissWhenRowSelected:YES];
    [searchHUD setSearchType:PDSearchTypeContains];
    [searchHUD reloadData];
    [self.view addSubview:searchHUD];
    
    isSearchMode = YES;

}

-(void)categoriesButtonTriggered:(NSNotification *)notification{
    
    [self setSearchModeAllBuildings:NO];
    
    
    if (isSearchMode){
        [searchHUD closeView];
        isSearchMode = NO;
    }
    
    if (isSearchCategoriesMode){
        [searchHUDCategories closeView];
        isSearchCategoriesMode = NO;
        return;
    }
    
    isSearchCategoriesMode = YES;

    
    [searchHUDCategories layoutSubviews];
    [searchHUDCategories setDismissWhenRowSelected:YES];
    [searchHUDCategories setSearchType:PDSearchTypeContains];
    [searchHUDCategories reloadData];
    
    [self.view addSubview:searchHUDCategories];
    
    
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  Actions
/////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)followMeTriggered:(id)sender{
    
   // [self drawRoute]; return;
    
    map.showsUserLocation = YES;
    
    [self downloadBuildings];
    
    //[mapView setCenterCoordinate:center animated:NO];
    if (!bFollowMe){
        mapView.showsUserLocation = YES;
        CLLocationCoordinate2D userLocation = mapView.userLocation.location.coordinate;
        if (mapView.userLocation.location != nil)
            [mapView setCenterCoordinate:userLocation animated:YES];
        
    }
    else mapView.showsUserLocation = NO;
    
}


/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma MapView Delegates
/////////////////////////////////////////////////////////////////////////////////////////
- (void)mapViewDidEndDecelerating:(MQMapView *)mapView{
    NSLog(@"mapViewDidEndDecelerating");
    
    [self downloadBuildings];
    
}

- (void) mapViewDidEndZooming:(MQMapView *)mapView{
    [self downloadBuildings];
}

- (void) mapViewDidEndDragging:(MQMapView *)mapView willDecelerate:(BOOL)decelerate{
    NSLog(@"mapViewDidEndDragging");
    
    [self downloadBuildings];
}

- (void)mapViewWillStartLocatingUser:(MQMapView *)mapView {
    NSLog(@"MapDelegate notified of STARTING to track user");
}


- (void)mapViewDidStopLocatingUser:(MQMapView *)mapView {
    NSLog(@"MapDelegate notified of STOPPING tracking of user");
}


- (void)mapView:(MQMapView *)amapView didUpdateUserLocation:(MQUserLocation *)userLocation {
    NSLog(@"MapDelegate notified of new user location");
    //  accuracyInMeters.text = [NSString stringWithFormat:@"%f m",userLocation.location.horizontalAccuracy];
    
    if (userLocation.coordinate.latitude > 0)
        [amapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

- (void)mapView:(MQMapView *)mapView didUpdateHeading:(CLHeading*)newHeading {
    NSLog(@"MapDelegate notified of new heading: %f OR %f", newHeading.trueHeading, newHeading.magneticHeading);
    //headingInDegrees.text = [NSString stringWithFormat:@"%f",newHeading.trueHeading];
}

- (void)mapView:(MQMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"MapDelegate notified of location tracking error");
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma  Annotations Delegates
/////////////////////////////////////////////////////////////////////////////////////////
- (void)mapView:(MQMapView *)mapView annotationView:(MQAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Annotation reporting accessory view tapped");
    
    if (![BSUtils isConnectedToInternet]) {
        return;
    }
    
    if ([view.annotation isKindOfClass:[BuildingAnnotation class]]){
    
        BuildingAnnotation *currentAnnotation = (BuildingAnnotation*)view.annotation;
        
        appDelegate.vcDetailViewContainer.streetName = currentAnnotation.title;
        appDelegate.vcDetailViewContainer.buildingID = currentAnnotation.buildingID;
       // [appDelegate.vcDetailViewContainer downloadBuildingsPlist];
        [appDelegate showRightView];
        
        NSLog(@"isBuildingAnnotation - id: %d", currentAnnotation.buildingID);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Controller got touch");
}


-(MQAnnotationView*)mapView:(MQMapView *)aMapView viewForAnnotation:(id<MQAnnotation>)annotation {
    
    MQAnnotationView *pinView = nil;
    
    if ([annotation isKindOfClass:[BuildingAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString* identifier = @"BuildingAnnotations";
        pinView = (MQAnnotationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MQPinAnnotationView* customPinView = [[MQPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            customPinView.pinColor = MQPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            rightButton.frame = CGRectMake(0, 0, 100, 100);
            customPinView.rightCalloutAccessoryView = rightButton;
            
            if (![self respondsToSelector:@selector(edgesForExtendedLayout)]){
                UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
                customPinView.leftCalloutAccessoryView = leftButton;
            }else
                customPinView.leftCalloutAccessoryView = nil;

            
            pinView = customPinView;
        }
        else
            pinView.annotation = annotation;
    }
    
    
    else if ([annotation isKindOfClass:[MQPointAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* identifier = @"pinAnnotations";
       pinView = (MQPinAnnotationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
       if (!pinView)
        {
            // if an existing pin view was not available, create one
            MQPinAnnotationView* customPinView = [[MQPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:identifier] ;
            customPinView.pinColor = MQPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            
            customPinView.leftCalloutAccessoryView = leftButton;
            pinView = customPinView;
        }
        else
            pinView.annotation = annotation;
        
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)mapView:(MQMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"%d views added to mapview", [views count]);
}

- (void)mapView:(MQMapView *)mapView didSelectAnnotationView:(MQAnnotationView *)view {
        NSLog(@"Annotation View deselected");
}


- (void)mapView:(MQMapView *)mapView didDeselectAnnotationView:(MQAnnotationView *)view {
    NSLog(@"Annotation View deselected");
}

- (void)mapView:(MQMapView *)mapView annotationView:(MQAnnotationView *)view didChangeDragState:(MQAnnotationViewDragState)newState
   fromOldState:(MQAnnotationViewDragState)oldState {
    
}

- (void)reverseGeocoder:(MQReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"Reverse Geocoding FAILED: %@", [error localizedDescription]);
}

- (void)reverseGeocoder:(MQReverseGeocoder *)geocoder didFindPlacemark:(MQPlacemark *)placemark {
    NSLog(@"Reverse Geocode SUCCESS");
    NSLog(@"ADDRESS: %@", [placemark description]);
}




@end
