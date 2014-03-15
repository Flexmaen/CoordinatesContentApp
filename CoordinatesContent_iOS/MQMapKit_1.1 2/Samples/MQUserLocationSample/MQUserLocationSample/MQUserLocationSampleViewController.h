//
//  MQUserLocationSampleViewController.h
//  MQUserLocationSample
//
//  Created by Ty Beltramo on 7/19/11.
//  Copyright 2011 MapQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MQMapKit/MQMapKit.h>

///An internal class to demonstrate the User Location functionality of the MQMapView
@interface MQUserLocationSampleViewController : UIViewController<MQMapViewDelegate> {
    MQMapView *mapView;
    IBOutlet UISwitch *locationSwitch;
    IBOutlet UILabel *accuracyInMeters;
    
    IBOutlet UISwitch *headingSwitch;
    IBOutlet UILabel *headingInDegrees;
}

-(IBAction)toggleUserLocation:(id)sender;
-(IBAction)toggleHeading:(id)sender;
-(IBAction)recenterMap:(id)sender;
@end
