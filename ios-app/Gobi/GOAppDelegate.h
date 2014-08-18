//
//  GOAppDelegate.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 25.10.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
@class GOMainViewController;


@protocol MainCointainerProtocol <NSObject>
@property (strong, nonatomic) GOMainViewController *mainViewController;

@end

@interface GOAppDelegate : UIResponder <UIApplicationDelegate, GOWebserviceDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSTimer *notificationTimer;

@end
