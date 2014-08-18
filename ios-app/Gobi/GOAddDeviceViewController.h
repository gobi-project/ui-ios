//
//  GOAddDeviceViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 16.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GOMainViewController.h"
#import "GOWebservice.h"

@interface GOAddDeviceViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate, GOWebserviceDelegate, UIAlertViewDelegate>

@property (nonatomic) GOMainViewController *mainViewController;
@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

- (IBAction)onClickScan:(id)sender;
- (IBAction)onClickCancel:(id)sender;
@end
