//
//  GOTagListViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 05.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOAppDelegate.h"
#import "GOMainViewController.h"

@interface GOTagListViewController : UIViewController<MainCointainerProtocol>

#pragma mark - Properties

@property (strong, nonatomic) GOMainViewController *mainViewController;


#pragma mark - Actions

- (IBAction)onClickToggleMenu:(id)sender;


@end
