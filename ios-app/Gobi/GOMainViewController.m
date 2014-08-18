//
//  GOMainViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 05.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOMainViewController.h"
#import "GODeviceListViewController.h"
#import "GOSettingsViewController.h"
#import "GOUserListViewController.h"
#import "GOMenuCell.h"
#import "GOTableViewHeader.h"
#import "GOAppDelegate.h"
#import "GOGroupListViewController.h"
#import "GORuleListViewController.h"
#import "GOWebservice.h"

@interface GOMainViewController ()
@property (nonatomic) UIOffset touchStartOffsetFromCenter;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) GOGroupListViewController *groupListViewController;
@property (nonatomic) GODeviceListViewController *deviceListViewController;
@property (nonatomic) GOUserListViewController *userListViewController;
@property (nonatomic) GORuleListViewController *ruleListViewController;
@property (nonatomic) GOWebservice *webservice;

@property (nonatomic) BOOL isMainWindowShown;
@property (nonatomic) NSArray *menuTitlesArray;
@property (nonatomic) NSArray *menuTitleIconsArray;
@property (nonatomic) CGPoint dragVelocity;
@end

@implementation GOMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self moveMainViewToXPosition:kMainFrameMovedToSideXPosition animated:YES];
    self.isMainWindowShown = NO;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.webservice = [[GOWebservice alloc] init];
    
    self.menuTitlesArray = @[@"Geräte", @"Gruppen", @"Regeln", @"Nutzer", @"Einstellungen", @"Logout"];
    self.menuTitleIconsArray = @[@"device-icon", @"group-icon", @"rule-icon", @"user-icon", @"settings-icon", @"logout"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other Methods

- (void)showErrorViewWithText:(NSString *)text {
    self.errorLabel.text = text;
    [UIView animateWithDuration:0.4 animations:^{
        self.errorView.alpha = 1.0;
    }];
    [self performSelector:@selector(hideErrorView) withObject:nil afterDelay:5.0];
}

- (void)hideErrorView {
    [UIView animateWithDuration:0.4 animations:^{
        self.errorView.alpha = 0.0;
    }];
}
- (void)showContainerView:(UIView *)container {
    self.deviceContainerView.hidden = !(container == self.deviceContainerView);
    self.settingsContainerView.hidden = !(container == self.settingsContainerView);
    self.usersContainerView.hidden = !(container == self.usersContainerView);
    self.groupsContainerView.hidden = !(container == self.groupsContainerView);
    self.rulesContainerView.hidden = !(container == self.rulesContainerView);
}

- (void)snapMainViewToVisible:(BOOL)visible {
    [self.animator removeAllBehaviors];
    float xPosition = visible ? 0.0 : kMainFrameMovedToSideXPosition;
    
    UIDynamicItemBehavior *dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.mainView]];
    dynamicBehavior.allowsRotation = NO;
    [self.animator addBehavior:dynamicBehavior];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.mainView snapToPoint:CGPointMake(xPosition + self.view.center.x, self.view.center.y)];
    snap.damping = 0.25;
    
    [self.animator addBehavior:snap];
}

- (void)moveMainViewToXPosition:(CGFloat)position animated:(BOOL)animated {
    if (position == kMainFrameMovedToSideXPosition) {
        [self toggleAlphaOfView:self.blockingView visible:YES];
    }
    else if (position == 0.0) {
        [self toggleAlphaOfView:self.blockingView visible:NO];
    }
    
    CGRect newFrame = self.mainView.frame;
    newFrame.origin.x = position;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mainView.frame = newFrame;
        }];
    }
    else {
        self.mainView.frame = newFrame;
    }
}

- (void)toggleAlphaOfView:(UIView *)view visible:(BOOL)show {
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = show ? 1.0 : 0.0;
    }];
}

- (void)toggleMainView {
    [self.animator removeAllBehaviors];
    if (self.isMainWindowShown) {
        [self moveMainViewToXPosition:kMainFrameMovedToSideXPosition animated:YES];
    }
    else {
        [self moveMainViewToXPosition:0.0 animated:YES];
    }
    self.isMainWindowShown = !self.isMainWindowShown;
}

#pragma mark - Actions

- (IBAction)onDragMoveMainView:(UIPanGestureRecognizer *)pen {
    CGPoint currentTouch = [self.panGestureRecognizer locationInView:self.view];
    [self.animator removeAllBehaviors];
    
    switch (pen.state) {
        case UIGestureRecognizerStateBegan: {
            self.touchStartOffsetFromCenter = UIOffsetMake(currentTouch.x - self.mainView.frame.origin.x, currentTouch.y);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            float difference = currentTouch.x - self.touchStartOffsetFromCenter.horizontal;
            if (difference >= kMainFrameMovedToSideXPosition && difference <= 0) {
                [self moveMainViewToXPosition:difference animated:NO];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            float difference = currentTouch.x - self.touchStartOffsetFromCenter.horizontal;

            if (self.isMainWindowShown) {
                if (difference <= -110.0) {
                    [self moveMainViewToXPosition:kMainFrameMovedToSideXPosition animated:YES];
                    self.isMainWindowShown = NO;
                }
                else {
                    [self snapMainViewToVisible:YES];
                }
            }
            else {
                if (difference > -110.0) {
                    [self moveMainViewToXPosition:0.0 animated:YES];
                    self.isMainWindowShown = YES;
                }
                else {
                    [self snapMainViewToVisible:NO];
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - UI Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self showContainerView:self.deviceContainerView];
            [self.deviceListViewController onClickRefresh:self];
        }
        else if (indexPath.row == 1) {
            [self showContainerView:self.groupsContainerView];
            [self.groupListViewController onClickRefresh:self];
        }
        else if (indexPath.row == 2) {
            [self showContainerView:self.rulesContainerView];
            [self.ruleListViewController onClickRefresh:self];
        }
        else if (indexPath.row == 3) {
            [self showContainerView:self.usersContainerView];
            [self.userListViewController onClickRefresh:self];
        }
        else if (indexPath.row == 4) {
            [self showContainerView:self.settingsContainerView];
        }
        else {
            [self performSegueWithIdentifier:kBackToLoginSegue sender:self];
        }
    }
    [self toggleMainView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GOTableViewHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MenuTableViewHeader" owner:self options:nil] lastObject];
    if (section == 0) {
        headerView.headerLabel.text = @"Alle Funktionen";
        headerView.imageIcon.image = [UIImage imageNamed:@"menu-icon"];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewHeaderViewHeight;
}

#pragma mark - UI Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuTitlesArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GOMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCellIdentifier];
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = [self.menuTitlesArray objectAtIndex:indexPath.row];
        cell.imageIcon.image = [UIImage imageNamed:[self.menuTitleIconsArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - Segue Handling

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:kBackToLoginSegue]) {
        UINavigationController *destination = segue.destinationViewController;
        UIViewController <MainCointainerProtocol> *nextViewController = [destination.viewControllers objectAtIndex:0];
        if ([nextViewController isKindOfClass:[GOGroupListViewController class]]) {
            self.groupListViewController = (GOGroupListViewController *)nextViewController;
        }
        else if ([nextViewController isKindOfClass:[GODeviceListViewController class]]) {
            self.deviceListViewController = (GODeviceListViewController *)nextViewController;
        }
        else if ([nextViewController isKindOfClass:[GORuleListViewController class]]) {
            self.ruleListViewController = (GORuleListViewController *)nextViewController;
        }
        else if ([nextViewController isKindOfClass:[GOUserListViewController class]]) {
            self.userListViewController = (GOUserListViewController *)nextViewController;
        }
        nextViewController.mainViewController = self;
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [self.webservice performLogout];
    }
}

@end
