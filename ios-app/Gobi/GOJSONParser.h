//
//  GOJSONParser.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 11.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GODeviceObject;
@class GOUserObject;
@class GOResourceObject;
@class GOGroupObject;
@class GORuleObject;
@class GORuleStateObject;
@class GORuleConditionAssociationObject;
@class GOMeasurementObject;
@class GONotificationObject;

typedef NS_ENUM(NSInteger, GOParseArrayIdentifier) {
    GOParseDeviceObjectArray,
    GOParseUserObjectArray,
    GOParseResourceObjectArray,
    GOParseGroupObjectArray,
    GOParseRuleObjectArray,
    GOParseRuleStateObjectArray,
    GOParseRuleConditionAssociationObjectArray,
    GOParseMeasurementObjectArray,
    GOParseNotificationObjectArray
};

@interface GOJSONParser : NSObject

#pragma mark - Devices

+ (GODeviceObject *)parseDeviceObjectFromDictionary:(NSDictionary *)dict;
+ (NSData *)parseJSONDataFromDeviceObject:(GODeviceObject *)deviceObject;

#pragma mark - Users

+ (GOUserObject *)parseUserObjectFromDictionary:(NSDictionary *)dict;
+ (NSData *)parseJSONDataFromUserObject:(GOUserObject *)userObject;

#pragma mark - Resources

+ (GOResourceObject *)parseResourceObjectFromDictionary:(NSDictionary *)dict;
+ (NSData *)parseJSONDataFromResourceObject:(GOResourceObject *)resourceObject asSensor:(BOOL)sensor;

#pragma mark - Groups

+ (GOGroupObject *)parseGroupObjectFromDictionary:(NSDictionary *)dict;
+ (NSData *)parseJSONDataFromGroupObject:(GOGroupObject *)groupObject;

#pragma mark - Rules

+ (GORuleObject *)parseRuleObjectFromDictionary:(NSDictionary *)dict;
+ (NSData *)parseJSONDataFromRuleObject:(GORuleObject *)ruleObject;

#pragma mark - Rule States

+ (GORuleStateObject *)parseRuleStateObjectFromDictionary:(NSDictionary *)dict;
+ (NSData *)parseJSONDataFromRuleStateObject:(GORuleStateObject *)ruleStateObject;

#pragma mark - Rule Condition Associations

+ (GORuleConditionAssociationObject *)parseRuleConditionAssociationObjectFromDictionary:(NSDictionary *)dict;
+ (NSData *)parseJSONDataFromRuleConditionAssociationObject:(GORuleConditionAssociationObject *)ruleStateObject;

#pragma mark - Measurements

+ (GOMeasurementObject *)parseMeasurementObjectFromDictionary:(NSDictionary *)dict;

#pragma mark - Notifications

+ (GONotificationObject *)parseNotificationObjectFromDictionary:(NSDictionary *)dict;

#pragma mark - Parse Object-Arrays

+ (NSMutableArray *)parseObjectArrayFromJSONData:(id)data forIdentifier:(GOParseArrayIdentifier)identifier;

@end
