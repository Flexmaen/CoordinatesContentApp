//
//  mapsdktestViewController.h
//  mapsdktest
//
//  Created by Administrator on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MQMapKit/MQMapKit.h>

///An internal class to demonstrate a map view controller
@interface MQMapViewController : UIViewController<MQMapViewDelegate, MQReverseGeocoderDelegate>
{
    IBOutlet MQMapView *mapView;
    IBOutlet UIView *smallView;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *removeButton;
    id<MQAnnotation> annot;
}

@property (nonatomic, retain) IBOutlet MQMapView *mapView;

-(IBAction)addAnnotation:(id)sender;
-(IBAction)removeAnnotation:(id)sender;

@end
