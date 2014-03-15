//
//  ImageDetailVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 10.06.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "ImageDetailVC.h"
#import "BSUtils.h"
#import "GWUtils.h"

@interface ImageDetailVC ()



@end

@implementation ImageDetailVC

@synthesize _ivImage, _btnClose, _lblAddress, buildingImage, adress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.buildingImage = nil;
        self.adress = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
       // self._btnClose.backgroundColor = [GWUtils yellowColor];
    }


    
    //setup view depending on device
    if (![BSUtils isIphone5]){
        self._btnClose.frame = CGRectMake(self._btnClose.frame.origin.x, self._btnClose.frame.origin.y-88, self._btnClose.frame.size.width, self._btnClose.frame.size.height);
        self._lblDescription.frame = CGRectMake(self._lblDescription.frame.origin.x, self._lblDescription.frame.origin.y-88, self._lblDescription.frame.size.width, self._lblDescription.frame.size.height);

        self._ivImage.frame = CGRectMake(self._ivImage.frame.origin.x, self._ivImage.frame.origin.y, self._ivImage.frame.size.width, self._ivImage.frame.size.height-88);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)redrawView{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:105.0/255.0 green:111.0/255.0 blue:125.0/255.0 alpha:1.0];

    self._ivImage.image = buildingImage;
    self.title = adress;
    [self.view setNeedsDisplay];
}

-(IBAction)closeTriggered:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
