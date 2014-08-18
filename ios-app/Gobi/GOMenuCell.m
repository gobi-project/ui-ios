//
//  GOMenuCell.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 14.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOMenuCell.h"

@implementation GOMenuCell

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
