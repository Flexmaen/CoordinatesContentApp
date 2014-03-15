//
//  DetailMarkerVC.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 29.03.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "DetailMarkerVC.h"

@interface DetailMarkerVC ()

@end

@implementation DetailMarkerVC

@synthesize lblStreetName;
@synthesize strStreetName;

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
    self.lblStreetName.text = strStreetName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textForStreetLabel:(NSString*)streetName{

    //self.lblStreetName.text = streetName;
}


@end
