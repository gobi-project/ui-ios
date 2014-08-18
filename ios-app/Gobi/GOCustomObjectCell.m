//
//  GODeviceListCell.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 28.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOCustomObjectCell.h"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation GOCustomObjectCell

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
}

- (IBAction)onClickLeftButton:(id)sender {
    [self sendMessageToDelegateWithSelector:@selector(didPressLeftButtonOnGOCustomObjectCell:)];
}

- (IBAction)onClickSwitchAktor:(id)sender {
    [self sendMessageToDelegateWithSelector:@selector(didSwitchButtonOnGOCustomObjectCell:)];
}

- (IBAction)onClickDetailDisclosureButton:(id)sender {
    [self sendMessageToDelegateWithSelector:@selector(didPressDetailDisclosureButtonOnGOCustomObjectCell:)];
}

- (IBAction)onClickDeleteMembership:(id)sender {
    [self sendMessageToDelegateWithSelector:@selector(didDeleteMembershipOnGOCustomObjectCell:)];
}

- (IBAction)onClickSegmentedControl:(id)sender {
    [self sendMessageToDelegateWithSelector:@selector(didTriggerSegmentedControlOnGOCustomObjectCell:)];
}

- (IBAction)onPanTriggerSlider:(id)sender {
    [self sendMessageToDelegateWithSelector:@selector(didTriggerSliderOnGOCustomObjectCell:)];
}

- (IBAction)onClickAction:(id)sender {
    [self sendMessageToDelegateWithSelector:@selector(didPressActionButtonOnGOCustomObjectCell:)];
}

- (IBAction)onClickStepper:(id)sender {
    self.colorView.backgroundColor = [UIColor colorWithRed:self.stepper.value / 255.0 green:self.stepper2.value / 255.0 blue:self.stepper3.value / 255.0 alpha:1.0];
    self.infoLabel.text = [NSString stringWithFormat:@"R: %i", (int)self.stepper.value];
    
    self.infoLabel2.text = [NSString stringWithFormat:@"G: %i", (int)self.stepper2.value];
    
    self.infoLabel3.text = [NSString stringWithFormat:@"B: %i", (int)self.stepper3.value];
}

#pragma mark - Helper

- (void)sendMessageToDelegateWithSelector:(SEL)selector {
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate performSelector:selector withObject:self];
    }
}


@end
