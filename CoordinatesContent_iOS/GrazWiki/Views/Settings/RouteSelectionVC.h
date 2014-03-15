//
//  SettingsVC.h
//  GrazWiki
//
//  Created by Christian Gottitsch on 21.03.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@class AppDelegate, BSUpdateDBHandler;

@interface RouteSelectionVC : UIViewController <IIViewDeckControllerDelegate> {
    AppDelegate *appDelegate;
    
    BSUpdateDBHandler *updateHandler;
    NSMutableDictionary *mdRoutes;
}

@property(nonatomic, retain)IBOutlet UITableView *_tvTable;



@end
