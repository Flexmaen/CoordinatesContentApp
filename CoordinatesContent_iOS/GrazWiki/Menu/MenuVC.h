//
//  MenuVC.h
//  GrazWiki
//
//  Created by Christian Gottitsch on 10.01.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface MenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSMutableArray *maMenuItems;
    NSMutableArray *maMenuSubItems;
      AppDelegate *appDelegate;
    
    NSMutableArray *sectionHeaders;
    NSMutableArray *sectionFooters;
}

@property(nonatomic, retain)IBOutlet UITableView *tvTableView;

@end
