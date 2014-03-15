//
//  MenuTCCell.m
//  GrazWiki
//
//  Created by Christian Gottitsch on 17.01.13.
//  Copyright (c) 2013 Christian Gottitsch. All rights reserved.
//

#import "MenuTCCell.h"

@implementation MenuTCCell

@synthesize lblText, ivIcon, lblDetailText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
