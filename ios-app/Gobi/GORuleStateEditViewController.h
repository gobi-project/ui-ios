//
//  GORuleConditionEditViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
#import "GORuleStateObject.h"
#import "GORuleSettingsTableViewCell.h"
#import "GOMainViewController.h"



@interface GORuleStateEditViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GOWebserviceDelegate, GORuleSettingsTableViewCellDelegate>

#define kHeadCellIdentifier             @"HeadCell"
#define kAddResourceCellIdentifier      @"AddResourceCell"
#define kRuleSettingsCellIdentifier     @"RuleSettingsCell"

#define kAddResourceToRuleStateSegue    @"addResourceToRuleStateSegue"
#define kUnwindToRuleEditFromRuleStateEditSegue     @"unwindToRuleEditFromRuleStateEdit"
#define kUnwindToRuleStateListFromRuleStateEdit     @"unwindToRuleStateListFromRuleStateEdit"

#define kSettingsSwitchCellIdentifier   @"SettingsSwitchCell"
#define kSettingsValueCellIdentifier    @"SettingsValueCell"
#define kSettingsDimCellIdentifier      @"SettingsDimCell"

#define kDefaultCellHeight              44.0
#define kSettingsValueCellHeight        130.0
#define kSettingsSwitchCellHeight       100.0
#define kHeaderCellHeight               105.0


@property (nonatomic) GORuleStateObject *ruleState;
@property (nonatomic) GOMainViewController *mainViewController;
@property (nonatomic) NSMutableArray *ruleConditionAssociations;

@property (nonatomic) BOOL actionMode;

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Actions

- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickSave:(id)sender;
- (IBAction)unwindToRuleStateEdit:(UIStoryboardSegue *)segue;
@end
