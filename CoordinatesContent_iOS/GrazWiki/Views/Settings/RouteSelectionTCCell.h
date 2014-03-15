//
//  RouteSelectionTCCell.h
//  GrazWiki
//
//  Created by Christian Gottitsch on 17.04.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteSelectionTCCell : UITableViewCell{

}

@property (nonatomic, retain)IBOutlet UILabel *_lblNumber;
@property (nonatomic, retain)IBOutlet UILabel *_lblRouteName;
@property (nonatomic, retain)IBOutlet UILabel *_lblRouteDescription;
@property (nonatomic, retain)IBOutlet UIImageView *_ivIcon;


@end
