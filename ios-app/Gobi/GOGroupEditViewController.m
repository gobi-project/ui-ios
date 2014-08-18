//
//  GOGroupEditViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 30.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOGroupEditViewController.h"
#import "GOHeaderTextCell.h"
#import "GOResourceObject.h"
#import "GOResourceListViewController.h"
#import "GOSensorDetailViewController.h"

@interface GOGroupEditViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) int requestType;
@property (nonatomic) UIBarButtonItem *cancelButton;
@property (nonatomic) NSMutableArray *selectedResources;
@property (nonatomic) GOHeaderTextCell *groupHeaderCell;
@property (nonatomic) GOResourceObject *pickedResource;

@end

@implementation GOGroupEditViewController

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
    self.groupHeaderCell = [self.tableView dequeueReusableCellWithIdentifier:kHeadCellIdentifier];
    self.groupHeaderCell.textField.delegate = self;
    self.groupHeaderCell.textField.text = self.groupObject.name;
    
    self.webservice = [[GOWebservice alloc] initWithView:self.view];
    self.webservice.delegate = self;
    
    if (self.groupObject) {
        self.editMode = YES;
        self.navigationItem.title = @"Gruppe bearbeiten";
        self.selectedResources = [NSMutableArray arrayWithArray:self.groupObject.resources];
    }
    else {
        self.editMode = NO;
        self.navigationItem.title = @"Gruppe erstellen";
        self.groupObject = [[GOGroupObject alloc] init];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickCancel:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.selectedResources = [[NSMutableArray alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.groupHeaderCell.infoLabel.text = [NSString stringWithFormat:@"Ressourcen: %i", (int)[self.selectedResources count]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return [self.selectedResources count];
    }
    else {
        return 1;
    }
    //return section == 0 ? 2 : [self.selectedResources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? self.groupHeaderCell : [tableView dequeueReusableCellWithIdentifier:kAddResourceCellIdentifier];
    }
    if (indexPath.section == 2) {
        return [tableView dequeueReusableCellWithIdentifier:kDeleteGroupCellIdentifier];
    }
    
    GOCustomObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomObjectCellIdentifier];
    GOResourceObject *resource = [self.selectedResources objectAtIndex:indexPath.row];
    cell.nameLabel.text = resource.name;
    cell.descriptionLabel.text = [GOResourceObject getDescriptionStringForResourceType:resource.resourceType];
    if (resource.coreType == GOCoreTypeSensor) {
        [cell.leftButton setTitle:@"Sensor" forState:UIControlStateNormal];
    }
    else {
        [cell.leftButton setTitle:@"Aktor" forState:UIControlStateNormal];
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? kHeaderCellHeight : kDefaultCellHeight;
    }
    else {
        return kCustomObjetCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:kAddResourecSegue sender:self];
    }
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        [self performSegueWithIdentifier:kUnwindFromGroupEdit sender:self];
    }
    else {
        
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:error.code]];
}

#pragma mark - Custom Object Cell Delegate

- (void)didPressLeftButtonOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    self.pickedResource = [self.selectedResources objectAtIndex:cell.indexPath.row];
    if (self.pickedResource.coreType == GOCoreTypeSensor) {
        [self performSegueWithIdentifier:kSensorDetailSegueFromGroupEdit sender:self];
    }
    
}

- (void)didDeleteMembershipOnGOCustomObjectCell:(GOCustomObjectCell *)cell {
    [self.selectedResources removeObjectAtIndex:cell.indexPath.row];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:cell.indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UI Alert Field Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Gruppe wird nicht gelöscht");
    }
    else if (buttonIndex == 1) {
        NSLog(@"Gruppe wird gelöscht");
        self.requestType = GODeleteRequest;
        [self.webservice deleteGroupWithID:self.groupObject._id];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddResourecSegue]) {
        GOResourceListViewController *dest = segue.destinationViewController;
        dest.selectedResources = self.selectedResources;
        dest.mainViewController = self.mainViewController;
    }
    
    
    else if ([segue.identifier isEqualToString:kSensorDetailSegueFromGroupEdit]) {
        GOSensorDetailViewController *dest = segue.destinationViewController;
        dest.sensorObject = self.pickedResource;
    }
}

#pragma mark - Actions

- (IBAction)onClickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickSave:(id)sender {
    self.groupObject.name = self.groupHeaderCell.textField.text;
    self.groupObject.resources = self.selectedResources;
    if (self.editMode) {
        self.requestType = GOPatchRequest;
        [self.webservice patchGroupForObject:self.groupObject];
    }
    else {
        self.requestType = GOPostRequest;
        [self.webservice postGroupForObject:self.groupObject];
    }
}

- (IBAction)onClickDelete:(id)sender {
    [self showMessage:(self)];
}


#pragma mark - Helper

- (IBAction)showMessage:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gruppe löschen"
                                                    message:@"Soll diese Gruppe wirklich gelöscht werden?"
                                                   delegate:self
                                          cancelButtonTitle:@"Nein"
                                          otherButtonTitles:@"Ja",nil];
    [alert show];
}

@end
