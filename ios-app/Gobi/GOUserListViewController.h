//
//  GOSettingsUsersViewController.h
//  Gobi
//
//  Created by Franziska Lorz on 23.04.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOMainViewController.h"
#import "GOAppDelegate.h"
#import "GOWebservice.h"
#import "GOCustomObjectCell.h"


#define kUserListCellIdentifier         @"UserListCell"
#define kUserDetailSegue                @"userDetailSegue"
#define kUnwindFromUserDetail           @"unwindToUserListFromUserDetail"

#define kListCellHeight                 60.0


@interface GOUserListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,  GOWebserviceDelegate>

#pragma mark - Properties

@property (strong, nonatomic) NSMutableArray *users;


# pragma mark - Outlets

@property (weak, nonatomic)   IBOutlet UITableView  *tableView;
@property (nonatomic) GOMainViewController *mainViewController;



#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender;
- (IBAction)onClickRefresh:(id)sender;
- (IBAction)unwindToUserList:(UIStoryboardSegue *)segue;

@end
