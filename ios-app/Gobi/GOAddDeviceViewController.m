//
//  GOAddDeviceViewController.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 16.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOAddDeviceViewController.h"

@interface GOAddDeviceViewController ()
@property (nonatomic) BOOL scanActive;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) NSString *scanText;
@property (nonatomic) GOWebservice *webservice;
@end

@implementation GOAddDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scanActive = YES;
    
    self.webservice = [[GOWebservice alloc] init];
    self.webservice.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startReading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        [self.mainViewController showErrorViewWithText:[error localizedDescription]];

        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    self.captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [self.captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.scanView.layer.bounds];
    [self.scanView.layer addSublayer:self.videoPreviewLayer];
    
    [self.captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    NSArray *scanTexts = [self.scanText componentsSeparatedByString:@":"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Neues Gerät" message:[NSString stringWithFormat:@"Das Gerät: ""%@"" hinzufügen?", [scanTexts firstObject]] delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
    
    [alert show];
}

#pragma mark - UI Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSArray *scanTexts = [self.scanText componentsSeparatedByString:@":"];
        [self.webservice postPreSharedKeyWithUUID:[scanTexts firstObject] key:[scanTexts lastObject] description:@"Neues Gerät"];
    }
    else {
        [self startReading];
    }
}

#pragma mark - AV Capture Metadata Output Objects Delegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.scanText = [metadataObj stringValue];
            
            //[self stopReading];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            self.scanActive = NO;
        }
    }
}

#pragma mark - Webservice Delegate

- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode {
    if (statuscode < kSuccessMaxRangeStatusCode) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
    }
}

- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error {
    [self.mainViewController showErrorViewWithText:[webservice getStringForErrorCode:error.code]];
}

#pragma mark - Actions

- (IBAction)onClickScan:(id)sender {
    self.scanActive ? [self stopReading] : [self startReading];
    self.scanActive = !self.scanActive;
}

- (IBAction)onClickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
