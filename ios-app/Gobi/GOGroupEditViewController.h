//
//  GOGroupEditViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 30.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOGroupObject.h"
#import "GOWebservice.h"
#import "GOMainViewController.h"
#import "GOCustomObjectCell.h"

#define kHeadCellIdentifier             @"HeadCell"
#define kAddResourceCellIdentifier      @"AddResourceCell"
#define kCustomObjectCellIdentifier     @"CustomObjectCell"
#define kDeleteGroupCellIdentifier      @"DeleteGroupCell"

#define kAddResourecSegue               @"addResourceToGroupSegue"
#define kUnwindFromGroupEdit            @"unwindToGroupListFromGroupEdit"

#define kSensorDetailSegueFromGroupEdit @"sensorDetailSegueFromGroupEdit"

#define kDefaultCellHeight              44.0
#define kCustomObjetCellHeight          60.0
#define kHeaderCellHeight               90.0

@interface GOGroupEditViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, GOWebserviceDelegate, GOCustomObjectCellDelegate, UITextFieldDelegate>

@property (nonatomic) GOGroupObject *groupObject;
@property (nonatomic) GOMainViewController *mainViewController;
@property (nonatomic) BOOL editMode;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickSave:(id)sender;
- (IBAction)onClickDelete:(id)sender;


@end
