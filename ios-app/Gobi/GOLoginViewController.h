//
//  GOLoginViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 19.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"

#define kLoginSegue         @"loginSegue"
#define kNewUserSegue       @"newUserSegue"

@interface GOLoginViewController : UIViewController<UITextFieldDelegate, GOWebserviceDelegate>

#define kContentViewCenterX         160.0
#define kContentViewCenterY         250.0

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)onClickLogin:(id)sender;
- (IBAction)onClickSignUp:(id)sender;

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue;
@end
