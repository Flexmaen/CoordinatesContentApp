//
//  DetailViewVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 21.01.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "DetailViewVC.h"
#import "AppDelegate.h"
#import "BSUtils.h"
#import "ImageDetailVC.h"
#import "OverlayView.h"
#import "DetailViewContainerVC.h"

#import "BSUpdateDBHandler.h"
#import <QuartzCore/QuartzCore.h>


@interface DetailViewVC ()

@end

@implementation DetailViewVC

@synthesize lblHeader, buildingID, tvDescription, ivBackgroundImage,svScrollView, mdBuildingInfo, pcPageControl, ptParentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        buildingID = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // init the delegate
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }else{
        // 
    }
    
    updateHandler = [[BSUpdateDBHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoadingPlist:) name:@"successLoadingPlist" object:updateHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorLoadingPlist:) name:@"errorLoadingPlist" object:updateHandler];
    
    // re-layout view for iphone 4/4s
    if (![BSUtils isIphone5]){
        float diffYIphone4 = 568-480;
        self.ivBackgroundImage.frame = CGRectMake(self.ivBackgroundImage.frame.origin.x, self.ivBackgroundImage.frame.origin.y, self.ivBackgroundImage.frame.size.width, ivBackgroundImage.frame.size.height-diffYIphone4);
        
        self.tvDescription.frame = self.tvDescription.frame = CGRectMake(self.tvDescription.frame.origin.x, self.tvDescription.frame.origin.y, self.tvDescription.frame.size.width, tvDescription.frame.size.height-diffYIphone4);
    }
    
    self.svScrollView.pagingEnabled = YES;
    
    ivBackgroundImage.layer.shadowColor = [UIColor blackColor].CGColor;
    ivBackgroundImage.layer.shadowOffset = CGSizeMake(0, 1);
    ivBackgroundImage.layer.shadowOpacity = 1;
    ivBackgroundImage.layer.shadowRadius = 1.0;
    ivBackgroundImage.clipsToBounds = NO;
    
    overlayView = [[NSBundle mainBundle] loadNibNamed:@"OverlayView"owner:self options:nil][0];

    
   /* BSScrollView_PagingViewController *bsScrollView = [[BSScrollView_PagingViewController alloc] init];
    bsScrollView.view.backgroundColor = [UIColor greenColor];
    bsScrollView.view.frame = CGRectMake(0,0, 320, 480);
    [self.view addSubview:bsScrollView.view];*/
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   //[self emptyData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void)emptyData{
    tvDescription.text = @"";
    
    
    // With some valid UIView *view:
    for(UIView *subview in self.view.subviews) {
        [subview performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }
    [overlayView removeFromSuperview];

}

/////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma 
/////////////////////////////////////////////////////////////////////////////////////////
-(void)updateData{
    NSString *description = [mdBuildingInfo objectForKey:@"text"];
    NSString *title = [mdBuildingInfo objectForKey:@"title"];
    if ([title length] <= 0) title = @" Beschreibung";
    else title = [NSString stringWithFormat:@" %@", title];
    
    NSArray *images = [mdBuildingInfo objectForKey:@"images"];
    //NSMutableDictionary *dictImages = [images objectAtIndex:0];
    
    tvDescription.text = description;
    lblHeader.text = title;
    
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
  
    //NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
	for (int i = 0; i < [images count]; i++) {
		CGRect frame;
		frame.origin.x = self.svScrollView.frame.size.width * i;
		frame.origin.y = 0;
		frame.size = self.svScrollView.frame.size;
		
        NSMutableDictionary *dictImages = [images objectAtIndex:i];
        NSString *imagename = [dictImages objectForKey:@"image"];
        /*UIImage *image = [UIImage imageNamed:imagename];
        
        if (image == nil){
            NSLog(@"image not found: %@", imagename);
            
        }*/

		//UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        UIButton *buttonImageView = [[UIButton alloc] initWithFrame:frame];
       // imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *ImageURL = [NSString stringWithFormat:@"http://www.server.url/%@", imagename];
       // NSString *ImageURL = [NSString stringWithFormat:@"http://www.server.url/communication/images/%@", imagename];
        NSLog(@"imageUrl: %@", ImageURL);
      
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:ImageURL]];
        bool valid = [NSURLConnection canHandleRequest:req];
        NSData *imageData = nil;
        if (valid){
           imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        }else{
            NSLog(@"url is INvalid");
        }
        
        [buttonImageView addTarget:self action:@selector(imageButtonTriggered:) forControlEvents:UIControlEventTouchUpInside];
        [buttonImageView setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        [buttonImageView setImage:[UIImage imageWithData:imageData] forState:UIControlEventTouchUpInside];
        [[buttonImageView imageView] setContentMode:UIViewContentModeScaleAspectFit];
       // imageView.image = [UIImage imageWithData:imageData];
  
	//	[self.svScrollView addSubview:imageView];
        [self.svScrollView addSubview:buttonImageView];
    
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(self.svScrollView.frame.size.width * i, buttonImageView.frame.size.height-20, buttonImageView.frame.size.width, 20)];
        lblDescription.text = [NSString stringWithFormat:@"  %@", [dictImages objectForKey:@"description"]];
        lblDescription.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:0.34];
        lblDescription.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        lblDescription.textColor = [UIColor whiteColor];
        [self.svScrollView addSubview:lblDescription];
        
	}
	
	self.svScrollView.contentSize = CGSizeMake(self.svScrollView.frame.size.width * [images count], self.svScrollView.frame.size.height);
    pcPageControl.numberOfPages = [images count];
    pcPageControl.currentPage = 0;
}


-(IBAction)closeViewTapped:(id)sender{
    [appDelegate showRightView];
    [self emptyData];
}

-(IBAction)imageButtonTriggered:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    UIImage *image = [button imageForState:UIControlStateNormal];
        
    // hack! cast the parent view to the detailview container and access the parent view
    // in a quick an dirty way to sho the detail image view!
    //DetailViewContainerVC *tDVC = (DetailViewContainerVC*)self.parentViewController;
    //[tDVC showDetailImageView:image];
    [ptParentViewController showDetailImageView:image];
    
    
       
    //[self.navigationController presentModalViewController:vcImageDetail animated:NO];
    

   
   /* [overlayView setupImageView:image];
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.view addSubview:overlayView];
                    }
                    completion:nil];*/

}

-(IBAction)clickPageControl:(id)sender
{
    int page = pcPageControl.currentPage;
    CGRect frame=svScrollView.frame;
    frame.origin.x=frame.size.width*page;
    frame.origin.y=0;
    [svScrollView scrollRectToVisible:frame animated:YES];
}

/*
-(void)loadBuildingInfoFromFile{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"/SingleBuildings/building_%d.plist", buildingID];
    NSString *filePath = [cachesDir stringByAppendingString:fileName];
    mdBuildingInfo = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
  
    NSLog(@"%@",mdBuildingInfo);

}

-(void)downloadBuildingsPlist{
    
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
    [self loadBuildingInfoFromFile];
    [self updateData];

}

-(void)errorLoadingPlist:(NSNotification *)notification{
    NSLog(@"successLoadingPlist");
    
}*/

@end
