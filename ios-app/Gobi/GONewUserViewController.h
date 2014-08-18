//
//  GONewUserViewController.h
//  Gobi
//
//  Created by Franziska Lorz on 24.04.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
#import "GOUserObject.h"
#import "GOLoginViewController.h"

#define kUserCellIdentifier              @"UserCell"

#define kUnwindSegueToLogin                 @"unwindFromSignUp"
#define kLoginFromNewUserSegue              @"loginFromNewUserSegue"

@interface GONewUserViewController : UIViewController< UITextFieldDelegate, GOWebserviceDelegate >

#pragma mark - Properties


@property (nonatomic) GOLoginViewController *loginViewController;
@property (nonatomic) GOUserObject *userObject;

#pragma mark - Outlets & Actions

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


- (IBAction)onClickSave:(id)sender;
- (IBAction)onClickCancel:(id)sender;

@end
