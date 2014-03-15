//
//  ViewController.h
//  test_route
//
//  Created by Erik on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MQMapKit/MQMapKit.h>

@interface ViewController : UIViewController < MQRouteDelegate>
{
    MQMapView *map;
    MQRoute *route;
}
    
@end
