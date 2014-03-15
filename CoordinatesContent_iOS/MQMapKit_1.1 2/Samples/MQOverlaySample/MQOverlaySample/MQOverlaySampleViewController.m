//
//  MQOverlaySampleViewController.m
//  MQOverlaySample
//
//  Created by Erik Scrafford on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MQOverlaySampleViewController.h"

@implementation MQOverlaySampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    map = [[MQMapView alloc] initWithFrame:self.view.bounds];
    map.delegate = self;
    [self.view addSubview:map];
    
    CLLocationCoordinate2D centerOfBainbridge = CLLocationCoordinate2DMake(47.63856, -122.542877);
    [map setCenterCoordinate:centerOfBainbridge];
    // bainbridge island is about 6km wide
    MQCircle *circle = [MQCircle circleWithCenterCoordinate:centerOfBainbridge radius:3000];
    [map addOverlay:circle];
    
    // sportsman/finch triangle
    CLLocationCoordinate2D polyCoords[] = {CLLocationCoordinate2DMake(47.635928, -122.537139),
                                           CLLocationCoordinate2DMake(47.635899, -122.534564),
                                           CLLocationCoordinate2DMake(47.632327, -122.537032)};
    MQPolygon *polygon = [MQPolygon polygonWithCoordinates:polyCoords count:3];
    [map addOverlay:polygon];
    [map setRegion:MQCoordinateRegionBetweenCoords(CLLocationCoordinate2DMake(47.68, -122.55), CLLocationCoordinate2DMake(47.6, -122.545))];
    
    [super viewDidLoad];
}

- (MQOverlayView *)mapView:(MQMapView *)mapView viewForOverlay:(id <MQOverlay>)overlay
{
    if ( [overlay isKindOfClass:[MQCircle class]] )
    {
        MQCircle *circleOverlay = (MQCircle *)overlay;
        MQCircleView *circleView = [[MQCircleView alloc] initWithCircle:circleOverlay];
        circleView.fillColor = [UIColor colorWithRed:0.1 green:1 blue:0.4 alpha:0.2];
        circleView.strokeColor = [UIColor colorWithRed:0.3 green:0.9 blue:0.7 alpha:1];
        circleView.lineWidth = 3.0;
        return circleView;
    }
    if ( [overlay isKindOfClass:[MQPolygon class]] )
    {
        MQPolygon *polygonOverlay = (MQPolygon *)overlay;
        MQPolygonView *polygonView = [[MQPolygonView alloc] initWithPolygon:polygonOverlay];
        
        polygonView.strokeColor = [UIColor purpleColor];
        polygonView.lineWidth = 3.0;
        return polygonView;
    }
    NSLog(@"Failed to create view for overlay!");
    return nil;
}

@end
