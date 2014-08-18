//
//  GORuleConditionListViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
#import "GOMainViewController.h"
#import "GOCustomObjectCell.h"

#define kUnwindToRuleEditFromStateList  @"unwindToRuleEditFromStateList"
#define kAddRuleStateSegue              @"addRuleStateSegue"

#define kCustomCellIdentifier           @"CustomObjectCell"
#define kCustomCellHeight               60.0

@interface GORuleStateListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, GOWebserviceDelegate, GOCustomObjectCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) GORuleStateObject *pickedState;
@property (nonatomic) GOMainViewController *mainViewController;

- (IBAction)unwindToRuleStateList:(UIStoryboardSegue *)segue;
@end
