//
//  GODeviceListViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 05.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOMainViewController.h"
#import "GOAppDelegate.h"
#import "GOWebservice.h"
#import "GOCustomObjectCell.h"

#define kDeviceDetailSegue                  @"deviceDetailSegue"
#define kSensorDetailSegue                  @"sensorDetailSegue"

#define kDeviceListCellIdentifier           @"DeviceListCell"
#define kActorListRGBCellIdentifier         @"ActorListRGBCell"

#define kDeviceListCellHeight               90.0
#define kListCellHeight                     60.0
#define kRGBCellHeight                      210.0
#define kDimmerCellHeight                   90.0

@interface GODeviceListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MainCointainerProtocol, GOWebserviceDelegate, GOCustomObjectCellDelegate>



#pragma mark - Properties

@property (nonatomic) GOMainViewController *mainViewController;
@property (nonatomic) NSMutableArray *objectList;
@property (nonatomic) NSMutableArray *deviceList;

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender;
- (IBAction)onClickRefresh:(id)sender;

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
