//
//  GORuleEditViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOHeaderTextCell.h"
#import "GOCustomObjectCell.h"
#import "GORuleObject.h"
#import "GOWebservice.h"
#import "GOMainViewController.h"

#define kHeadCellIdentifier             @"HeadCell"
#define kAddResourceCellIdentifier      @"AddResourceCell"
#define kConditionCellIdentifier        @"ConditionCell"
#define kActionCellIdentifier           @"ActionCell"

#define kAddActionSegue                 @"addActionSegue"
#define kChooseConditionSegue           @"chooseConditionSegue"

#define kUnwindToRuleListFromRuleEditSegue      @"UnwindToRuleListFromRuleEditSegue"

#define kDefaultCellHeight              44.0
#define kConditionCellHeight            60.0
#define kHeaderCellHeight               105.0

@interface GORuleEditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, GOCustomObjectCellDelegate, UITextFieldDelegate, GOWebserviceDelegate>

@property (nonatomic) GORuleObject *rule;
@property (nonatomic) GOMainViewController *mainViewController;
@property (nonatomic) BOOL editMode;


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Actions

- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickSave:(id)sender;

- (IBAction)unwindToRuleEdit:(UIStoryboardSegue *)segue;

@end
