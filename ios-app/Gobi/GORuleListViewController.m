//
//  GORuleListViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GORuleListViewController.h"
#import "GORuleObject.h"
#import "GOJSONParser.h"
#import "GORuleStateObject.h"
#import "GORuleEditViewController.h"
#import "GORuleConditionAssociationObject.h"

@interface GORuleListViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) GORequestTypes requestType;
@property (nonatomic) NSMutableArray *rules;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) GORuleObject *ruleForDeletion;

@end

@implementation GORuleListViewController

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onClickRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GOCustomObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:kRuleListCellIdentifier];
    GORuleObject *rule = [self.rules objectAtIndex:indexPath.row];
    cell.nameLabel.text = rule.name;
    
    NSMutableString *involvedConditions = [[NSMutableString alloc] init];
    NSString *appendedString;
    for (int i = 0; i < 4 && i < [rule.conditions count]; i++) {
        id assocObject = [rule.conditions objectAtIndex:i];
        if ([assocObject isKindOfClass:[GORuleStateObject class]]) {
            GORuleStateObject *state = assocObject;
            appendedString = state.name;
        }
        else {
            GORuleConditionAssociationObject *condition = assocObject;
            if (condition.resource.name) {
                appendedString = condition.resource.name;
            }
        }
        [involvedConditions appendString:appendedString];
        if (i < rule.conditions.count - 1) {
            [involvedConditions appendString:@", "];
        }
    }
    cell.descriptionLabel.text = involvedConditions;
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - UI Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kEditRuleSegue sender:[self.rules objectAtIndex:indexPath.row]];
}

#pragma mark - GO Custom Object Cell Delegate

- (void)didDeleteMembershipOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Regel löschen" message:@"Soll diese Regel wirklich gelöscht werden?" delegate:self cancelButtonTitle:@"NEIN" otherButtonTitles:@"Ja", nil];
    [alert show];
    self.ruleForDeletion = [self.rules objectAtIndex:cell.indexPath.row];

}

#pragma mark - UI Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        self.requestType = GODeleteRequest;
        [self.webservice deleteRuleWithID:self.ruleForDeletion._id];
    }
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    [self.refreshControl endRefreshing];
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOGetAllRequest) {
            self.rules = [GOJSONParser parseObjectArrayFromJSONData:data forIdentifier:GOParseRuleObjectArray];
            [self.tableView reloadData];
        }
        else if (self.requestType == GODeleteRequest) {
            [self.rules removeObject:self.ruleForDeletion];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else {
        [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:statuscode]];
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    [self.refreshControl endRefreshing];
    [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:error.code]];
}

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender {
    [self.mainViewController toggleMainView];
}

- (IBAction)onClickRefresh:(id)sender {
    self.requestType = GOGetAllRequest;
    [self.webservice getAllRules];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddRuleSegue]) {
        UINavigationController *nav = segue.destinationViewController;
        GORuleEditViewController *ruleEdit = [nav.viewControllers firstObject];
        ruleEdit.mainViewController = self.mainViewController;
    }
    else if ([segue.identifier isEqualToString:kEditRuleSegue]) {
        GORuleEditViewController *ruleEdit = segue.destinationViewController;
        ruleEdit.rule = (GORuleObject *)sender;
        ruleEdit.mainViewController = self.mainViewController;
    }
}

- (IBAction)unwindToRuleList:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:kUnwindToRuleListFromRuleEditSegue]) {
        GORuleEditViewController *source = segue.sourceViewController;
        if (!source.editMode) {
            [self onClickRefresh:nil];
        }
        else {
            [self.tableView reloadData];
        }
    }
}

@end
