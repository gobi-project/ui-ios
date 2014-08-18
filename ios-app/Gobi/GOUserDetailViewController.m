//
//  GOUserDetailViewController.m
//  Gobi
//
//  Created by Franziska Lorz on 24.04.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOUserDetailViewController.h"
#import "GOUserObject.h"
#import "GOUserListViewController.h"

@interface GOUserDetailViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) int requestType;
@end

@implementation GOUserDetailViewController

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
    self.webservice = [[GOWebservice alloc] init];
    self.webservice.delegate = self;
    
    self.nameTextField.text = self.userObject.username;
    self.emailTextField.text = self.userObject.email;
    self.pwdTextField.text = self.userObject.password;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UI Alert Field Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Nutzer wird nicht gelöscht");
    }
    else if (buttonIndex == 1) {
        NSLog(@"Nutzer wird gelöscht");
        self.requestType = GODeleteRequest;
        [self.webservice deleteUserWithID:self.userObject._id];
    }
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        [self performSegueWithIdentifier:kUnwindFromUserDetail sender:self];
    }
    else {
        
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:error.code]];
}

#pragma mark - Actions

- (IBAction)onClickSave:(id)sender {
    self.userObject.password = self.pwdTextField.text;
    
    NSString *password = self.userObject.password;
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:kPasswordIdentifier] isEqualToString:password]) {
            
        self.userObject.username = self.nameTextField.text;
        self.userObject.email = self.emailTextField.text;
        
        [[NSUserDefaults standardUserDefaults] setObject:self.userObject.username forKey:kUserNameIdentifier];
        [[NSUserDefaults standardUserDefaults] setObject:self.userObject.password forKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.requestType = GOPatchRequest;
        [self.webservice patchUserForObject:self.userObject];
    }
    else {
        [self showErrorLabel];
    }
}

- (IBAction)onClickDelete:(id)sender {
    [self showMessage:(self)];
}


#pragma mark - Helper

- (IBAction)showMessage:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nutzer löschen"
                                                    message:@"Soll dieser Nutzer wirklich gelöscht werden?"
                                                   delegate:self
                                          cancelButtonTitle:@"Nein"
                                          otherButtonTitles:@"Ja",nil];
    [alert show];
}

- (void)showErrorLabel {
    self.errorLabel.hidden = NO;
}

@end
