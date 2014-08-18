//
//  GOLoginViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 19.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOLoginViewController.h"
#import "GOJSONParser.h"
#import "GONewUserViewController.h"

@interface GOLoginViewController ()
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) GOWebservice *webservice;

@end

@implementation GOLoginViewController

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
    
    self.webservice = [[GOWebservice alloc] init];
    self.webservice.delegate = self;
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated{
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserNameIdentifier]) {
        self.userNameTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:kUserNameIdentifier];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kPasswordIdentifier]) {
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:kPasswordIdentifier];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else {
        [self.passwordTextField resignFirstResponder];
        [self onClickLogin:self];
    }
    return YES;
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"session"] forKey:kSessionIdentifier];
        [self performSegueWithIdentifier:kLoginSegue sender:self];
        NSLog(@"login success");
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self shakeContenView];
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    if (error.code == kBasicAuthenticationError) {
        NSLog(@"LOgin FAIL");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self shakeContenView];
    }
    else if (error.code == NSURLErrorNotConnectedToInternet) {
        //TODO: Fehlermeldung anpassen
    }
}

#pragma mark - Helper

- (void)shakeContenView {
    self.contentView.center = CGPointMake(kContentViewCenterX, kContentViewCenterY);
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.center = CGPointMake(kContentViewCenterX + 80, kContentViewCenterY);
    }];
    
    UIDynamicItemBehavior *dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
    dynamicBehavior.allowsRotation = NO;
    [self.animator addBehavior:dynamicBehavior];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.contentView snapToPoint:CGPointMake(kContentViewCenterX, kContentViewCenterY)];
    snap.damping = 0.1;
    
    [self.animator addBehavior:snap];
    self.errorLabel.hidden = NO;
}

#pragma mark - Actions

- (IBAction)onClickLogin:(id)sender {
    self.errorLabel.hidden = YES;
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextField.text forKey:kUserNameIdentifier];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:kPasswordIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.webservice performLoginWithUsername:self.userNameTextField.text password:self.passwordTextField.text];
}

#pragma mark - Actions

- (IBAction)onClickSignUp:(id)sender {
    [self performSegueWithIdentifier:kNewUserSegue sender:self];
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue {}



@end
