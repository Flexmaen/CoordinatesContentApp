//
//  MapViewVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 28.12.12.
//  Copyright (c) 2012 Christian Gottitsch. All rights reserved.
//

#import "MapViewVC.h"

@interface MapViewVC ()

@end

@implementation MapViewVC

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
    
    map = [[MQMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:map];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
