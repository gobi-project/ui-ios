//
//  GORuleSettingsTableViewCell.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 13.03.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GORuleConditionAssociationObject.h"

@class GORuleSettingsTableViewCell;

@protocol GORuleSettingsTableViewCellDelegate <NSObject>
- (void)didDeleteOnRuleSettingsTableViewCell:(GORuleSettingsTableViewCell *)cell;
- (void)ruleSettingsTableViewCell:(GORuleSettingsTableViewCell *)cell requiresTableViewYMovement:(CGFloat)offset;
@end

@interface GORuleSettingsTableViewCell : UITableViewCell<UITextFieldDelegate>

#define kKeyboardHeightWithOffset          314.0

@property (nonatomic) GORuleConditionAssociationObject *ruleConditionAssociation;
@property (weak, nonatomic) id <GORuleSettingsTableViewCellDelegate> delegate;
@property (nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *dimSlider;
@property (weak, nonatomic) IBOutlet UISwitch *actorSwitch;
@property (nonatomic) UIView *parentView;

- (IBAction)onClickDelete:(id)sender;
- (IBAction)onClickSwitch:(UISwitch *)sender;
- (IBAction)onClickSegmentedControl:(UISegmentedControl *)sender;
- (IBAction)onSlideChangeValue:(id)sender;
@end
