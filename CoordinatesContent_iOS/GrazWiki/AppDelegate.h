//
//  AppDelegate.h
//  ViewDeckExample
//

#import <UIKit/UIKit.h>


@class ViewController, IIViewDeckController, DetailViewVC, DetailViewContainerVC, BSUpdateDBHandler, RouteSelectionVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

    NSMutableDictionary *mdSettings;
    ViewController *mapViewController;
    //DetailViewVC* vcDetailView;
    UINavigationController *mapNavController;
    
    NSMutableDictionary *mdAllBuildings;
    NSMutableDictionary *mdAllRoutes;
    NSMutableDictionary *mdAllCategories;
    
    BSUpdateDBHandler *updateHandler;
    BSUpdateDBHandler *updateHandlerRoutes;
    BSUpdateDBHandler *updateHandlerCategories;
    
    UINavigationController *ncMenu;
    
    RouteSelectionVC* routeSelectionController;

    
}

-(void)menuButtonMainViewTriggered;
-(void)showRightView;
-(void)downloadAllBuildingsPlist;
-(void)downloadRoutes;
-(void)downloadAllCategories;

-(void)setCurrentViewMode:(int)viewMode;
-(int)getCurrentViewMode;
-(void)createSearchArray;
-(void)createSearchArrayCategories;
-(void)routeWasSelected:(int)routeID;

-(NSMutableDictionary*)loadFileForDictionaryWithFilename :(NSString*)fileName;
-(NSMutableDictionary*)loadPlistToDictionaryFromSubDirectory:(NSString*)subDirectory AndFileName:(NSString*)fileName;


@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) NSMutableDictionary *mdAllRoutes;

@property (retain, nonatomic) NSMutableDictionary *mdAllBuildings;
@property (retain, nonatomic) NSMutableArray *searchArray;
@property (retain, nonatomic) NSMutableArray *searchArrayCategories;
@property (retain, nonatomic) DetailViewContainerVC *vcDetailViewContainer;
@property (retain, nonatomic) DetailViewVC *vcDetailView;
@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;
@property (retain, nonatomic) UIViewController *imageController;
@property (retain, nonatomic) IIViewDeckController* deckController;

@property (assign, nonatomic) bool isRouteMode;
@property (assign, nonatomic) int routeid;

@end
