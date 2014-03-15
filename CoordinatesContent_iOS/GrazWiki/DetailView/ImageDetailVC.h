//
//  ImageDetailVC.h
//  GrazWiki
//
//  Created by Christian Gottitsch on 10.06.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailVC : UIViewController

@property (nonatomic, retain)IBOutlet UIImageView *_ivImage;
@property (nonatomic, retain)IBOutlet UIButton *_btnClose;
@property (nonatomic, retain)IBOutlet UILabel *_lblDescription;
@property (nonatomic, retain)IBOutlet UILabel *_lblAddress;

@property (nonatomic, retain)NSString *adress;
@property (nonatomic, retain)UIImage *buildingImage;


-(void)redrawView;

@end
