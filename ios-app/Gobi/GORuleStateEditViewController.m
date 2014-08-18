//
//  GORuleConditionEditViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GORuleStateEditViewController.h"
#import "GOHeaderTextCell.h"
#import "GOResourceListViewController.h"
#import "GORuleConditionAssociationObject.h"
#import "GOJSONParser.h"

@interface GORuleStateEditViewController ()
@property (nonatomic) BOOL editMode;
@property (nonatomic) GOHeaderTextCell *ruleHeaderCell;
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) GORequestTypes requestType;
@end

@implementation GORuleStateEditViewController

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
    
    if (!self.actionMode) {
        self.ruleHeaderCell = [self.tableView dequeueReusableCellWithIdentifier:kHeadCellIdentifier];
        self.ruleHeaderCell.textField.delegate = self;
    }
    
    self.webservice = [[GOWebservice alloc] init];
    self.webservice.delegate = self;
    
    if (self.ruleState) {
        self.editMode = YES;
        self.ruleConditionAssociations = [NSMutableArray arrayWithArray:self.ruleState.conditions];
    }
    else {
        self.editMode = NO;
        self.ruleState = [[GORuleStateObject alloc] init];
        self.ruleConditionAssociations = [[NSMutableArray alloc] init];
    }
    
    self.title = self.actionMode ? @"Neue Aktion" : @"Neue Bedingung";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOPostRequest) {
            self.ruleState = [GOJSONParser parseRuleStateObjectFromDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
            NSLog(@"RULE STATI id HUSSSO: %i", self.ruleState._id);
            [self performSegueWithIdentifier:kUnwindToRuleStateListFromRuleStateEdit sender:self];
        }
    }
    else {
        //TODO: Connection Fehler
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    [self.mainViewController showErrorViewWithText:[self.webservice getStringForErrorCode:error.code]];
}

#pragma mark - GO Rule Settings Table View Delegate

- (void)didDeleteOnRuleSettingsTableViewCell:(GORuleSettingsTableViewCell *)cell {
    [self.ruleConditionAssociations removeObjectAtIndex:cell.indexPath.row];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)ruleSettingsTableViewCell:(GORuleSettingsTableViewCell *)cell requiresTableViewYMovement:(CGFloat)offset {
    NSLog(@"MOOGIng :%f", offset);
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + offset) animated:YES];
}

#pragma mark - UI Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int firstSectionAmount = self.actionMode ? 1 : 2;
    return section == 0 ? firstSectionAmount : [self.ruleConditionAssociations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && !self.actionMode) {
            return self.ruleHeaderCell;
        }
        else {
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:kAddResourceCellIdentifier];
            cell.textLabel.text = @"Ressource hinzufügen";
            return cell;
        }
    }
    
    GORuleSettingsTableViewCell *cell;
    GORuleConditionAssociationObject *assoc = [self.ruleConditionAssociations objectAtIndex:indexPath.row];
    switch (assoc.resource.resourceType) {
        case GOResourceTypeActuatorSwitch:
        case GOResourceTypeActuatorLightSwitch: {
            cell = [tableView dequeueReusableCellWithIdentifier:kSettingsSwitchCellIdentifier];
            cell.actorSwitch.on = (assoc.resource.value == 1.0);
        }
            break;
            
        case GOResourceTypeActuatorLightDimmer: {
            cell = [tableView dequeueReusableCellWithIdentifier:kSettingsDimCellIdentifier];
            cell.dimSlider.value = assoc.resource.value / 100.0; //TODO: was ist das dimmer maximum? (Annahme 100.0)
            cell.unitLabel.text = [NSString stringWithFormat:@"%0.f %%", assoc.resource.value];
            
        }
            break;
        default: {
            cell = [tableView dequeueReusableCellWithIdentifier:kSettingsValueCellIdentifier];
            UIToolbar *doneToolbar = [[UIToolbar alloc] init];
            [doneToolbar setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
            UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleBordered target:cell.valueTextField action:@selector(resignFirstResponder)];
            doneToolbar.items = @[flexibleSpaceButton, doneButton];
            [doneToolbar sizeToFit];

            cell.segmentedControl.selectedSegmentIndex = assoc.ruleOperator - 3;
            cell.valueTextField.delegate = cell;
            cell.valueTextField.text = [NSString stringWithFormat:@"%0.f", assoc.resource.value];
            cell.valueTextField.inputAccessoryView = doneToolbar;
            cell.unitLabel.text = [NSString stringWithFormat:@"in %@", assoc.resource.unit];

        }
            break;
    }

    
    cell.nameLabel.text = assoc.resource.name;
    cell.subLabel.text = [GOResourceObject getDescriptionStringForResourceType:assoc.resource.resourceType];
    cell.ruleConditionAssociation = assoc;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.parentView = self.view;
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 && !self.actionMode ? kHeaderCellHeight : kDefaultCellHeight;
    }
    else {
        GORuleConditionAssociationObject *assoc = [self.ruleConditionAssociations objectAtIndex:indexPath.row];
        if (assoc.resource.resourceType == GOResourceTypeActuatorSwitch || assoc.resource.resourceType == GOResourceTypeActuatorLightSwitch) {
            return kSettingsSwitchCellHeight;
        }
        return kSettingsValueCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 0 && self.actionMode)) {
        [self performSegueWithIdentifier:kAddResourceToRuleStateSegue sender:self];
    }
}

#pragma mark - Actions

- (IBAction)onClickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickSave:(id)sender {
    [self.view endEditing:YES];
    if (self.actionMode) {
        [self performSegueWithIdentifier:kUnwindToRuleEditFromRuleStateEditSegue sender:self];
    }
    else {
        self.ruleState.name = self.ruleHeaderCell.textField.text;
        self.ruleState.conditions = self.ruleConditionAssociations;
        self.ruleState.ruleOperator = self.ruleHeaderCell.segmentedControl.selectedSegmentIndex;
        self.requestType = GOPostRequest;
        [self.webservice postRuleStateForObject:self.ruleState];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddResourceToRuleStateSegue]) {
        GOResourceListViewController *dest = segue.destinationViewController;
        dest.mainViewController = self.mainViewController;
        dest.actionMode = self.actionMode;
    }
}

- (IBAction)unwindToRuleStateEdit:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:kUnwindToRuleStateEditFromResourceList]) {
        GOResourceListViewController *list = segue.sourceViewController;
        GORuleConditionAssociationObject *condtionAssoc = [[GORuleConditionAssociationObject alloc] init];
        condtionAssoc.resource = list.pickedResource;
        condtionAssoc.ruleOperator = GORuleOperatorEqual;
        [self.ruleConditionAssociations addObject:condtionAssoc];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
