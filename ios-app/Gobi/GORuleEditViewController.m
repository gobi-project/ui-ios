//
//  GORuleEditViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GORuleEditViewController.h"
#import "GORuleStateObject.h"
#import "GORuleConditionAssociationObject.h"
#import "GORuleStateListViewController.h"
#import "GORuleStateEditViewController.h"

@interface GORuleEditViewController ()

@property (nonatomic) GOHeaderTextCell *ruleHeaderCell;
@property (nonatomic) NSMutableArray *selectedRuleStates;
@property (nonatomic) NSMutableArray *selectedActions;
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) GORequestTypes requestType;
@end

@implementation GORuleEditViewController

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
    self.ruleHeaderCell = [self.tableView dequeueReusableCellWithIdentifier:kHeadCellIdentifier];
    self.ruleHeaderCell.textField.delegate = self;
    
    self.webservice = [[GOWebservice alloc] initWithView:self.view];
    self.webservice.delegate = self;
    
    if (self.rule) {
        self.editMode = YES;
        self.selectedRuleStates = [NSMutableArray arrayWithArray:self.rule.conditions];
        self.selectedActions = [NSMutableArray arrayWithArray:self.rule.actions];
        self.ruleHeaderCell.textField.text = self.rule.name;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else {
        self.editMode = NO;
        self.rule = [[GORuleObject alloc] init];
        self.selectedRuleStates = [[NSMutableArray alloc] init];
        self.selectedActions = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return [self.selectedRuleStates count];
        case 2:
            return 1;
        default:
            return [self.selectedActions count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.ruleHeaderCell.textField.text = self.rule.name;
            return self.ruleHeaderCell;
        }
        else {
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:kAddResourceCellIdentifier];
            cell.textLabel.text = @"Bedingung hinzufügen";
            return cell;
        }
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:kAddResourceCellIdentifier];
        cell.textLabel.text = @"Aktion hinzufügen";
        return cell;
    }
    NSLog(@"new");

    //Section 1 or 3:
    ;
    GOCustomObjectCell *cell;
    
    if (indexPath.section == 1) {
        NSLog(@"states");
        cell = [tableView dequeueReusableCellWithIdentifier:kConditionCellIdentifier];
        GORuleStateObject *state = [self.selectedRuleStates objectAtIndex:indexPath.row];
        cell.nameLabel.text = state.name;
        NSMutableString *involvedAssociations = [[NSMutableString alloc] init];
        NSString *appendedString;
        for (int i = 0; i < 4 && i < state.conditions.count; i++) {
            NSLog(@"bouz");
            id assocObject = [state.conditions objectAtIndex:i];
            if ([assocObject isKindOfClass:[GORuleStateObject class]]) {
                GORuleStateObject *state = assocObject;
                appendedString = state.name;
                NSLog(@"bouz2");
                
            }
            else {
                NSLog(@"bouz3");
                
                GORuleConditionAssociationObject *condition = assocObject;
                if (condition.resource.name) {
                    appendedString = [NSString stringWithFormat:@"%@ %@ %.0f", condition.resource.name, [GORuleConditionAssociationObject getStringForRuleOperator:condition.ruleOperator longVersion:NO], condition.resource.value];
                }
            }
            [involvedAssociations appendString:appendedString];
            if (i < state.conditions.count - 1) {
                [involvedAssociations appendString:@", "];
            }
        }
        cell.descriptionLabel.text = involvedAssociations;
    }
    else {
        NSLog(@"actions");
        cell = [tableView dequeueReusableCellWithIdentifier:kActionCellIdentifier];
        GORuleConditionAssociationObject *assoc = [self.selectedActions objectAtIndex:indexPath.row];
        if (assoc.resource.name) {
            cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@ %.0f", assoc.resource.name, [GORuleConditionAssociationObject getStringForRuleOperator:assoc.ruleOperator longVersion:NO], assoc.resource.value];
        }
    }
    
    
    

    NSLog(@"readdddy");
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? kHeaderCellHeight : kDefaultCellHeight;
    }
    else if (indexPath.section == 1) {
        return kConditionCellHeight;
    }
    else {
        return kDefaultCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:kChooseConditionSegue sender:self];
    }
    else if (indexPath.section == 2) {
        [self performSegueWithIdentifier:kAddActionSegue sender:self];
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - GO Custom Object Cell Delegate

- (void)didDeleteMembershipOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    if (cell.indexPath.section == 1) {
        [self.selectedRuleStates removeObjectAtIndex:cell.indexPath.row];
    }
    else {
        [self.selectedActions removeObjectAtIndex:cell.indexPath.row];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:cell.indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        [self performSegueWithIdentifier:kUnwindToRuleListFromRuleEditSegue sender:self];
    }
    else {
        [self.mainViewController showErrorViewWithText:[self.webservice getStringForErrorCode:statuscode]];
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    [self.mainViewController showErrorViewWithText:[self.webservice getStringForErrorCode:error.code]];
}

#pragma mark - Actions

- (IBAction)onClickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickSave:(id)sender {
    self.rule.name = self.ruleHeaderCell.textField.text;
    self.rule.conditions = self.selectedRuleStates;
    self.rule.actions = self.selectedActions;
    self.rule.ruleOperator = self.ruleHeaderCell.segmentedControl.selectedSegmentIndex;
    
    if (self.editMode) {
        self.requestType = GOPatchRequest;
        [self.webservice patchRuleForObject:self.rule];
    }
    else {
        self.requestType = GOPostRequest;
        [self.webservice postRuleForObject:self.rule];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kChooseConditionSegue]) {
        GORuleStateListViewController *dest = segue.destinationViewController;
        dest.mainViewController = self.mainViewController;
    }
    else if ([segue.identifier isEqualToString:kAddActionSegue]) {
        UINavigationController *dest = segue.destinationViewController;
        GORuleStateEditViewController *editVC = [dest.viewControllers firstObject];
        editVC.mainViewController = self.mainViewController;
        editVC.actionMode = YES;
    }
}

- (IBAction)unwindToRuleEdit:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:kUnwindToRuleEditFromStateList]) {
        GORuleStateListViewController *source = segue.sourceViewController;
        [self.selectedRuleStates addObject:source.pickedState];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([segue.identifier isEqualToString:kUnwindToRuleEditFromRuleStateEditSegue]) {
        GORuleStateEditViewController *source = segue.sourceViewController;
        [self.selectedActions addObjectsFromArray:source.ruleConditionAssociations];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
