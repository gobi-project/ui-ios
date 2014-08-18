//
//  GODeviceListCell.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 28.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOGraphView.h"

@class GOCustomObjectCell;

@protocol GOCustomObjectCellDelegate <NSObject>
@optional
- (void)didSwitchButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell;
- (void)didPressLeftButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell;
- (void)didPressDetailDisclosureButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell;
- (void)didDeleteMembershipOnGOCustomObjectCell:(GOCustomObjectCell *)cell;
- (void)didTriggerSegmentedControlOnGOCustomObjectCell:(GOCustomObjectCell *)cell;
- (void)didTriggerSliderOnGOCustomObjectCell:(GOCustomObjectCell *)cell;
- (void)didPressActionButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell;

@end

@interface GOCustomObjectCell : UITableViewCell

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@property (weak, nonatomic) id <GOCustomObjectCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic) BOOL isDeviceCell;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *actorSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet GOGraphView *graphView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIStepper *stepper2;
@property (weak, nonatomic) IBOutlet UIStepper *stepper3;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel3;

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)onClickLeftButton:(id)sender;
- (IBAction)onClickSwitchAktor:(id)sender;
- (IBAction)onClickDetailDisclosureButton:(id)sender;
- (IBAction)onClickDeleteMembership:(id)sender;
- (IBAction)onClickSegmentedControl:(id)sender;
- (IBAction)onPanTriggerSlider:(id)sender;
- (IBAction)onClickAction:(id)sender;
- (IBAction)onClickStepper:(id)sender;


@end
