//
//  GOTagListViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 05.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOTagListViewController.h"

@interface GOTagListViewController ()

@end

@implementation GOTagListViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender {
    [self.mainViewController toggleMainView];
}

@end
