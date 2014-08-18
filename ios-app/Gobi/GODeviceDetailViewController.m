//
//  GODeviceDetailViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 06.12.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GODeviceDetailViewController.h"
#import "GODeviceObject.h"
#import "GOResourceObject.h"
#import "GOSensorDetailViewController.h"
#import "GODeviceListViewController.h"

@interface GODeviceDetailViewController ()
@property (nonatomic) GORequestTypes requestType;
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) NSIndexPath *pickedResourceIndexPath;

@property (nonatomic) CGFloat originalActuatorValue;
@property (nonatomic) GOCustomObjectCell *concernedObjectCell;
@end

@implementation GODeviceDetailViewController

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
    
    self.nameTextField.text = self.deviceObject.name;
    self.descriptionTextView.text = self.deviceObject.description;
    
    self.objectList = [[NSMutableArray alloc] init];
    [self.objectList addObjectsFromArray:self.deviceObject.resources];
    [self.resourceTableView reloadData];
    
    self.resourceAmount.text = [NSString stringWithFormat:@"Ressourcen: %i", (int)[self.objectList count]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.resourceTableView reloadData];
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

#pragma mark - UI Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GOResourceObject *resource = [self.objectList objectAtIndex:indexPath.row];
    if (resource.coreType == GOCoreTypeActuator) {
        if (resource.resourceType == GOResourceTypeActuatorLightDimmer) {
            return kDimmerCellHeight;
        }
        else if (resource.resourceType == GOResourceTypeActuatorLightRGB) {
            return kRGBCellHeight;
        }
    }
    return kListCellHeight;
}

#pragma mark - UI Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objectList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GOCustomObjectCell *cell;
    
    GOResourceObject *resource = [self.objectList objectAtIndex:indexPath.row];
    if (resource.coreType == GOCoreTypeSensor) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSensorListCellIdentifier];
        cell.valueLabel.text = [NSString stringWithFormat:@"%.1f %@", resource.value, resource.unit];
    }
    else {
        if (resource.resourceType == GOResourceTypeActuatorLightDimmer) {
            cell = [tableView dequeueReusableCellWithIdentifier:kActorListDimCellIdentifier];
            cell.slider.value = resource.value;
        }
        else if (resource.resourceType == GOResourceTypeActuatorLightRGB) {
            cell = [tableView dequeueReusableCellWithIdentifier:kActorListRGBCellIdentifier];
            int rgbValue = (int)resource.value;
            UIColor *currentColor = UIColorFromRGB(rgbValue);
            cell.colorView.backgroundColor = currentColor;
            cell.stepper.value = (float)((rgbValue & 0xFF0000) >> 16);
            cell.infoLabel.text = [NSString stringWithFormat:@"R: %i", ((rgbValue & 0xFF0000) >> 16)];
            
            cell.stepper2.value = ((float)((rgbValue & 0xFF00) >> 8));
            cell.infoLabel2.text = [NSString stringWithFormat:@"G: %i", ((rgbValue & 0xFF00) >> 8)];
            
            cell.stepper3.value = ((float)(rgbValue & 0xFF));
            cell.infoLabel3.text = [NSString stringWithFormat:@"B: %i", (rgbValue & 0xFF)];
            
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:kActorListCellIdentifier];
            cell.actorSwitch.on = !(resource.value == 0);
        }
    }
    cell.nameLabel.text = resource.name;
    cell.descriptionLabel.text = [GOResourceObject getDescriptionStringForResourceType:resource.resourceType];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - Custom ObjectCellDelegate Cell Delegate

- (void)didPressLeftButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    self.pickedResourceIndexPath = cell.indexPath;
    GOResourceObject *resource = [self.objectList objectAtIndex:self.pickedResourceIndexPath.row];

    if (resource.coreType == GOCoreTypeSensor) {
        [self performSegueWithIdentifier:kSensorDetailSegueFromDeviceDetail sender:self];
    }
    else {
        
    }
}

- (void)didPressActionButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    GOResourceObject *pickedActuator = [self.objectList objectAtIndex:cell.indexPath.row];
    int red = (int)cell.stepper.value;
    int green = (int)cell.stepper2.value;
    int blue = (int)cell.stepper.value;
    NSString *hexString = [NSString stringWithFormat:@"%02X%02X%02X%02X", 1, red, green, blue];
    pickedActuator.value = strtoll([hexString UTF8String], NULL, 16);
    NSLog(@"Value : %f", pickedActuator.value);
    self.requestType = GOPatchRequest;
    [self.webservice patchResourcesForObject:pickedActuator forDeviceObjectId:pickedActuator.deviceId asSensor:NO];
}

- (void)didSwitchButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    GOResourceObject *pickedActuator = [self.objectList objectAtIndex:cell.indexPath.row];
    
    self.concernedObjectCell = cell;
    self.originalActuatorValue = pickedActuator.value;
    pickedActuator.value = cell.actorSwitch.isOn ? 1.0 : 0.0;
    self.requestType = GOPatchRequest;
    [self.webservice patchResourcesForObject:pickedActuator forDeviceObjectId:pickedActuator.deviceId asSensor:NO];
}

- (void)didTriggerSliderOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    GOResourceObject *pickedActuator = [self.objectList objectAtIndex:cell.indexPath.row];
    
    self.concernedObjectCell = cell;
    self.originalActuatorValue = pickedActuator.value;
    pickedActuator.value = cell.slider.value;
    self.requestType = GOPatchRequest;
    [self.webservice patchResourcesForObject:pickedActuator forDeviceObjectId:pickedActuator.deviceId asSensor:NO];
}

#pragma mark - UI Alert Field Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Gerät wird nicht gelöscht");
    }
    else if (buttonIndex == 1) {
        NSLog(@"Gerät wird gelöscht");
        self.requestType = GODeleteRequest;
        [self.webservice deleteDeviceWithID:self.deviceObject._id];
        [self.objectList removeAllObjects];
    }
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOAlternativeRequest) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (statuscode == 401) {
        //TODO: Login unültig
    }
    else {
        //TODO: Connection Fehler
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    //TODO: Fehlermeldung
}

#pragma mark - Actions

- (IBAction)onClickSave:(id)sender {
    self.deviceObject.name = self.nameTextField.text;
    self.requestType = GOAlternativeRequest;
    [self.webservice patchDeviceForObject:self.deviceObject];
}

- (IBAction)onClickDelete:(id)sender {
    [self showMessage:(self)];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSensorDetailSegueFromDeviceDetail]) {
        GOSensorDetailViewController *dest = segue.destinationViewController;
        dest.sensorObject = [self.objectList objectAtIndex:self.pickedResourceIndexPath.row];
    }
}

#pragma mark - Helper

- (IBAction)showMessage:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gerät löschen"
                                                    message:@"Soll dieses Gerät wirklich gelöscht werden?"
                                                   delegate:self
                                          cancelButtonTitle:@"Nein"
                                          otherButtonTitles:@"Ja",nil];
    [alert show];
}

@end
