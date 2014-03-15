//
//  MQMapTypeSampleViewController.m
//  MQMapTypeSample
//
//  Created by David Gish on 9/21/2011.
//  Copyright 2011 MapQuest. All rights reserved.
//

#import "MQMapTypeSampleViewController.h"

@implementation MQMapTypeSampleViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect mapFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //Setup the map view
    mapView = [[MQMapView alloc] initWithFrame:mapFrame];
    mapView.delegate = self;
    
    //Position the map at a point
//    MQMapPoint origin = MQMapPointForCoordinate(CLLocationCoordinate2DMake(42.822842, -83.267934));
//    MQMapPoint maxPt = MQMapPointForCoordinate(CLLocationCoordinate2DMake(42.754468, -83.214247));
    segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:mapView];
    [self.view sendSubviewToBack:mapView];
    
//    MQMapRect rect = MQMapRectMake(origin.x, origin.y, maxPt.x - origin.x, maxPt.y - origin.y);
//    
//    [mapView setVisibleMapRect:rect animated:NO];
}

- (void)viewDidUnload
{
       
    [super viewDidUnload];
    
}


-(IBAction)setMapType:(id)sender {
  UISegmentedControl* control = sender;
  switch (control.selectedSegmentIndex) {
    case 1:
      mapView.mapType = MQMapTypeSatellite;
      break;
    case 2:
      mapView.mapType = MQMapTypeHybrid;
      break;
    default:
      mapView.mapType = MQMapTypeStandard;
      break;
  }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

@end
