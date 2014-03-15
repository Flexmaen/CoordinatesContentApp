//
//  DetailViewContainerVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 03.04.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "DetailViewContainerVC.h"
#import "DetailViewVC.h"
#import "AppDelegate.h"
#import "BSUpdateDBHandler.h"
#import "BSUtils.h"
#import "ImageDetailVC.h"

#import "MBProgressHUD.h"



@interface DetailViewContainerVC ()

@property (nonatomic, retain)IBOutlet UINavigationBar *nvNavBar;

@end

@implementation DetailViewContainerVC

@synthesize lblHeader, svScrollView, buildingID, pcPageControl, streetName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // init the delegate
    
    maDetailViews = [[NSMutableArray alloc] init];
    vcImageDetail = [[ImageDetailVC alloc] init];
     [vcImageDetail redrawView];
    ncImageDetail = [[UINavigationController alloc] initWithRootViewController:vcImageDetail];
    
    isShowingImageDetailView = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    updateHandler = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlist:) name:@"successLoadingPlist" object:updateHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlist:) name:@"errorLoadingPlist" object:updateHandler];

    svScrollView.pagingEnabled = YES;
    
    // layout view if it it is iphone 4/4s, ...
    if (![BSUtils isIphone5]){
        float diffYIphone4 = 568-480;
        self.pcPageControl.frame = CGRectMake(pcPageControl.frame.origin.x, pcPageControl.frame.origin.y-diffYIphone4, self.pcPageControl.frame.size.width, pcPageControl.frame.size.height);
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];
    
      CGRect frame = CGRectMake(0, 0, 300, 44);
    lblTitleView = [[UILabel alloc] initWithFrame:frame];
    lblTitleView.backgroundColor = [UIColor clearColor];
    
    
    lblTitleView.font = [UIFont boldSystemFontOfSize:16.0];
    // label.adjustsFontSizeToFitWidth = YES;
    lblTitleView.textAlignment = NSTextAlignmentLeft;
    lblTitleView.textColor = [UIColor whiteColor];
 
    // emboss in the same way as the native title
   
    [lblTitleView setShadowOffset:CGSizeMake(0, -0.5)];
    [self.navigationController.navigationBar addSubview:lblTitleView];
    
    
    // add left bar button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Zurück", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeViewTapped:)];
   
    self.navigationItem.rightBarButtonItem = backButton;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor darkGrayColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        lblTitleView.textColor = [UIColor darkGrayColor];
    }else{
        self.svScrollView.frame = CGRectMake(0, self.svScrollView.frame.origin.y+22, self.svScrollView.frame.size.width, self.svScrollView.frame.size.height);
         [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
         [lblTitleView setShadowColor:[UIColor lightGrayColor]];
    }


    
   }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.nvNavBar.topItem.title = streetName;
    
    NSString *title = [NSString stringWithFormat:@"  %@", streetName];
    if ([streetName length] == 0)
        title = @" Keine Gebäude ausgewählt ...";
   lblTitleView.text = title;
  
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[self showHUDWithGradient];
    
    if (!isShowingImageDetailView){
        [self downloadBuildingsPlist];
    }else
        isShowingImageDetailView = NO;
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    

    [self removeChildViews];
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWasShown{
   // [vcDetailView downloadBuildingsPlist];
}


-(void)removeChildViews{

    for (int i = 0;i<[maDetailViews count]; i++ ){
        DetailViewVC *tDetailView = [maDetailViews objectAtIndex:i];
        [tDetailView emptyData];
        tDetailView = nil;
        
    }
    
    [maDetailViews removeAllObjects];

}


-(IBAction)closeViewTapped:(id)sender{
    [appDelegate showRightView];
    //[self emptyData];
}

-(IBAction)clickPageControl:(id)sender
{
    int page = pcPageControl.currentPage;
    CGRect frame=svScrollView.frame;
    frame.origin.x=frame.size.width*page;
    frame.origin.y=0;
    [svScrollView scrollRectToVisible:frame animated:YES];
}

-(void)showDetailImageView:(UIImage*)image{

    vcImageDetail.buildingImage = image;
    vcImageDetail.adress = streetName;
  
    //vcImageDetail._ivImage.image = image;
    //vcImageDetail._lblAddress.text = streetName;
 
    [self presentViewController:ncImageDetail animated:YES completion:nil];
   
    
    [vcImageDetail redrawView];
    
    isShowingImageDetailView = YES;
    
}


-(void)updateData{
    
    
    for (int i = 0;i<[maDetailViews count]; i++ ){
        DetailViewVC *tDetailView = [maDetailViews objectAtIndex:i];
        [tDetailView emptyData];
        tDetailView = nil;
        
    }
    
    [maDetailViews removeAllObjects];

 
  //  NSString *description = [[mdBuildingInfo objectForKey:@"0"] objectForKey:@"text"];
   // NSArray *images = [[mdBuildingInfo objectForKey:@"0"] objectForKey:@"images"];
    //NSMutableDictionary *dictImages = [images objectAtIndex:0];
    
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
   // NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];

    [maDetailViews removeAllObjects];
    
    // divide the count, because every building info contains it twice
    //int xmlBugCounter = [mdBuildingInfo count]/2;
    //if (xmlBugCounter < 1) xmlBugCounter = 1;
    
    for (int i = 0; i < [mdBuildingInfo count]; i++) {
		CGRect frame;
		frame.origin.x = self.svScrollView.frame.size.width * i;
		frame.origin.y = 0;
		frame.size = self.svScrollView.frame.size;
        
        DetailViewVC *tDetailView = [[DetailViewVC alloc] init];
        tDetailView.mdBuildingInfo = [mdBuildingInfo objectForKey:[NSString stringWithFormat:@"%d", i]];
        tDetailView.view.frame = frame;
        tDetailView.ptParentViewController= self;
        
        [self.svScrollView addSubview:tDetailView.view];
        [tDetailView updateData];
        [maDetailViews addObject:tDetailView];
        [self.view addSubview:svScrollView];
    }
    
    //float height = [[UIScreen mainScreen] bounds].size.height - self.svScrollView.frame.origin.y;
    //float width = [[UIScreen mainScreen] bounds].size.width;
	

	self.svScrollView.contentSize = CGSizeMake(self.svScrollView.frame.size.width * [mdBuildingInfo count], self.svScrollView.frame.size.height);
    pcPageControl.numberOfPages = [mdBuildingInfo count];
    pcPageControl.currentPage = 0;


}

-(bool)loadBuildingInfoFromFile{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"/SingleBuildings/building_%d.plist", buildingID];
    NSString *filePath = [cachesDir stringByAppendingString:fileName];
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"loadPlistToDictionaryFromSubDirectory: %@", filePath);
	if ([fileManager fileExistsAtPath: filePath]) {
        [mdBuildingInfo removeAllObjects];
        mdBuildingInfo = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        return YES;
    }else
        return NO;
    
    NSLog(@"%@",mdBuildingInfo);
    
}

-(void)downloadBuildingsPlist{
    
    // try to init the data with a already downloaded file
    if ([self loadBuildingInfoFromFile]){
        [self updateData];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:updateHandler];
    
    NSString *downloadUrl = [NSString stringWithFormat:@"action=getBuildingInformation&bid=%d", buildingID];
    NSString *fileName = [NSString stringWithFormat:@"building_%d.plist", buildingID];
    [updateHandler createDestinationPathWithDirectoryName:@"SingleBuildings" andFileName:fileName];
    
    NSLog(@"downloadURL: %@", downloadUrl);
    
    updateHandler.successNotification = @"successLoadingPlist";
    updateHandler.errorNotification = @"errorLoadingPlist";
    //[updateHandler notificationString:@"LoadingGroupMatches"];
    [updateHandler setDownloadUrl:downloadUrl];
    
    [updateHandler startUpdateProcess];
    
}

-(void)successLoadingPlist:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
        
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        
        [self loadBuildingInfoFromFile];
        [self removeChildViews];
        [self updateData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
}

-(void)errorLoadingPlist:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
    
}

/*
-(void)showHUDWithGradient{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(downloadBuildingsPlist) onTarget:self withObject:nil animated:YES];

}*/

#pragma mark -
#pragma mark ScrollView Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	/*if (!pageControlBeingUsed) {
     // Switch the indicator when more than 50% of the previous/next page is visible
     CGFloat pageWidth = self.scrollView.frame.size.width;
     int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
     self.pageControl.currentPage = page;
     }*/
    
    int page = svScrollView.contentOffset.x/svScrollView.frame.size.width;
    pcPageControl.currentPage=page;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
/*
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}*/


@end
