//
//  GOSettingsViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 07.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOSettingsViewController.h"

@interface GOSettingsViewController ()

@end

@implementation GOSettingsViewController

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
    
    // Customize Buttons
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:kSettingsGeneralDetailSegue sender:self];
    }
    else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:kSettingsNotificationsDetailSegue sender:self];
    }
}


#pragma mark - UI Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kListCellIdentifier];
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"General"];
    }
    else if (indexPath.row == 1) {
        [cell.textLabel setText:@"Notifications"];
    }
    
    return cell;
}

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender {
    [self.mainViewController toggleMainView];
}





@end

