//
//  MainViewController.h
//  SampleMap : Diagnostic map
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"

#import <MQMapKit/MQMapKit.h>

#import "PDSearchHUD.h"

#import "IIViewDeckController.h"

@class AppDelegate, BSUpdateDBHandler, DetailViewContainerVC;

@interface ViewController : UIViewController <IIViewDeckControllerDelegate, RMMapViewDelegate, MQMapViewDelegate, MQReverseGeocoderDelegate, PDSearchHUDDelegate, MQRouteDelegate>{

    CLLocationCoordinate2D  cllCoordinate2dGraz;
    AppDelegate *appDelegate;
    
    RMAnnotation *ptCurrentActiveAnnotation;
    BSUpdateDBHandler *updateHandler;
    BSUpdateDBHandler *updateHandlerRoute;
    BSUpdateDBHandler *updateHandlerCategories;
    
    IBOutlet MQMapView *map;
    NSMutableArray *maAnnotationArray;
    NSMutableDictionary *mdRegionBuildings;
     NSMutableDictionary *mdCategoryBuildings;
    NSMutableDictionary *mdRoute;
    
    MQPolyline *polyline;
    
    bool isSearchMode;
    bool isSearchCategoriesMode;
    bool isShowingRoute;
    bool isShowingSearchBuilding;
    bool isAllBuildingsSearchMode;
    
    PDSearchHUD *searchHUD;
    PDSearchHUD *searchHUDCategories;
    
}


@property (nonatomic, retain) IBOutlet DetailViewContainerVC *vcDetailViewContainer;
@property (nonatomic, retain) IBOutlet RMMapView *mapView;
@property (nonatomic, retain) IBOutlet UITextView *infoTextView;
@property (nonatomic, retain) IBOutlet UILabel *mppLabel;
@property (nonatomic, retain) IBOutlet UIImageView *mppImage;
@property (nonatomic, retain) IBOutlet UIButton *btnLocate;
@property (nonatomic, retain) IBOutlet UIView *vWarning;
@property (nonatomic, retain) IBOutlet UILabel *lblOSMCopyright;

@property (nonatomic, retain) IBOutlet UIButton *btnRotate;


@property (nonatomic, retain) IBOutlet UIView *vNavigationBar;
@property (nonatomic, retain) IBOutlet UIView *vNavigation;
@property (nonatomic, retain) IBOutlet UIView *vRouteInformation;
@property (nonatomic, retain) IBOutlet UILabel *lblRouteInformation;



-(bool)checkIfUserLocationIsEnabled;
-(void)showEnableUserLoactionDialog;

-(void)setupRouteInformationView;
-(void)showRouteInformation:(NSString*)infoText;
-(void)hideRouteInformation;

// 
-(void)downloadBuildings;
-(void)downloadBuildingsOfCategory:(NSString *)categoryName;

// animation
-(void)animateContextMenuOut;
-(void)animateContextMenuIn;

// adding markers
-(void)addMarkerWithDictionaryItemToAnnotionArray:(NSDictionary*)mdItem AndZoomToMarker:(bool)zoomToMarker;
-(void)addMarkerWithDictionaryItemToAnnotionArray:(NSDictionary*)mdItem;
-(void)addMarkersForRegion;
-(void)addMarkersForRoute;
-(void)addMarkersForCategory;

- (NSString*)encodeURL:(NSString *)string;


// map specific methods
-(void)centerMapAtCoordinate:(CLLocationCoordinate2D)coordinate;

// Actions
- (IBAction)followMeTriggered:(id)sender;
- (IBAction)contextMenuButtonTriggered:(id)sender;
-(IBAction)closeRouteTriggered:(id)sender;

@end
