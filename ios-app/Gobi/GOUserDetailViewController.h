//
//  GOUserDetailViewController.h
//  Gobi
//
//  Created by Franziska Lorz on 24.04.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
#import "GOUserObject.h"
#import "GOMainViewController.h"

@class GOUserObject;

#define kUserCellIdentifier              @"UserCell"

#define kUnwindFromUserDetail            @"unwindToUserListFromUserDetail"

@interface GOUserDetailViewController : UIViewController<UITextFieldDelegate, GOWebserviceDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

#pragma mark - Properties

@property (nonatomic) GOUserObject *userObject;
@property (nonatomic) GOMainViewController *mainViewController;

#pragma mark - Outlets & Actions

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)onClickSave:(id)sender;
- (IBAction)onClickDelete:(id)sender;

@end