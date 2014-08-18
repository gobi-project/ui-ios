//
//  GOAppDelegate.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 25.10.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOAppDelegate.h"
#import "GOJSONParser.h"
#import "GONotificationObject.h"

@interface GOAppDelegate ()
@property GOWebservice *webservice;
@end

@implementation GOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.webservice = [[GOWebservice alloc] init];
    self.webservice.delegate = self;
    self.notificationTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getNotifications) userInfo:nil repeats:YES];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helper

- (void)getNotifications {
    [self.webservice getAllNotificationsUnread:YES];
}

#pragma mark - GO Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode == kSuccessStatusCode) {
        NSMutableArray *notifications = [GOJSONParser parseObjectArrayFromJSONData:data forIdentifier:GOParseNotificationObjectArray];
        if (notifications.count > 0) {
            GONotificationObject *notification = notifications.lastObject;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Neues Gerät" message:notification.text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    NSLog(@"Failed to load notifications");
}


@end
