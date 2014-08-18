//
//  GOResourceListViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 30.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOResourceListViewController.h"
#import "GOResourceObject.h"
#import "GOGroupObject.h"
#import "GOJSONParser.h"
#import "GORuleStateEditViewController.h"

@interface GOResourceListViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) int requestType;
@property (nonatomic) BOOL ruleMode;
@end

@implementation GOResourceListViewController

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
    
    self.ruleMode = [[self.navigationController.viewControllers firstObject] isKindOfClass:[GORuleStateEditViewController class]];

    self.requestType = GOGetAllRequest;
    [self.webservice getAllResources];
    
    self.searchDisplayController.searchBar.showsScopeBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Search Display Controller Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSMutableArray *searchSensors = [[NSMutableArray alloc] init];
    NSMutableArray *searchActuators = [[NSMutableArray alloc] init];
    
    if (!self.actionMode) {
        for (GOResourceObject *resource in [self.resources objectAtIndex:0]) {
            NSRange sensorRange = [[resource.name lowercaseString] rangeOfString:[searchString lowercaseString]];
            if (sensorRange.location != NSNotFound) {
                [searchSensors addObject:resource];
            }
        }
    }
   
    for (GOResourceObject *resource in [self.resources objectAtIndex:1]) {
        NSRange sensorRange = [[resource.name lowercaseString] rangeOfString:[searchString lowercaseString]];
        if (sensorRange.location != NSNotFound) {
            [searchActuators addObject:resource];
        }
    }
    self.searchResources = @[searchActuators, searchSensors];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.tableView reloadData];
}

#pragma mark - UI Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.actionMode ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView == self.searchDisplayController.searchResultsTableView) ? [[self.searchResources objectAtIndex:section] count] : [[self.resources objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *resourceArray = (tableView == self.searchDisplayController.searchResultsTableView) ? self.searchResources : self.resources;
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kListCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kListCellIdentifier];
    }
    GOResourceObject *object = [[resourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];;
    cell.textLabel.text = object.name;

    if (self.ruleMode) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = [self getRessourceObjectInGroup:object] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Aktuatoren" : @"Sensoren";
}

#pragma mark - UI Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *resourceArray = (tableView == self.searchDisplayController.searchResultsTableView) ? self.searchResources : self.resources;

    GOResourceObject *object;

    if (self.ruleMode) {
        self.pickedResource = [[resourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:kUnwindToRuleStateEditFromResourceList sender:self];
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        object = [[resourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        GOResourceObject *resource = [self getRessourceObjectInGroup:object];
        if (resource) {
            [self.selectedResources removeObject:resource];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            [self.selectedResources addObject:object];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOGetAllRequest) {
            NSMutableArray *allResources = [GOJSONParser parseObjectArrayFromJSONData:data forIdentifier:GOParseResourceObjectArray];
            self.resources = [self sortResourcesAsSensorsAndActuatorsForResourceArray:allResources];
            [self.tableView reloadData];
        }
    }
    else {
        
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:error.code]];
}

#pragma mark - Helper

- (NSArray *)sortResourcesAsSensorsAndActuatorsForResourceArray:(NSMutableArray *)resources {
    NSMutableArray *actuators = [[NSMutableArray alloc] init];
    NSMutableArray *sensors = [[NSMutableArray alloc] init];
    
    for (GOResourceObject *resource in resources) {
        if (resource.coreType == GOCoreTypeSensor) {
            [sensors addObject:resource];
        }
        else if (resource.coreType == GOCoreTypeActuator) {
            [actuators addObject:resource];
        }
    }
    return @[actuators, sensors];
}

- (GOResourceObject *)getRessourceObjectInGroup:(GOResourceObject *)object {
    for (GOResourceObject *resource in self.selectedResources) {
        if (resource._id == ((GOResourceObject *)object)._id) {
            return resource;
        }
    }
    return nil;
}

@end
