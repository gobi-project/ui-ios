//
//  GOMainViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 05.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMainFrameMovedToSideXPosition      -210.0
#define kMainFrameClosedVisiblePosi         110.0

#define kTableViewHeaderViewHeight          20.0


#define kEmbeddedDeviceListSegue            @"embeddedDeviceListSegue"
#define kEmbeddedTagListSegue               @"embeddedTagListSegue"
#define kEmbeddedSettingsSegue              @"embeddedSettingsSegue"
#define kEmbeddedUsersSegue                 @"embeddedUserListSegue"

#define kBackToLoginSegue                   @"backToLoginSegue"


#define kMenuCellIdentifier                 @"MenuCell"


@interface GOMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *backgroundTableView;
@property (weak, nonatomic) IBOutlet UIView *deviceContainerView;
@property (weak, nonatomic) IBOutlet UIView *settingsContainerView;
@property (weak, nonatomic) IBOutlet UIView *groupsContainerView;
@property (weak, nonatomic) IBOutlet UIView *rulesContainerView;
@property (weak, nonatomic) IBOutlet UIView *usersContainerView;


@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@property (weak, nonatomic) IBOutlet UIView *blockingView;

@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

#pragma mark - Actions

- (IBAction)onDragMoveMainView:(id)sender;

#pragma mark - Methods

- (void)toggleMainView;
- (void)showErrorViewWithText:(NSString *)text;

@end
