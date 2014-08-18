//
//  GOGroupListViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 17.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOGroupListViewController.h"
#import "GOCustomObjectCell.h"
#import "GOResourceObject.h"
#import "GOWebservice.h"
#import "GOJSONParser.h"
#import "GOGroupObject.h"
#import "GOSensorDetailViewController.h"
#import "GOGroupEditViewController.h"

@interface GOGroupListViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) GOGroupObject *pickedGroupObject;
@property (nonatomic) GOCustomObjectCell *selectedObjectCell;
@property (nonatomic) int requestType;

@property (nonatomic) CGFloat originalActuatorValue;
@property (nonatomic) GOCustomObjectCell *concernedObjectCell;
@end

@implementation GOGroupListViewController

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onClickRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.dataTableView addSubview:self.refreshControl];
    
    self.webservice = [[GOWebservice alloc] initWithView:self.view];
    self.webservice.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dataTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.objectList objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.objectList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GOCustomObjectCell *cell;
    GOResourceObject *resource = [[self.objectList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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

#pragma mark - UI Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GOCustomObjectCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GOGroupListSectionHeader" owner:self options:nil] firstObject];
    GOGroupObject *group = [self.groupList objectAtIndex:section];
    
    if ([group.resources count] == 0) {
        cell.leftButton.enabled = NO;
    }
    else {
        cell.leftButton.enabled = YES;
    }
    
    if (group.unfolded) {
        [cell.leftButton setTitle:@"Schließen" forState:UIControlStateNormal];
    }
    else {
        [cell.leftButton setTitle:@"Öffnen" forState:UIControlStateNormal];
    }
    
    cell.nameLabel.text = group.name;
    cell.descriptionLabel.text = @"";
    cell.subLabel.text = [NSString stringWithFormat:@"Ressourcen: %i", (int)[group.resources count]];
    
    cell.isDeviceCell = YES;
    cell.delegate = self;
    cell.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    UIView *view = [[UIView alloc] initWithFrame:[cell frame]];
    [view addSubview:cell];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GOResourceObject *resource = [[self.objectList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kGroupCellHeight;
}

#pragma mark - Custom Object Cell Delegate

- (void)didPressActionButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    GOResourceObject *pickedActuator = [[self.objectList objectAtIndex:cell.indexPath.section] objectAtIndex:cell.indexPath.row];
    int red = (int)cell.stepper.value;
    int green = (int)cell.stepper2.value;
    int blue = (int)cell.stepper.value;
    NSString *hexString = [NSString stringWithFormat:@"%02X%02X%02X%02X", 1, red, green, blue];
    pickedActuator.value = strtoll([hexString UTF8String], NULL, 16);
    NSLog(@"Value : %f", pickedActuator.value);
    self.requestType = GOPatchRequest;
    [self.webservice patchResourcesForObject:pickedActuator forDeviceObjectId:pickedActuator.deviceId asSensor:NO];
}

- (void)didPressDetailDisclosureButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    self.selectedObjectCell = cell;
    self.pickedGroupObject = [self.groupList objectAtIndex:cell.indexPath.section];
    [self performSegueWithIdentifier:kEditGroupSegue sender:self];
}

- (void)didPressLeftButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    if (cell.isDeviceCell) {
        GOGroupObject *group = [self.groupList objectAtIndex:cell.indexPath.section];
        if (group.unfolded) {
            [[self.objectList objectAtIndex:cell.indexPath.section] removeAllObjects];
        }
        else {
            if (group.resources) {
                [[self.objectList objectAtIndex:cell.indexPath.section] addObjectsFromArray:group.resources];
            }
        }
        group.unfolded = !group.unfolded;
        [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:cell.indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        self.selectedObjectCell = cell;
        GOResourceObject *resource = [[self.objectList objectAtIndex:self.selectedObjectCell.indexPath.section] objectAtIndex:self.selectedObjectCell.indexPath.row];
        
        if (resource.coreType == GOCoreTypeSensor) {
            [self performSegueWithIdentifier:kSensorDetailSegueFromGroup sender:self];
        }
        else {
            
        }
    }
}

- (void)didSwitchButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    GOResourceObject *pickedActuator = [[self.objectList objectAtIndex:cell.indexPath.section] objectAtIndex:cell.indexPath.row];
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

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    [self.refreshControl endRefreshing];
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOGetAllRequest) {
            self.groupList = [GOJSONParser parseObjectArrayFromJSONData:data forIdentifier:GOParseGroupObjectArray];
            self.objectList = [[NSMutableArray alloc] init];
            
            for (GOGroupObject *group in self.groupList) {
                [self.objectList addObject:[[NSMutableArray alloc] init]];
            }
            
            [self.dataTableView reloadData];
        }
    }
    else {
        
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    [self.refreshControl endRefreshing];
    [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:error.code]];
}

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender {
    [self.mainViewController toggleMainView];
}

- (IBAction)onClickRefresh:(id)sender {
    self.requestType = GOGetAllRequest;
    [self.webservice getAllGroups];
}

- (IBAction)unwindToGroupList:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:kUnwindFromGroupEdit]) {
        GOGroupEditViewController *source = segue.sourceViewController;
        if (source.editMode) {
            self.pickedGroupObject.unfolded = !self.pickedGroupObject.unfolded;
            [[self.objectList objectAtIndex:self.selectedObjectCell.indexPath.section] removeAllObjects];
            [self didPressLeftButtonOnGOCustomObjectCell:self.selectedObjectCell];
            [self onClickRefresh:self];
        }
        else {
            [self onClickRefresh:self];            
        }
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSensorDetailSegueFromGroup]) {
        GOSensorDetailViewController *dest = segue.destinationViewController;
        dest.sensorObject = [[self.objectList objectAtIndex:self.selectedObjectCell.indexPath.section] objectAtIndex:self.selectedObjectCell.indexPath.row];
    }
    else if ([segue.identifier isEqualToString:kEditGroupSegue]) {
        GOGroupEditViewController *dest = segue.destinationViewController;
        dest.mainViewController = self.mainViewController;
        dest.groupObject = self.pickedGroupObject;
    }
    else if ([segue.identifier isEqualToString:kAddGroupSegue]) {
        UINavigationController *nav = segue.destinationViewController;
        GOGroupEditViewController *dest = [nav.viewControllers firstObject];
        dest.mainViewController = self.mainViewController;
    }
}

@end
