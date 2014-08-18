//
//  GOSettingsViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 07.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOAppDelegate.h"
#import "GOMainViewController.h"

#define kSettingsGeneralDetailSegue         @"settingsGeneralDetailSegue"
#define kSettingsDetailSegue                @"settingsDetailSegue"
#define kSettingsNotificationsDetailSegue   @"settingsNotificationsDetailSegue"

#define kListCellIdentifier           @"ListCell"


@interface GOSettingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MainCointainerProtocol>


#pragma mark - Properties

@property (strong, nonatomic) GOMainViewController *mainViewController;

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender;

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end


