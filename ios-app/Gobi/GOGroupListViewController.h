//
//  GOGroupListViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 17.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOMainViewController.h"
#import "GOAppDelegate.h"
#import "GOWebservice.h"
#import "GOCustomObjectCell.h"

@interface GOGroupListViewController : UIViewController<MainCointainerProtocol, UITableViewDataSource, UITabBarDelegate, GOWebserviceDelegate, GOCustomObjectCellDelegate>


#define kActorListCellIdentifier            @"ActorListCell"
#define kSensorListCellIdentifier           @"SensorListCell"
#define kActorListDimCellIdentifier         @"ActorListDimCell"
#define kActorListRGBCellIdentifier         @"ActorListRGBCell"


#define kSensorDetailSegueFromGroup         @"sensorDetailSegueFromGroup"

#define kAddGroupSegue                      @"addGroupSegue"
#define kEditGroupSegue                     @"editGroupSegue"

#define kGroupCellHeight                    40.0
#define kListCellHeight                     60.0
#define kRGBCellHeight                      210.0
#define kDimmerCellHeight                   90.0

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender;
- (IBAction)onClickRefresh:(id)sender;
- (IBAction)unwindToGroupList:(UIStoryboardSegue *)segue;

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

#pragma mark - Other Properties

@property (nonatomic) GOMainViewController *mainViewController;
@property (nonatomic) NSMutableArray *objectList;
@property (nonatomic) NSMutableArray *groupList;

@end
