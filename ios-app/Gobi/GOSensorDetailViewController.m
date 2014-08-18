//
//  GOSensorDetailViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 06.12.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOSensorDetailViewController.h"
#import "GOResourceObject.h"
#import "GODeviceObject.h"
#import "GODeviceListViewController.h"
#import "GOWebservice.h"
#import "GOGroupObject.h"
#import "GOJSONParser.h"
#import "GOHeaderTextCell.h"
#import "GOMeasurementObject.h"

@interface GOSensorDetailViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) GORequestTypes requestType;

@property (nonatomic) GOHeaderTextCell *headCell;
@property (nonatomic) GOCustomObjectCell *customGraphCell;
@property (nonatomic) GOGraphTimeInterval pickedTimeInterval;
@property (nonatomic) NSCalendar *calendar;
@end

@implementation GOSensorDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webservice = [[GOWebservice alloc] initWithView:self.view];
    self.webservice.delegate = self;
    
    self.headCell = [self.dataTableView dequeueReusableCellWithIdentifier:kHeadCellIdentifier];
    self.headCell.textField.delegate = self;
    self.headCell.textField.text = self.sensorObject.name;
    self.headCell.infoLabel.text = [GOResourceObject getDescriptionStringForResourceType:self.sensorObject.resourceType];
    self.customGraphCell = [self.dataTableView dequeueReusableCellWithIdentifier:kGraphCellIdentifier];
    self.customGraphCell.delegate = self;
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self didTriggerSegmentedControlOnGOCustomObjectCell:self.customGraphCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.customGraphCell.graphView.measurements.count > 0 ? 2 : 1;
        default:
            return self.customGraphCell.graphView.measurements.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.headCell;
        }
        else {
            return self.customGraphCell;
        }
    }
    
    GOCustomObjectCell *cell = [self.dataTableView dequeueReusableCellWithIdentifier:kMeasurementCellIdentifier];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EE dd.MM.yyyy hh:mm";
    
    GOMeasurementObject *measurement = [self.customGraphCell.graphView.measurements objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dateFormatter stringFromDate:measurement.date];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%0.2f %@", measurement.value, self.sensorObject.unit];
    
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? kHeadCellHeight : kGraphCellHeight;
    }
    return kMeasurementCellHeight;
}

#pragma mark - GO Custom Object Cell Delegate

- (void)didTriggerSegmentedControlOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    self.requestType = GOGetAllRequest;
    NSDate *now = [[NSDate alloc] init];
    NSDate *fromDate;
    NSDateComponents *componentsWithOffset = [[NSDateComponents alloc] init];
    
    switch (cell.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.pickedTimeInterval = GOGraphTimeIntervalRecentDay;
            componentsWithOffset.day = -1;
            fromDate = [self.calendar dateByAddingComponents:componentsWithOffset toDate:now options:0];
            [self.webservice getMeasurementsForSensorObject:self.sensorObject fromDate:fromDate toDate:now withGranularity:kDayGranularity];
            break;
            
        default:
            self.pickedTimeInterval = GOGraphTimeIntervalRecentWeek;
            componentsWithOffset.week = -1;
            fromDate = [self.calendar dateByAddingComponents:componentsWithOffset toDate:now options:0];
            [self.webservice getMeasurementsForSensorObject:self.sensorObject fromDate:fromDate toDate:now withGranularity:kWeekGranularity];
            break;
    }
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOPatchRequest) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            self.customGraphCell.graphView.measurements = [GOJSONParser parseObjectArrayFromJSONData:data forIdentifier:GOParseMeasurementObjectArray];
            if ([self.customGraphCell.graphView.measurements count] > 0) {
                [self.customGraphCell.graphView drawForGraphTimeInterval:self.pickedTimeInterval];
            }
            [self.dataTableView reloadData];
        }
    }
    else {
        //TODO: Connection Fehler
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    GODeviceListViewController *parent = [self.navigationController.viewControllers firstObject];
    [parent.mainViewController showErrorViewWithText:[self.webservice getStringForErrorCode:error.code]];
}

#pragma mark - Actions

- (IBAction)onClickSave:(id)sender {
    self.sensorObject.name = self.headCell.textField.text;
    self.requestType = GOPatchRequest;
    [self.webservice patchResourcesForObject:self.sensorObject forDeviceObjectId:self.sensorObject.deviceId asSensor:YES];
}

@end
