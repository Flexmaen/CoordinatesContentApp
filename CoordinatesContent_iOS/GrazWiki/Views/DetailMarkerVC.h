//
//  DetailMarkerVC.h
//  GrazWiki
//
//  Created by Christian Gottitsch on 29.03.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMarkerVC : UIViewController{

    UILabel *lblStreetName;
}

-(void)textForStreetLabel:(NSString*)streetName;

@property(nonatomic, retain)IBOutlet UILabel *lblStreetName;
@property(nonatomic, retain)NSString *strStreetName;

@end
