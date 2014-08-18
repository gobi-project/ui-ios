//
//  GORuleSettingsTableViewCell.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 13.03.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GORuleSettingsTableViewCell.h"

@implementation GORuleSettingsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Text Field Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.ruleConditionAssociation.resource.value = [textField.text floatValue];
    NSLog(@"SETTING float: %f", self.ruleConditionAssociation.resource.value);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint translationPoint = [self.parentView convertPoint:self.valueTextField.center fromView:self];
    NSLog(@"translation point y: %f", translationPoint.y);
    CGFloat topKeyboardY = self.parentView.frame.size.height - kKeyboardHeightWithOffset;
    if (translationPoint.y > topKeyboardY) {
        if ([self.delegate respondsToSelector:@selector(ruleSettingsTableViewCell:requiresTableViewYMovement:)]) {
            [self.delegate ruleSettingsTableViewCell:self requiresTableViewYMovement:translationPoint.y - topKeyboardY];
        }
    }
}


#pragma mark - Actions

- (IBAction)onClickDelete:(id)sender {
    [self.delegate didDeleteOnRuleSettingsTableViewCell:self];
}

- (IBAction)onClickSwitch:(UISwitch *)sender {
    self.ruleConditionAssociation.resource.value = sender.on;
    NSLog(@"SWitch value :%f", self.ruleConditionAssociation.resource.value);
}

- (IBAction)onClickSegmentedControl:(UISegmentedControl *)sender {
    NSLog(@"selected index: %i", sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.ruleConditionAssociation.ruleOperator = GORuleOperatorEqual;
            break;
        case 1:
            self.ruleConditionAssociation.ruleOperator = GORuleOperatorUnequal;
            break;
        case 2:
            self.ruleConditionAssociation.ruleOperator = GORuleOperatorGreater;
            break;
        default:
            self.ruleConditionAssociation.ruleOperator = GORuleOperatorLess;
            break;
    }
}

- (IBAction)onSlideChangeValue:(UISlider *)sender {
    self.ruleConditionAssociation.resource.value = sender.value;
    self.valueTextField.text = [NSString stringWithFormat:@"%0.f", self.ruleConditionAssociation.resource.value];
}
@end
