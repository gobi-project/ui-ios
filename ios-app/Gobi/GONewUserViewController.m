//
//  GONewUserViewController.m
//  Gobi
//
//  Created by Franziska Lorz on 24.04.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GONewUserViewController.h"
#import "GOUserObject.h"
#import "GOJSONParser.h"
#import "GOWebservice.h"

@interface GONewUserViewController ()
@property (nonatomic) GOWebservice *webservice;
@property (nonatomic) int requestType;
@property (nonatomic) UIDynamicAnimator *animator;
@end



@implementation GONewUserViewController

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
    [self.webservice getAllUsers];
    
    self.userObject = [[GOUserObject alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (statuscode == 401) {
        NSLog(@"LOGIN FAIL");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNameIdentifier];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (statuscode == 400) {
        NSLog(@"LOGIN FAIL");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNameIdentifier];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        //TODO: Connection Fehler
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    if (error.code == kBasicAuthenticationError) {
        NSLog(@"LOGIN FAIL");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNameIdentifier];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (error.code == NSURLErrorNotConnectedToInternet) {
        //TODO: Fehlermeldung anpassen
    }
}

#pragma mark - Helper

- (void)showErrorLabel {
    self.errorLabel.hidden = NO;
}

#pragma mark - Actions

- (IBAction)onClickSave:(id)sender {
    self.userObject.username = self.nameTextField.text;
    self.userObject.email = self.emailTextField.text;
    self.userObject.password = self.pwdTextField.text;
    self.requestType = GOPostRequest;
    
    if ([self.pwdConfTextField.text isEqualToString:self.pwdTextField.text]) {
        [self.webservice postUserForObject:self.userObject];
        
        [self.view endEditing:YES];
        [[NSUserDefaults standardUserDefaults] setObject:self.userObject.username forKey:kUserNameIdentifier];
        [[NSUserDefaults standardUserDefaults] setObject:self.userObject.password forKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:kUnwindSegueToLogin sender:self];

    } else {
        [self showErrorLabel];
    }
    
    
}

- (IBAction)onClickCancel:(id)sender {
    [self performSegueWithIdentifier:kUnwindSegueToLogin sender:self];
}

@end
