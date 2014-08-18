//
//  GOSettingsGeneralViewController.h
//  Gobi
//
//  Created by Franziska Lorz on 11.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GOSettingsGeneralViewController : UIViewController

# pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *volumeValue;



# pragma mark - Actions

- (IBAction) volumeValueChanged:(id)sender;

@end
