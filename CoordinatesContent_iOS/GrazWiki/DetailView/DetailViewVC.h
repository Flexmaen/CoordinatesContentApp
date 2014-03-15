//
//  DetailViewVC.h
//  GrazWiki
//
//  Created by Christian Gottitsch on 21.01.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate, BSUpdateDBHandler, OverlayView, DetailViewContainerVC;

@interface DetailViewVC : UIViewController <UIScrollViewDelegate>{
    AppDelegate *appDelegate;
    
    BSUpdateDBHandler *updateHandler;
    
    OverlayView *overlayView;
}

@property(nonatomic, retain)NSMutableDictionary *mdBuildingInfo;
@property(nonatomic, retain)IBOutlet UIScrollView *svScrollView;
@property(nonatomic,retain)IBOutlet UILabel *lblHeader;
@property(nonatomic, retain)IBOutlet UITextView *tvDescription;
@property(nonatomic, retain)IBOutlet UIImageView *ivBackgroundImage;
@property(nonatomic, retain)IBOutlet UIPageControl *pcPageControl;
@property(nonatomic, assign)int buildingID;
@property(nonatomic, retain)DetailViewContainerVC *ptParentViewController;

-(void)updateData;
-(void)emptyData;

/*-(void)downloadBuildingsPlist;
-(void)loadBuildingInfoFromFile;
-(void)emptyData;*/

@end
