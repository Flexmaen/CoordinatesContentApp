//
//  AppDelegate.m
//  ViewDeckExample
//


#import "AppDelegate.h"
#import "Definitions.h"

#import "ViewController.h"
#import "IIViewDeckController.h"
#import "MenuVC.h"
#import "ImpressumVC.h"
#import "DetailViewVC.h"
#import "DetailViewContainerVC.h"
#import "RouteSelectionVC.h"
//#import "RightViewController.h"

#import "BSUpdateDBHandler.h"
#import "BSFileIOHandler.h"

#import "GWUtils.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize centerController = _viewController;
@synthesize leftController = _leftController;
@synthesize imageController = _imageController;
@synthesize deckController = _deckController;

@synthesize vcDetailView, vcDetailViewContainer;

@synthesize mdAllBuildings, searchArray, mdAllRoutes, isRouteMode, searchArrayCategories, routeid;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    isRouteMode = NO;
    
    
    routeSelectionController = [[RouteSelectionVC alloc] init];
    mapViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    mapNavController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    MenuVC *vcMenu = [[MenuVC alloc] initWithNibName:@"MenuVC" bundle:nil];
    ncMenu = [[UINavigationController alloc] initWithRootViewController:vcMenu];
    
    self.leftController = ncMenu;
    vcDetailViewContainer = [[DetailViewContainerVC alloc] initWithNibName:@"DetailViewContainerVC" bundle:nil];
    UINavigationController *ncDetailView = [[UINavigationController alloc] initWithRootViewController:vcDetailViewContainer];

   
    self.centerController = mapNavController;
    self.deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.centerController
                                                                                    leftViewController:self.leftController
                                                                                   rightViewController:ncDetailView];
    self.deckController.rightSize = 0;
    self.deckController.leftSize = 50;
    
    /* To adjust speed of open/close animations, set either of these two properties. */
    // deckController.openSlideAnimationDuration = 0.15f;
    // deckController.closeSlideAnimationDuration = 0.5f;
    
    updateHandler = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlist:) name:@"successLoadingPlist" object:updateHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlist:) name:@"errorLoadingPlist" object:updateHandler];

    updateHandlerRoutes = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlistAllRoutes:) name:@"successLoadingPlistAllRoutes" object:updateHandlerRoutes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlistAllRoutes:) name:@"errorLoadingPlistAllRoutes" object:updateHandlerRoutes];

    
    updateHandlerCategories = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlistAllCategories:) name:@"successLoadingPlistAllCategories" object:updateHandlerCategories];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlistAllCategories:) name:@"errorLoadingPlistAllCategories" object:updateHandlerCategories];

    
    /* create directories on the disk/flash */
    [BSFileIOHandler createDirectoryInCachesFolderWithName:@"Buildings"];
    [BSFileIOHandler createDirectoryInCachesFolderWithName:@"SingleBuildings"];
    [BSFileIOHandler createDirectoryInCachesFolderWithName:@"Routes"];
    [BSFileIOHandler createDirectoryInCachesFolderWithName:@"Categories"];

    
    /* load the default buildingsfile */
    mdAllBuildings =  [self loadFileForDictionaryWithFilename:@"allbuildings"];
    mdAllRoutes =  [self loadFileForDictionaryWithFilename:@"allroutes"];
    mdAllCategories =  [self loadFileForDictionaryWithFilename:@"allcategories"];
    searchArray = [[NSMutableArray alloc] init];
    searchArrayCategories = [[NSMutableArray alloc] init];
    
    [self createSearchArray];
    [self createSearchArrayCategories];
    
    [self downloadAllBuildingsPlist];
    [self downloadRoutes];
    [self downloadAllCategories];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(infoTriggered:)
     name:@"infoTriggered"
     object:vcMenu];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(mapViewTriggered:)
     name:@"mapViewTriggered"
     object:vcMenu];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(settingsTriggered:)
     name:@"settingsTriggered"
     object:vcMenu];
    
    mdSettings = [[NSMutableDictionary alloc] init];
    [self setCurrentViewMode:VS_MAP];
    
    self.window.rootViewController = self.deckController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    
    [self downloadAllBuildingsPlist];
    [self downloadRoutes];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)createSearchArray{
    
    [searchArray removeAllObjects];
    NSEnumerator *enumerator = [mdAllBuildings keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        NSDictionary *tmp = [mdAllBuildings objectForKey:key];
        [searchArray addObject:[tmp objectForKey:@"title"]];
    }

}


-(void)createSearchArrayCategories{
    
    [searchArrayCategories removeAllObjects];
    for (int i=0;i<[mdAllCategories count]; i++){
        [searchArrayCategories addObject:[mdAllCategories objectForKey:[NSString stringWithFormat:@"%d", i]]];
    }
    
}


-(void)showRightView{
    [self.deckController toggleRightViewAnimated:YES];
    //[vcDetailViewContainer viewWasShown];
}

-(void)menuButtonMainViewTriggered{
    [self.deckController toggleLeftViewAnimated:YES];
}

-(void)routeWasSelected:(int)routeID{
    [self.deckController toggleLeftViewAnimated:YES];
    
    isRouteMode = YES;
    routeid = routeID;
    
    if ([self getCurrentViewMode] != VS_MAP){
        self.deckController.centerController = mapNavController;
    }
    
    [self setCurrentViewMode:VS_MAP];
    
    self.deckController.closeSlideAnimationDuration = 0.55f;
    [self.deckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        // TODO: ??
        
    }];
}

-(void)infoTriggered:(NSNotification *)notification{
    
    isRouteMode = NO;
    
    if ([self getCurrentViewMode] != VS_INFO){
        UIViewController* newController = [[ImpressumVC alloc] init];
        UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:newController];
        self.deckController.centerController = newNavController;
    }

    [self setCurrentViewMode:VS_INFO];
    
    self.deckController.closeSlideAnimationDuration = 0.55f;
    [self.deckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        // TODO: ??
        
    }];

    
    /* TODO: Show the mainview controller here with animations */
}

-(void)mapViewTriggered:(NSNotification *)notification{
    

    
    if ([self getCurrentViewMode] != VS_MAP){
        self.deckController.centerController = mapNavController;
    }
    
    [self setCurrentViewMode:VS_MAP];
    
    self.deckController.closeSlideAnimationDuration = 0.55f;
    [self.deckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        // TODO: ??
        
    }];

    
    /* TODO: Show the mainview controller here with animations */

}

-(void)settingsTriggered:(NSNotification *)notification{
    
    if ([self getCurrentViewMode] != VS_SETTINGS){
        
        UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:routeSelectionController];
        self.deckController.centerController = newNavController;
    }
    
    [self setCurrentViewMode:VS_SETTINGS];
    
    self.deckController.closeSlideAnimationDuration = 0.55f;
    [self.deckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        // TODO: ??
        
    }];
    
}

-(void)downloadAllBuildingsPlist{
    
    [[NSNotificationCenter defaultCenter] removeObserver:updateHandler];
    
    NSString *downloadUrl = [NSString stringWithFormat:@"action=getAllBuildings"];
    NSString *fileName = [NSString stringWithFormat:@"allbuildings.plist"]; //, lastShownGender, currentDiscipline];
    [updateHandler createDestinationPathWithDirectoryName:@"Buildings" andFileName:fileName];
    updateHandler.successNotification = @"successLoadingPlist";
    updateHandler.errorNotification = @"errorLoadingPlist";
    [updateHandler setDownloadUrl:downloadUrl];
    [updateHandler startUpdateProcess];
    
}

-(void)successLoadingPlist:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
    // reinit the array with all buildings after successfull download
    NSMutableDictionary *tDict = [self loadPlistToDictionaryFromSubDirectory:@"Buildings" AndFileName:@"allbuildings.plist"];
    if (tDict != nil){
        mdAllBuildings = tDict;
        [self createSearchArray];
    }
}

-(void)errorLoadingPlist:(NSNotification *)notification{
    NSLog(@"errorLoadingPlist");

}

-(void)downloadAllCategories{
    
    NSString *downloadUrl = [NSString stringWithFormat:@"action=getAllCategories"];
    NSString *fileName = [NSString stringWithFormat:@"allcategories.plist"]; //, lastShownGender, currentDiscipline];
    [updateHandlerCategories createDestinationPathWithDirectoryName:@"Categories" andFileName:fileName];
    
    NSLog(@"downloadURL: %@", downloadUrl);
    
    updateHandlerCategories.successNotification = @"successLoadingPlistAllCategories";
    updateHandlerCategories.errorNotification = @"errorLoadingPlistAllCategories";
    //[updateHandler notificationString:@"LoadingGroupMatches"]
    [updateHandlerCategories setDownloadUrl:downloadUrl];
    
    [updateHandlerCategories startUpdateProcess];
    
}


-(void)successLoadingPlistAllRoutes:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Routes/allroutes.plist"];
    //[ removeAllObjects];
    mdAllRoutes = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    NSLog(@"mdAllRoutes: %@", mdAllRoutes);
    
}

-(void)errorLoadingPlistAllRoutes:(NSNotification *)notification{
    NSLog(@"errorLoadingPlist");
    
    // if there is no connection to the internet show warining view
    /*  if (![BSUtils isConnectedToInternet]){
     [YRDropdownView showDropdownInView:vWarning
     title:@"Achtung"
     detail:@"Fehler beim Herunterladen der Daten! Bitte überprüfen Sie ihre Internetverbindung."
     image:[UIImage imageNamed:@"dropdown-alert"]
     animated:NO
     hideAfter:0.0];
     }*/
}

-(void)downloadRoutes{
    
    NSString *downloadUrl = [NSString stringWithFormat:@"action=getAllRoutes"];
    NSString *fileName = [NSString stringWithFormat:@"allroutes.plist"]; //, lastShownGender, currentDiscipline];
    [updateHandlerRoutes createDestinationPathWithDirectoryName:@"Routes" andFileName:fileName];
    
    NSLog(@"downloadURL: %@", downloadUrl);
    
    updateHandlerRoutes.successNotification = @"successLoadingPlistAllRoutes";
    updateHandlerRoutes.errorNotification = @"errorLoadingPlistAllRoutes";
    //[updateHandler notificationString:@"LoadingGroupMatches"]
    [updateHandlerRoutes setDownloadUrl:downloadUrl];
    
    [updateHandlerRoutes startUpdateProcess];
    
}

-(void)successLoadingPlistAllCategories:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Categories/allcategories.plist"];
    //[ removeAllObjects];
    mdAllCategories = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [self createSearchArrayCategories];
    NSLog(@"mdAllCategories: %@", mdAllCategories);
    
}

-(void)errorLoadingPlistAllCategories:(NSNotification *)notification{
    NSLog(@"errorLoadingPlist");
    
    // if there is no connection to the internet show warining view
    /*  if (![BSUtils isConnectedToInternet]){
     [YRDropdownView showDropdownInView:vWarning
     title:@"Achtung"
     detail:@"Fehler beim Herunterladen der Daten! Bitte überprüfen Sie ihre Internetverbindung."
     image:[UIImage imageNamed:@"dropdown-alert"]
     animated:NO
     hideAfter:0.0];
     }*/
}


/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma mark File Operations
/////////////////////////////////////////////////////////////////////////////////////////

-(NSMutableDictionary*)loadFileForDictionaryWithFilename:(NSString*)fileName{
    
    NSMutableDictionary *returnDict;
    NSString *longFilename = [NSString stringWithFormat:@"%@.plist", fileName];
    // load the save data from plist
    
    NSString *cachesDirectory = [BSFileIOHandler applicationCachesDirectory];
    NSString *filePath =  [cachesDirectory stringByAppendingPathComponent:longFilename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"SettingsFilePath: %@", filePath);
	if (![fileManager fileExistsAtPath: filePath]) {
		//Copy the file from the app bundle.
		NSString * defaultPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
		[fileManager copyItemAtPath:defaultPath toPath:filePath error:NULL];
		returnDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	}else{
		returnDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	}
    
    return returnDict;
    
}

-(NSMutableDictionary*)loadPlistToDictionaryFromSubDirectory:(NSString*)subDirectory AndFileName:(NSString*)fileName{
    
    NSMutableDictionary *returnDict = nil;
    
    NSString *cachesDirectory = [BSFileIOHandler applicationCachesDirectory];
    NSString *filePath = [cachesDirectory stringByAppendingPathComponent:subDirectory];
    filePath =  [filePath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"loadPlistToDictionaryFromSubDirectory: %@", filePath);
	if ([fileManager fileExistsAtPath: filePath]) {
        returnDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	}
    return returnDict;
    
}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma mark Get and Set the Current View Mode
/////////////////////////////////////////////////////////////////////////////////////////
-(void)setCurrentViewMode:(int)viewMode{
    [mdSettings setObject:[NSString stringWithFormat:@"%d", viewMode] forKey:@"viewMode"];
}

-(int)getCurrentViewMode{
    int mode = [[mdSettings objectForKey:@"viewMode"] intValue];
    return mode;
}





@end
