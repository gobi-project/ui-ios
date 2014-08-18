//
//  GORuleConditionListViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GORuleStateListViewController.h"
#import "GOJSONParser.h"
#import "GORuleStateObject.h"
#import "GORuleConditionAssociationObject.h"
#import "GOCustomObjectCell.h"
#import "GORuleStateEditViewController.h"

@interface GORuleStateListViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) GORequestTypes requestType;
@property (nonatomic) NSMutableArray *ruleStates;
@end

@implementation GORuleStateListViewController

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
    self.webservice = [[GOWebservice alloc] init];
    self.webservice.delegate = self;
    
    self.requestType = GOGetAllRequest;
    [self.webservice getAllRuleStates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOGetAllRequest) {
            self.ruleStates = [GOJSONParser parseObjectArrayFromJSONData:data forIdentifier:GOParseRuleStateObjectArray];
            [self.tableView reloadData];
        }
        else if (self.requestType == GODeleteRequest) {
            [self.ruleStates removeObject:self.pickedState];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark - UI Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ruleStates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GOCustomObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellIdentifier];
    
    GORuleStateObject *state = [self.ruleStates objectAtIndex:indexPath.row];
    NSMutableString *involvedAssociations = [[NSMutableString alloc] init];
    NSString *appendedString;
    for (int i = 0; i < 4 && i < state.conditions.count; i++) {
        id assocObject = [state.conditions objectAtIndex:i];
        if ([assocObject isKindOfClass:[GORuleStateObject class]]) {
            GORuleStateObject *state = assocObject;
            appendedString = state.name;
        }
        else {
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
    cell.nameLabel.text = state.name;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UI Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCustomCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.pickedState = [self.ruleStates objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kUnwindToRuleEditFromStateList sender:self];
}

#pragma mark - GO Custom Object Cell Delegate

- (void)didDeleteMembershipOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    self.pickedState = [self.ruleStates objectAtIndex:cell.indexPath.row];
    self.requestType = GODeleteRequest;
    [self.webservice deleteRuleStateWithID:self.pickedState._id];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddRuleStateSegue]) {
        UINavigationController *dest = segue.destinationViewController;
        GORuleStateEditViewController *editVC = [dest.viewControllers firstObject];
        editVC.mainViewController = self.mainViewController;
        editVC.actionMode = NO;
    }
}

- (IBAction)unwindToRuleStateList:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:kUnwindToRuleStateListFromRuleStateEdit]) {
        GORuleStateEditViewController *source = segue.sourceViewController;
        self.pickedState = source.ruleState;
        [self performSelector:@selector(unwindManuallyToRuleEdit) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - Helper

- (void)unwindManuallyToRuleEdit {
    [self performSegueWithIdentifier:kUnwindToRuleEditFromStateList sender:self];
}
@end
