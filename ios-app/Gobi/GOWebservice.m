//
//  GOWebservice.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 11.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOWebservice.h"
#import "GOJSONParser.h"
#import "GODeviceObject.h"
#import "GOUserObject.h"
#import "GOGroupObject.h"
#import "GORuleObject.h"
#import "GOResourceObject.h"

@interface GOWebservice ()
@property (nonatomic) NSMutableURLRequest *urlRequest;
@property (nonatomic) NSURLConnection *urlConnection;
@property (nonatomic) NSMutableData *receivedData;
@property (nonatomic) uint httpStatuscode;

@property (nonatomic) UIView *loadingView;
@end

@implementation GOWebservice

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        self.loadingView = [[UIView alloc] initWithFrame:view.frame];
        self.loadingView.backgroundColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:0.5];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator startAnimating];
        activityIndicator.center = view.center;
        [self.loadingView addSubview:activityIndicator];
        
        self.loadingView.alpha = 0.0;
        [view addSubview:self.loadingView];
    }
    return self;
}

#pragma mark - Login / Logout

- (void)performLoginWithUsername:(NSString *)username password:(NSString *)password {
    NSDictionary *dataDict = @{@"username": username,
                               @"password": password};
    [self sendURLRequestWithData:[NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] withHTTPMethod:@"POST" requestURL:[self composeRequestURLStringForResourceString:kResourceNameLogin resourceId:0 withQueryString:nil]];
}

- (void)performLogout {
    [self sendURLRequestWithData:nil withHTTPMethod:@"DELETE" requestURL:[self composeRequestURLStringForResourceString:kResourceNameLogin resourceId:0 withQueryString:[NSString stringWithFormat:@"?session=%@", [[[NSUserDefaults standardUserDefaults] objectForKey:kSessionIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}

#pragma mark - Devices

- (void)getAllDevices {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameDevices resourceId:0 withQueryString:nil]];
}

- (void)getDeviceWithID:(uint)deviceId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameDevices resourceId:deviceId withQueryString:nil]];
}

- (void)patchDeviceForObject:(GODeviceObject *)deviceObject {
    NSData *deviceData = [GOJSONParser parseJSONDataFromDeviceObject:deviceObject];
    [self sendURLRequestWithData:deviceData withHTTPMethod:@"PATCH" requestURL:[self composeRequestURLStringForResourceString:kResourceNameDevices resourceId:deviceObject._id withQueryString:nil]];

}

- (void)deleteDeviceWithID:(uint)deviceId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"DELETE" requestURL:[self composeRequestURLStringForResourceString:kResourceNameDevices resourceId:deviceId withQueryString:nil]];
}

#pragma mark - Users

- (void)getAllUsers {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameUsers resourceId:0 withQueryString:nil]];
}

- (void)getUserWithID:(uint)userId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameUsers resourceId:userId withQueryString:nil]];
}

- (void)deleteUserWithID:(uint)userId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"DELETE" requestURL:[self composeRequestURLStringForResourceString:kResourceNameUsers resourceId:userId withQueryString:nil]];
}

- (void)patchUserForObject:(GOUserObject *)userObject {
    NSData *userData = [GOJSONParser parseJSONDataFromUserObject:userObject];
    [self sendURLRequestWithData:userData withHTTPMethod:@"PATCH" requestURL:[self composeRequestURLStringForResourceString:kResourceNameUsers resourceId:userObject._id withQueryString:nil]];
}

- (void)postUserForObject:(GOUserObject *)userObject {
    NSData *userData = [GOJSONParser parseJSONDataFromUserObject:userObject];
    [self sendURLRequestWithData:userData withHTTPMethod:@"POST" requestURL:[self composeRequestURLStringForResourceString:kResourceNameUsers resourceId:0 withQueryString:nil]];
}

#pragma mark - Resources

- (void)getAllResources {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameResources resourceId:0 withQueryString:nil]];
}

- (void)patchResourcesForObject:(GOResourceObject *)resourceObject forDeviceObjectId:(uint)deviceId asSensor:(BOOL)sensor {
    NSData *resourceData = [GOJSONParser parseJSONDataFromResourceObject:resourceObject asSensor:sensor];
    [self sendURLRequestWithData:resourceData withHTTPMethod:@"PATCH" requestURL:[self composeRequestURLStringForResourceString:kResourceNameResources resourceId:resourceObject._id overResourceString:kResourceNameDevices mainResourceId:deviceId withQueryString:nil]];
}

#pragma mark - Groups

- (void)getAllGroups {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameGroups resourceId:0 withQueryString:nil]];
}

- (void)getGroupWithID:(uint)groupId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameGroups resourceId:groupId withQueryString:nil]];
}

- (void)patchGroupForObject:(GOGroupObject *)groupObject {
    NSData *groupData = [GOJSONParser parseJSONDataFromGroupObject:groupObject];
    [self sendURLRequestWithData:groupData withHTTPMethod:@"PATCH" requestURL:[self composeRequestURLStringForResourceString:kResourceNameGroups resourceId:groupObject._id withQueryString:nil]];
}

- (void)postGroupForObject:(GOGroupObject *)groupObject {
    NSData *groupData = [GOJSONParser parseJSONDataFromGroupObject:groupObject];
    [self sendURLRequestWithData:groupData withHTTPMethod:@"POST" requestURL:[self composeRequestURLStringForResourceString:kResourceNameGroups resourceId:0 withQueryString:nil]];
}

- (void)deleteGroupWithID:(uint)groupId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"DELETE" requestURL:[self composeRequestURLStringForResourceString:kResourceNameGroups resourceId:groupId withQueryString:nil]];
}

#pragma mark - Rules

- (void)getAllRules {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameRules resourceId:0 withQueryString:nil]];
}

- (void)getRuleWithID:(uint)ruleId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameRules resourceId:ruleId withQueryString:nil]];
}

- (void)patchRuleForObject:(GORuleObject *)ruleObject {
    NSData *ruleData = [GOJSONParser parseJSONDataFromRuleObject:ruleObject];
    [self sendURLRequestWithData:ruleData withHTTPMethod:@"PATCH" requestURL:[self composeRequestURLStringForResourceString:kResourceNameRules resourceId:ruleObject._id withQueryString:nil]];
}

- (void)postRuleForObject:(GORuleObject *)ruleObject {
    NSData *ruleData = [GOJSONParser parseJSONDataFromRuleObject:ruleObject];
    [self sendURLRequestWithData:ruleData withHTTPMethod:@"POST" requestURL:[self composeRequestURLStringForResourceString:kResourceNameRules resourceId:0 withQueryString:nil]];
}

- (void)deleteRuleWithID:(uint)ruleId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"DELETE" requestURL:[self composeRequestURLStringForResourceString:kResourceNameRules resourceId:ruleId withQueryString:nil]];
}

#pragma mark - Rule States

- (void)getAllRuleStates {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameStates resourceId:0 withQueryString:nil]];
}

- (void)postRuleStateForObject:(GORuleStateObject *)ruleState {
    NSData *ruleStateData = [GOJSONParser parseJSONDataFromRuleStateObject:ruleState];
    [self sendURLRequestWithData:ruleStateData withHTTPMethod:@"POST" requestURL:[self composeRequestURLStringForResourceString:kResourceNameStates resourceId:0 withQueryString:nil]];
}

- (void)deleteRuleStateWithID:(uint)ruleStateId {
    [self sendURLRequestWithData:nil withHTTPMethod:@"DELETE" requestURL:[self composeRequestURLStringForResourceString:kResourceNameStates resourceId:ruleStateId withQueryString:nil]];
}

#pragma mark - Pre-Shared Key

- (void)postPreSharedKeyWithUUID:(NSString *)uuid key:(NSString *)key description:(NSString *)desc {
    NSDictionary *dataDict = @{@"uuid": uuid,
                               @"psk": key,
                               @"desc": desc
                               };
    [self sendURLRequestWithData:[NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] withHTTPMethod:@"POST" requestURL:[self composeRequestURLStringForResourceString:kResourceNamePreSharedKey resourceId:0 withQueryString:nil]];
}

#pragma mark - Measurements

- (void)getMeasurementsForSensorObject:(GOResourceObject *)sensor fromDate:(NSDate *)from toDate:(NSDate *)to withGranularity:(uint)granularity {
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameResources resourceId:sensor._id overResourceString:kResourceNameDevices mainResourceId:sensor.deviceId withQueryString:[NSString stringWithFormat:@"/%@?&from=%0.f&to=%0.f&granularity=%i&", kResourceNameMeasurements, [from timeIntervalSince1970], [to timeIntervalSince1970], granularity]]];
}

#pragma mark - Notifications

- (void)getAllNotificationsUnread:(BOOL)unread {
    NSString *queryString = unread ? @"&read=0" : @"&read=1";
    
    [self sendURLRequestWithData:nil withHTTPMethod:@"GET" requestURL:[self composeRequestURLStringForResourceString:kResourceNameNotification resourceId:0 withQueryString:queryString]];
}

#pragma mark
#pragma mark - Other Methods

- (NSString *)composeRequestURLStringForResourceString:(NSString *)resourceString resourceId:(uint)resourceId withQueryString:(NSString *)queryString {
    NSMutableString *resultString = [NSMutableString stringWithFormat:@"%@%@", kREST_API, resourceString];
    if (resourceId > 0) {
        [resultString appendString:[NSString stringWithFormat:@"/%i", resourceId]];
    }
    
    if (![resourceString isEqualToString:kResourceNameLogin]) {
        [resultString appendString:[NSString stringWithFormat:@"?session=%@", [[[NSUserDefaults standardUserDefaults] objectForKey:kSessionIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    if (queryString) {
        [resultString appendString:queryString];
    }
    
    return resultString;
}

- (NSString *)composeRequestURLStringForResourceString:(NSString *)resourceString resourceId:(uint)resourceId overResourceString:(NSString *)mainResourceString mainResourceId:(uint)mainResourceId withQueryString:(NSString *)queryString {
    NSMutableString *resultString = [NSMutableString stringWithFormat:@"%@%@", kREST_API, mainResourceString];
    if (mainResourceId > 0) {
        [resultString appendString:[NSString stringWithFormat:@"/%i", mainResourceId]];
    }
    [resultString appendString:[NSString stringWithFormat:@"/%@", resourceString]];
    if (resourceId > 0) {
        [resultString appendString:[NSString stringWithFormat:@"/%i", resourceId]];
    }
    if (queryString) {
        [resultString appendString:queryString];
    }
    else {
        [resultString appendString:@"?"];
    }
    [resultString appendString:[NSString stringWithFormat:@"session=%@", [[[NSUserDefaults standardUserDefaults] objectForKey:kSessionIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];


    
    return resultString;
}

- (void)sendURLRequestWithData:(NSData *)data withHTTPMethod:(NSString *)method requestURL:(NSString *)requestURL {
    self.urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTimeOutIntervalForRequest];
    
    if (![method isEqualToString:@"GET"]){
        [self.urlRequest setHTTPMethod:method];
        [self.urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    if (data) {
        [self.urlRequest setHTTPBody:data];
    }
    
    
    NSLog(@"Sending Request to: %@ %@", method, requestURL);
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self];
    if (!self.urlConnection) {
        
    }
    else {
        [self toggleLoadingViewToVisible:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

#pragma mark
#pragma mark - NSURL Connection Delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self toggleLoadingViewToVisible:NO];
    NSLog(@"Webservice: Connection Failed = Could not be established.");
    [self.delegate webservice:self didFailWithError:error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - NSURL Connection Data Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
    self.httpStatuscode = (int)httpresponse.statusCode;
    NSLog(@"Webservice: Received Response With Status Code: %i", self.httpStatuscode);
    self.receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self toggleLoadingViewToVisible:NO];
    NSLog(@"Webservice: Finished Loading Data");
    [self.delegate webservice:self didFinishLoadingData:self.receivedData withStatusCode:self.httpStatuscode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Helper

- (NSString *)getStringForErrorCode:(long)code {
    switch (code) {
        case kBasicAuthenticationError:
            return @"Ungültige Zugangsdaten";
        case NSURLErrorNotConnectedToInternet:
            return @"Keine Verbindung zum Internet";
        default:
            return @"Unbekannter Fehler";
    }
}

- (void)toggleLoadingViewToVisible:(BOOL)visible {
    [UIView animateWithDuration:0.4 animations:^{
        self.loadingView.alpha = visible ? 1.0 : 0.0;
    }];
}


@end
