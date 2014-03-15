//
//  mapsdktestViewController.m
//  mapsdktest
//
//  Created by Administrator on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MQMapViewController.h"
#import "BusinessAnnotation.h"
#import "ResidentialAnnotation.h"
#import "PlaceAnnotation.h"

@implementation MQMapViewController
@synthesize mapView;

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
    CGRect mapFrame = CGRectMake(0, 00, smallView.frame.size.width, smallView.frame.size.height);

    
    //Setup the map view
    mapView = [[MQMapView alloc] initWithFrame:mapFrame];
    mapView.delegate = self;
    mapView.backgroundColor = [UIColor greenColor];
    mapView.mapZoomLevel = 18;
    //Position the map at a point
  //  [mapView setCenterCoordinate:CLLocationCoordinate2DMake (42.822842, -83.267934)]; 

    [smallView addSubview:mapView];
    [mapView release];
    
}

-(IBAction)addAnnotation:(id)sender {
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(42.82278, -83.26849)];

    //Create four standard pin Icons with various accessory views and one custom annoation 
    NSMutableArray *someAnnotations = [[NSMutableArray alloc] initWithCapacity:4];
    
    id annotation;
    annotation = [[BusinessAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.821302, -83.273421) 
                                                          title:@"Detroit Athletic Club"
                                                       subTitle:@""];
    [someAnnotations addObject:annotation];
    [annotation release];
    
    annotation = [[BusinessAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.824, -83.269) 
                                                          title:@"The Hamburger Mansion"
                                                       subTitle:@"91 Dennison St, Oxford, MI 48371"];
    [someAnnotations addObject:annotation];
    [annotation release];
    
    annotation = [[PlaceAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.82, -83.268) 
                                                       title:@"Oxford Village Offices"
                                                    subTitle:@"10 West Burdick St, Oxford, MI 48371"];
    [someAnnotations addObject:annotation];
    [annotation release];
    
    annotation = [[ResidentialAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.8229, -83.27) 
                                                             title:@"John Doe"
                                                          subTitle:@"25 Pontiac St, Oxford, MI 48371"];
    [someAnnotations addObject:annotation];
    [annotation release];
    
    annotation = [[MQPointAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.825, -83.267) 
                                                         title:@"Frosty's Ice Cream"
                                                      subTitle:@"Village Plaza"];
    [someAnnotations addObject:annotation];
    [annotation release];
    
    
    [mapView addAnnotations:someAnnotations];
    [someAnnotations release];
    
    CLLocationCoordinate2D *innerCoords = malloc(sizeof(CLLocationCoordinate2D) * 3);
    
    innerCoords[2] = CLLocationCoordinate2DMake(42.824418, -83.265256);
    innerCoords[1] = CLLocationCoordinate2DMake(42.823536, -83.264339);
    innerCoords[0] = CLLocationCoordinate2DMake(42.823557, -83.265185);
    
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * 4);
    
    coords[0] = CLLocationCoordinate2DMake(42.824729, -83.265812);
    coords[1] = CLLocationCoordinate2DMake(42.824748, -83.265006);
    coords[2] = CLLocationCoordinate2DMake(42.823383, -83.263843);
    coords[3] = CLLocationCoordinate2DMake(42.822932, -83.265459);

    MQPolygon *innerPoly = [MQPolygon polygonWithCoordinates:innerCoords count:3];
    MQPolygon *polygon = [MQPolygon polygonWithCoordinates:coords count:4 interiorPolygons:[NSArray arrayWithObject:innerPoly]];
    

    
    CLLocationCoordinate2D *coord2 = malloc(sizeof(CLLocationCoordinate2D) * 4);
    
    coord2[0] = CLLocationCoordinate2DMake(42.823289, -83.272745);
    coord2[1] = CLLocationCoordinate2DMake(42.820194, -83.272745);
    coord2[2] = CLLocationCoordinate2DMake(42.820194, -83.269788);
    coord2[3] = CLLocationCoordinate2DMake(42.823289, -83.269788);
    
    MQPolygon *polygon2 = [MQPolygon polygonWithCoordinates:coord2 count:4];
    
    
        
    CLLocationCoordinate2D *lineCoords = malloc(sizeof(CLLocationCoordinate2D) * 3);
    lineCoords[0] = CLLocationCoordinate2DMake(42.821780, -83.274466);
    lineCoords[1] = CLLocationCoordinate2DMake(42.820547, -83.272105);
    lineCoords[2] = CLLocationCoordinate2DMake(42.824152, -83.264040);
    
    MQPolyline *line = [MQPolyline polylineWithCoordinates:lineCoords count:3];
    
    
    MQCircle *circle = [MQCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(42.821302, -83.273421) radius:151.42];
    
    [mapView addOverlay:polygon];
    [mapView addOverlay:line];
    [mapView addOverlay:polygon2];
    //[mapView addOverlay:circle];
    
    [mapView insertOverlay:circle aboveOverlay:line];
}

-(IBAction)removeAnnotation:(id)sender {
    
    NSArray *someAnnotations = [mapView annotations];
    [mapView removeAnnotations:someAnnotations];
    
    NSArray *someOverlays = [mapView overlays];
    [mapView removeOverlays:someOverlays];
}

- (void)mapView:(MQMapView *)mapView annotationView:(MQAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Annotation reporting accessory view tapped");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Controller got touch");    
}


-(MQAnnotationView*)mapView:(MQMapView *)aMapView viewForAnnotation:(id<MQAnnotation>)annotation {
    
    MQAnnotationView *pinView = nil;
    
    if ([annotation isKindOfClass:[BusinessAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString* identifier = @"BusinessAnnotations";
        pinView = (MQAnnotationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MQPinAnnotationView* customPinView = [[[MQPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            customPinView.pinColor = MQPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            customPinView.leftCalloutAccessoryView = leftButton;
            
            pinView = customPinView;
        }
        else
            pinView.annotation = annotation;
    }
    
    else if ([annotation isKindOfClass:[ResidentialAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString* identifier = @"ResidentialAnnotations";
        pinView = (MQAnnotationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MQPinAnnotationView* customPinView = [[[MQPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            customPinView.pinColor = MQPinAnnotationColorGreen;
            customPinView.animatesDrop = NO;
            customPinView.canShowCallout = YES;
            
            pinView = customPinView;
        }
        else
            pinView.annotation = annotation;        
    }
    
    else if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString* identifier = @"PlaceAnnotations";
        pinView = (MQAnnotationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MQAnnotationView* customPinView = [[[MQAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
          
            customPinView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            UIImage *customIcon = [UIImage imageNamed:@"sign"];
            customPinView.image = customIcon;
            
            //Use the same icon for the left accessory view, just to show you can put custom content there, too
            UIImageView *leftAccessoryView = [[UIImageView alloc] initWithImage:customIcon];
            customPinView.leftCalloutAccessoryView = leftAccessoryView;
            [leftAccessoryView release];
            
            pinView = customPinView;
        }
        else
            pinView.annotation = annotation;
        
    }
    
    
    else if ([annotation isKindOfClass:[MQPointAnnotation class]]) 
    {
        // try to dequeue an existing pin view first
        static NSString* identifier = @"pinAnnotations";
        pinView = (MQPinAnnotationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MQPinAnnotationView* customPinView = [[[MQPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            customPinView.pinColor = MQPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
           
            customPinView.leftCalloutAccessoryView = leftButton;
            pinView = customPinView;
        }
        else
            pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)mapView:(MQMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"%d views added to mapview", [views count]);
}

- (void)mapView:(MQMapView *)mapView didSelectAnnotationView:(MQAnnotationView *)view {

    MQReverseGeocoder *coder = [[MQReverseGeocoder alloc] initWithCoordinate:view.annotation.coordinate];
    coder.delegate = self;
    [coder start];
}


- (void)mapView:(MQMapView *)mapView didDeselectAnnotationView:(MQAnnotationView *)view {
    NSLog(@"Annotation View deselected");
}

- (void)mapView:(MQMapView *)mapView annotationView:(MQAnnotationView *)view didChangeDragState:(MQAnnotationViewDragState)newState 
   fromOldState:(MQAnnotationViewDragState)oldState {
        
}

- (void)mapView:(MQMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
}

- (MQOverlayView *)mapView:(MQMapView *)amapView viewForOverlay:(id <MQOverlay>)overlay
{
    if ( [overlay isKindOfClass:[MQPolyline class]] )
    {
        MQPolyline *lineOverlay = (MQPolyline *)overlay;
        MQPolylineView *lineView = [[[MQPolylineView alloc] initWithPolyline:lineOverlay] autorelease];
        MQCoordinateRegion r = MQCoordinateRegionForMapRect(lineOverlay.boundingMapRect);
        CGRect rect = [amapView convertRegion:r toRectToView:amapView];
        lineView.frame = rect;
        lineView.strokeColor = [UIColor orangeColor];
        lineView.lineWidth = 2.0;

        return lineView;
    }
    else  if ( [overlay isKindOfClass:[MQPolygon class]] )
    {
        MQPolygon *polyOverlay = (MQPolygon *)overlay;
        MQPolygonView *polyView = [[[MQPolygonView alloc] initWithPolygon:polyOverlay] autorelease];
        MQCoordinateRegion r = MQCoordinateRegionForMapRect(polyOverlay.boundingMapRect);
        CGRect rect = [amapView convertRegion:r toRectToView:amapView];
        polyView.frame = rect;
        polyView.strokeColor = [UIColor redColor];
        polyView.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.5];
        polyView.lineWidth = 2.0;
        
        return polyView;
    }
    
    else if ([overlay isKindOfClass:[MQCircle class]]) {
        MQCircle *circle = (MQCircle *)overlay;
        MQCircleView *circleView = [[[MQCircleView alloc] initWithCircle:circle] autorelease];
        MQCoordinateRegion r = MQCoordinateRegionForMapRect(circle.boundingMapRect);
        CGRect rect = [amapView convertRegion:r toRectToView:amapView];
        circleView.frame = rect;
        circleView.strokeColor = [UIColor redColor];
        circleView.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.5];
        circleView.lineWidth = 2.0;
        return circleView;
    }
        
    NSLog(@"Failed to create view for overlay!");
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void)reverseGeocoder:(MQReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"Reverse Geocoding FAILED: %@", [error localizedDescription]);
}

- (void)reverseGeocoder:(MQReverseGeocoder *)geocoder didFindPlacemark:(MQPlacemark *)placemark {
    NSLog(@"Reverse Geocode SUCCESS");
    NSLog(@"ADDRESS: %@", [placemark description]);
}


@end
