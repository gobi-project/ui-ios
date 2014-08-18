//
//  GOSettingsGeneralViewController.m
//  Gobi
//
//  Created by Franziska Lorz on 11.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOSettingsGeneralViewController.h"

@interface GOSettingsGeneralViewController ()

@end

@implementation GOSettingsGeneralViewController


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
	
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"volume"]) {
        NSString *volume = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"volume"]];
        self.volumeValue.text = volume;
        self.volumeSlider.value = [volume intValue];
    }
    else if ([self.volumeValue.text length] <= 0) {
        self.volumeValue.text = [NSString stringWithFormat:@"%i", 50];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - volume actions

- (IBAction) volumeValueChanged:(UISlider *)sender {
    
    // Cast float to int
    UISlider *slider = sender;
    NSString *intValue = [[NSString alloc] initWithFormat:@"%d", (int)slider.value];
    self.volumeValue.text = intValue;
    
    [[NSUserDefaults standardUserDefaults] setValue:self.volumeValue.text forKey:@"volume"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
