//
//  GOStartUpViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 06.05.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
#define kStartToLoginSegue      @"startToLoginSegue"
#define kAutoLoginSegue         @"autoLoginSegue"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface GOStartUpViewController : UIViewController<GOWebserviceDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
