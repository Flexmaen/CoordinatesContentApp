//
//  MQMapTypeSampleViewController.h
//  MQMapTypeSample
//
//  Created by David Gish on 9/21/2011.
//  Copyright 2011 MapQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MQMapKit/MQMapKit.h>

///An internal class to demonstrate the User Location functionality of the MQMapView
@interface MQMapTypeSampleViewController : UIViewController<MQMapViewDelegate> {
    MQMapView *mapView;
    IBOutlet UISegmentedControl *segmentedControl;
    
}

-(IBAction)setMapType:(id)sender;

@end
