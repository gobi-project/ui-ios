//
//  GOGroupHeaderCell.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 30.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GOHeaderTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@end
