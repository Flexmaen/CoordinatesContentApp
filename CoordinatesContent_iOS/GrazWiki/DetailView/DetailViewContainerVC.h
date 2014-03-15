//
//  DetailViewContainerVC.h
//  GrazWiki
//
//  Created by Christian Gottitsch on 03.04.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DetailViewVC, AppDelegate, BSUpdateDBHandler, ImageDetailVC;

@interface DetailViewContainerVC : UIViewController  {
    DetailViewVC *vcDetailView;
    AppDelegate *appDelegate;
    
    BSUpdateDBHandler *updateHandler;
    NSMutableDictionary *mdBuildingInfo;
    NSMutableArray *maDetailViews;
    
    UILabel *lblTitleView;
    
    ImageDetailVC *vcImageDetail;
    UINavigationController *ncImageDetail;
    
    bool isShowingImageDetailView;

}

-(void)showDetailImageView:(UIImage*)image;
-(void)viewWasShown;
-(void)downloadBuildingsPlist;
-(bool)loadBuildingInfoFromFile;
-(void)updateData;
//-(void)showHUDWithGradient;

-(IBAction)clickPageControl:(id)sender;
-(IBAction)closeViewTapped:(id)sender;

@property (nonatomic, strong) NSString *streetName;
@property(nonatomic, retain)IBOutlet UIPageControl *pcPageControl;
@property(nonatomic, retain)IBOutlet UIScrollView *svScrollView;
@property(nonatomic,retain)IBOutlet UILabel *lblHeader;
@property(nonatomic,assign)int buildingID;



@end
