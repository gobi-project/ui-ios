//
//  GOWebservice.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 11.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>

//Define API URL here

#define kREST_API                           @"http://localhost:3001/api/v1/"

#define kTimeOutIntervalForRequest          20.0

#define kWebserviceErrorDomain              @"Webservice-Error"
#define kBasicAuthenticationError           -2

#define kSuccessStatusCode                  200
#define kSuccessNoContentStatusCode         204
#define kSuccessMaxRangeStatusCode          300

#define kUserNameIdentifier                 @"username"
#define kPasswordIdentifier                 @"password"
#define kSessionIdentifier                  @"session"


#define kResourceNameLogin                  @"login"
#define kResourceNameDevices                @"devices"
#define kResourceNameUsers                  @"users"
#define kResourceNameResources              @"resources"
#define kResourceNameGroups                 @"groups"
#define kResourceNamePreSharedKey           @"psk"
#define kResourceNameRules                  @"rules"
#define kResourceNameMeasurements           @"measurements"
#define kResourceNameStates                 @"states"
#define kResourceNameNotification           @"notifications"

@class GOWebservice;
@class GODeviceObject;
@class GOUserObject;
@class GOResourceObject;
@class GOGroupObject;
@class GORuleObject;
@class GORuleStateObject;
@class GOMeasurementObject;


typedef NS_ENUM(NSInteger, GORequestTypes) {
    GOSingleGetRequest,
    GOGetAllRequest,
    GOPatchRequest,
    GOPostRequest,
    GODeleteRequest,
    GOAlternativeRequest
};

typedef NS_ENUM(NSInteger, GOAccessRights) {
    GOAccessRightAdmin,
    GOAccessRightUser,
    GOAccessRightGuest
};


@protocol GOWebserviceDelegate <NSObject>
- (void)webservice:(GOWebservice *)webservice didFinishLoadingData:(NSData *)data withStatusCode:(NSInteger)statuscode;
- (void)webservice:(GOWebservice *)webservice didFailWithError:(NSError *)error;
@end


@interface GOWebservice : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate> 

@property (weak, nonatomic) id <GOWebserviceDelegate> delegate;

- (instancetype)initWithView:(UIView *)view;

#pragma mark - Login / Logout

- (void)performLoginWithUsername:(NSString *)username password:(NSString *)password;
- (void)performLogout;

#pragma mark - Devices

- (void)getAllDevices;
- (void)getDeviceWithID:(uint)deviceId;
- (void)patchDeviceForObject:(GODeviceObject *)deviceObject;
- (void)deleteDeviceWithID:(uint)deviceId;

#pragma mark - Users

- (void)getAllUsers;
- (void)getUserWithID:(uint)userId;
- (void)patchUserForObject:(GOUserObject *)userObject;
- (void)postUserForObject:(GOUserObject *)userObject;
- (void)deleteUserWithID:(uint)userId;

#pragma mark - Resources

- (void)getAllResources;
- (void)patchResourcesForObject:(GOResourceObject *)resourceObject forDeviceObjectId:(uint)deviceId asSensor:(BOOL)sensor;

#pragma mark - Groups

- (void)getAllGroups;
- (void)getGroupWithID:(uint)groupId;
- (void)patchGroupForObject:(GOGroupObject *)groupObject;
- (void)postGroupForObject:(GOGroupObject *)groupObject;
- (void)deleteGroupWithID:(uint)groupId;

#pragma mark - Rules

- (void)getAllRules;
- (void)getRuleWithID:(uint)ruleId;
- (void)patchRuleForObject:(GORuleObject *)ruleObject;
- (void)postRuleForObject:(GORuleObject *)ruleObject;
- (void)deleteRuleWithID:(uint)ruleId;

#pragma mark - Rule States

- (void)getAllRuleStates;
- (void)postRuleStateForObject:(GORuleStateObject *)ruleState;
- (void)deleteRuleStateWithID:(uint)ruleStateId;

#pragma mark - Pre-Shared Key

- (void)postPreSharedKeyWithUUID:(NSString *)uuid key:(NSString *)key description:(NSString *)desc;

#pragma mark - Measurements

- (void)getMeasurementsForSensorObject:(GOResourceObject *)sensor fromDate:(NSDate *)from toDate:(NSDate *)to withGranularity:(uint)granularity;

#pragma mark - Notifications

- (void)getAllNotificationsUnread:(BOOL)unread;

#pragma mark - Error Strings

- (NSString *)getStringForErrorCode:(long)code;

@end
