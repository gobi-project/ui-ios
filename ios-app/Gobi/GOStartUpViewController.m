//
//  GOStartUpViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 06.05.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOStartUpViewController.h"


@interface GOStartUpViewController ()
@property (nonatomic) GOWebservice *webservice;
@end

@implementation GOStartUpViewController

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
    if (!IS_IPHONE_5) {
        self.backgroundImageView.image = [UIImage imageNamed:@"GOLaunch@2x"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserNameIdentifier] && [[NSUserDefaults standardUserDefaults] valueForKey:kPasswordIdentifier]) {
        self.webservice = [[GOWebservice alloc] init];
        self.webservice.delegate = self;
        [self.webservice performLoginWithUsername:[[NSUserDefaults standardUserDefaults] valueForKey:kUserNameIdentifier] password:[[NSUserDefaults standardUserDefaults] valueForKey:kPasswordIdentifier]];
    }
    else {
        [self performSelector:@selector(showLoginScreen) withObject:nil afterDelay:1.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GO Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"session"] forKey:kSessionIdentifier];
        [self performSegueWithIdentifier:kAutoLoginSegue sender:self];
    }
    else {
        //TODO: Connection Fehler
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:kStartToLoginSegue sender:self];
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failure2");
    if (error.code == kBasicAuthenticationError) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (error.code == NSURLErrorNotConnectedToInternet) {
        //TODO: Fehlermeldung anpassen
    }
    [self performSegueWithIdentifier:kStartToLoginSegue sender:self];
}

#pragma mark - Helper

- (void)showLoginScreen {
    [self performSegueWithIdentifier:kStartToLoginSegue sender:self];
}

@end
