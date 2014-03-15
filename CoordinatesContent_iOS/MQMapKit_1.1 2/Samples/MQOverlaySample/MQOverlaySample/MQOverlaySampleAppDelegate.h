//
//  MQOverlaySampleAppDelegate.h
//  MQOverlaySample
//
//  Created by Erik Scrafford on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MQOverlaySampleViewController;

@interface MQOverlaySampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MQOverlaySampleViewController *viewController;

@end
