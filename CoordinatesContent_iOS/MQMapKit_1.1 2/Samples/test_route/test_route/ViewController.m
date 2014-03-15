//
//  ViewController.m
//  test_route
//
//  Created by Erik on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    map = [[MQMapView alloc] initWithFrame:self.view.bounds];
    map.mapType = MQMapTypeOpenStandard;
    [self.view addSubview:map];
    
    route = [[MQRoute alloc] init];
    route.delegate = self;
    route.mapView = map;
    route.bestFitRoute = TRUE;
// example of driving using addresses
//  [route getRouteWithStartAddress:@"poulsbo,wa" endAddress:@"seattle, wa"];
//---
    
// example of driving using coordinates
   
    
    CLLocationCoordinate2D poulsbo = CLLocationCoordinate2DMake(39.650594, -104.999754);
    CLLocationCoordinate2D tacoma = CLLocationCoordinate2DMake(39.752267, -104.998986);
    
   [route getRouteWithStartCoordinate:poulsbo endCoordinate:tacoma];
//---
    
    // good walking vs driving example
    route.routeType = MQRouteTypePedestrian;
    CLLocationCoordinate2D denverStart = CLLocationCoordinate2DMake(39.750594, -104.999754);
    CLLocationCoordinate2D denverEnd = CLLocationCoordinate2DMake(39.752267, -104.998986);
    [route getRouteWithStartCoordinate:denverStart endCoordinate:denverEnd];
    //---
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)routeLoadFinished
{
    // get the raw xml passed back from the server:
    NSLog(@"%@", route.rawXML);
    
    // do something with all the maneuvers
    for ( MQManeuver *maneuver in route.maneuvers )
    {
        NSLog(@"%@", maneuver.narrative);
    }
}

@end
