//
//  GOSensorDetailViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 06.12.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
#import "GOGraphView.h"
#import "GOCustomObjectCell.h"

@class GOResourceObject;
@class GODeviceObject;
@class GOGroupObject;


@interface GOSensorDetailViewController : UIViewController<UITextFieldDelegate, GOWebserviceDelegate, GOCustomObjectCellDelegate>

#define kDayGranularity                 3600.0
#define kWeekGranularity                86400.0

#define kHeadCellIdentifier             @"HeadCell"
#define kGraphCellIdentifier            @"GraphCell"
#define kMeasurementCellIdentifier      @"MeasurementCell"

#define kHeadCellHeight                 85.0
#define kGraphCellHeight                280.0
#define kMeasurementCellHeight          40.0

@property (nonatomic) GOResourceObject *sensorObject;

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

- (IBAction)onClickSave:(id)sender;
@end
