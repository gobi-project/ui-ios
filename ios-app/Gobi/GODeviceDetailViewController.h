//
//  GODeviceDetailViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 06.12.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOCustomObjectCell.h"
#import "GOWebservice.h"

@class GODeviceObject;

#define kActorListCellIdentifier            @"ActorListCell"
#define kSensorListCellIdentifier           @"SensorListCell"
#define kActorListDimCellIdentifier         @"ActorListDimCell"

#define kSensorDetailSegueFromDeviceDetail  @"sensorDetailSegueFromDeviceDetail"

@interface GODeviceDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GOWebserviceDelegate ,GOCustomObjectCellDelegate>

#pragma mark - Properties

@property (nonatomic) GODeviceObject *deviceObject;
@property (nonatomic) NSMutableArray *objectList;

#pragma mark - Outlets & Actions

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *resourceTableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *resourceAmount;

- (IBAction)onClickSave:(id)sender;
- (IBAction)onClickDelete:(id)sender;

@end
