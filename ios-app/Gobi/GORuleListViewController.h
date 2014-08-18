//
//  GORuleListViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOMainViewController.h"
#import "GOAppDelegate.h"
#import "GOWebservice.h"
#import "GOCustomObjectCell.h"

#define kRuleListCellIdentifier         @"RuleListCell"

#define kAddRuleSegue                   @"addRuleSegue"
#define kEditRuleSegue                  @"EditRuleSegue"

@interface GORuleListViewController : UIViewController<MainCointainerProtocol, UITableViewDataSource, UITableViewDelegate, GOWebserviceDelegate, GOCustomObjectCellDelegate, UIAlertViewDelegate>

@property (nonatomic) GOMainViewController *mainViewController;

#pragma mark - Outlest

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender;
- (IBAction)onClickRefresh:(id)sender;
- (IBAction)unwindToRuleList:(UIStoryboardSegue *)segue;

@end
