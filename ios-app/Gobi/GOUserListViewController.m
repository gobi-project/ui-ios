//
//  GOSettingsUsersViewController.m
//  Gobi
//
//  Created by Franziska Lorz on 23.04.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOUserListViewController.h"
#import "GOJSONParser.h"
#import "GOUserObject.h"
#import "GOWebservice.h"
#import "GOUserDetailViewController.h"

@interface GOUserListViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) GOUserObject *pickedUserObject;
@property (nonatomic) NSIndexPath *pickedUserIndexPath;
@property (nonatomic) int requestType;
@end

@implementation GOUserListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onClickRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.webservice = [[GOWebservice alloc] initWithView:self.view];
    self.webservice.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Table View Data Source / UI Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kListCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserListCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUserListCellIdentifier];
    GOUserObject *user = [self.users objectAtIndex:indexPath.row];
    
    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = user.email;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.pickedUserObject = [self.users objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kUserDetailSegue sender:self];
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    [self.refreshControl endRefreshing];
    if (statuscode < kSuccessMaxRangeStatusCode) {
        if (self.requestType == GOGetAllRequest) {
            self.users = [GOJSONParser parseObjectArrayFromJSONData:data forIdentifier:GOParseUserObjectArray];
            
            [self.tableView reloadData];
        }
    }
    else {
        
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:error.code]];
    [self.refreshControl endRefreshing];
}

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender {
    [self.mainViewController toggleMainView];
}

- (IBAction)onClickRefresh:(id)sender {
    self.requestType = GOGetAllRequest;
    [self.webservice getAllUsers];
}

- (IBAction)unwindToUserList:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:kUnwindFromUserDetail]) {
        NSLog(@"unwindToUserList: %@", kUnwindFromUserDetail);
        [self onClickRefresh:self];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kUserDetailSegue]) {
        GOUserDetailViewController *dest = segue.destinationViewController;
        dest.userObject = self.pickedUserObject;
    }
}



@end
