//
//  GOJSONParser.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 11.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import "GOJSONParser.h"
#import "GODeviceObject.h"
#import "GOUserObject.h"
#import "GOResourceObject.h"
#import "GOWebservice.h"
#import "GOGroupObject.h"
#import "GORuleObject.h"
#import "GORuleStateObject.h"
#import "GORuleConditionAssociationObject.h"
#import "GOMeasurementObject.h"
#import "GONotificationObject.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface GOJSONParser ()
typedef void(^ruleOperatorCompletion)(GORuleOperator);

@end

@implementation GOJSONParser

#pragma mark - Devices

+ (GODeviceObject *)parseDeviceObjectFromDictionary:(NSDictionary *)dict {
    GODeviceObject *deviceObject = [[GODeviceObject alloc] init];
    
    deviceObject._id = [[dict objectForKey:@"id"] intValue];
    if ([dict objectForKey:@"name"] && [dict objectForKey:@"name"] != [NSNull null]) {
        deviceObject.name = [dict objectForKey:@"name"];
    }
    else {
        deviceObject.name = @"";
    }
    deviceObject.description = [dict objectForKey:@"address"]; //TODO: Noch anpassen
    
    if ([dict objectForKey:kResourceNameResources]) {
        deviceObject.resources = [self parseObjectArrayFromJSONData:[dict objectForKey:kResourceNameResources] forIdentifier:GOParseResourceObjectArray];
    }

    return deviceObject;
}

+ (NSData *)parseJSONDataFromDeviceObject:(GODeviceObject *)deviceObject {
    NSDictionary *dataDict = @{@"name": deviceObject.name};
    return [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] ;
}

#pragma mark - Users

+ (GOUserObject *)parseUserObjectFromDictionary:(NSDictionary *)dict {
    GOUserObject *userObject = [[GOUserObject alloc] init];
    
    userObject._id = [[dict objectForKey:@"id"] intValue];
    userObject.username = [dict objectForKey:@"username"];
    userObject.email = [dict objectForKey:@"email"];
    
    return userObject;
}

+ (NSData *)parseJSONDataFromUserObject:(GOUserObject *)userObject {
    NSDictionary *dataDict = @{@"username": userObject.username,
                               @"email": userObject.email,
                               @"password": userObject.password};
    return [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] ;
}

#pragma mark - Resources

+ (GOResourceObject *)parseResourceObjectFromDictionary:(NSDictionary *)dict {
    GOResourceObject *resourceObject = [[GOResourceObject alloc] init];
    
    resourceObject._id = [[dict objectForKey:@"id"] intValue];
    resourceObject.deviceId = [[dict objectForKey:@"device_id"] intValue];
    resourceObject.name = [dict objectForKey:@"name"];
    
    resourceObject.value = [[dict objectForKey:@"value"] isKindOfClass:[NSNull class]] ? 0.0: [[dict objectForKey:@"value"] floatValue];
    resourceObject.resourceType = [GOResourceObject getResourceTypeFromString:[dict objectForKey:@"resource_type"]];
    resourceObject.coreType = [GOResourceObject getCoreTypeFromString:[dict objectForKey:@"interface_type"]];
    if ([dict objectForKey:@"unit"] && [dict objectForKey:@"unit"] != [NSNull null]) {
        resourceObject.unit = [GOResourceObject getUnitStringForAPIString:[dict objectForKey:@"unit"]];
    }
    else {
        resourceObject.unit = @"";
    }
    return resourceObject;
}

+ (NSData *)parseJSONDataFromResourceObject:(GOResourceObject *)resourceObject asSensor:(BOOL)sensor {
    NSDictionary *dataDict;
    if (sensor) {
        dataDict = @{@"name": resourceObject.name};
    }
    else {
        dataDict = @{@"value": @(resourceObject.value),
                     @"name": resourceObject.name};
    }
    NSLog(@"parseDict :%@", dataDict);
    return [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] ;
}

#pragma mark - Groups

+ (GOGroupObject *)parseGroupObjectFromDictionary:(NSDictionary *)dict {
    GOGroupObject *groupObject = [[GOGroupObject alloc] init];
    
    groupObject._id = [[dict objectForKey:@"id"] intValue];
    groupObject.name = [dict objectForKey:@"name"];
    
    if ([dict objectForKey:kResourceNameResources]) {
        groupObject.resources = [self parseObjectArrayFromJSONData:[dict objectForKey:kResourceNameResources] forIdentifier:GOParseResourceObjectArray];
    }
    
    return groupObject;
}

+ (NSData *)parseJSONDataFromGroupObject:(GOGroupObject *)groupObject {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:groupObject.name forKey:@"name"];
    NSMutableArray *resources = [[NSMutableArray alloc] init];
    
    for (GOResourceObject *resource in groupObject.resources) {
        [resources addObject:@(resource._id)];
    }
    
    [dataDict setObject:resources forKey:@"resources"];

    return [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - Rules

+ (GORuleObject *)parseRuleObjectFromDictionary:(NSDictionary *)dict {
    GORuleObject *ruleObject = [[GORuleObject alloc] init];
    ruleObject._id = [[dict objectForKey:@"id"] intValue];
    ruleObject.name = [dict objectForKey:@"name"];

    if ([dict objectForKey:@"actions"]) {
        ruleObject.actions = [self parseObjectArrayFromJSONData:[dict objectForKey:@"actions"] forIdentifier:GOParseRuleConditionAssociationObjectArray];
    }
    if ([dict objectForKey:@"conditions"]) {
        ruleObject.conditions = [self parseRuleConditionAssociationObjectArrayAsConditionsFromDictionary:[dict objectForKey:@"conditions"] ruleOperatorBlock:^(GORuleOperator ruleOperator) {
            NSLog(@"RuleOperator set: %@", [GORuleConditionAssociationObject getApiStringForRuleOperator:ruleOperator]);
            ruleObject.ruleOperator = ruleOperator;
        }];
    }
    
    return ruleObject;
}

+ (NSData *)parseJSONDataFromRuleObject:(GORuleObject *)ruleObject {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    

    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (GORuleConditionAssociationObject *assoc in ruleObject.actions) {
        NSDictionary *resource = @{@"id": @(assoc.resource._id),
                                   @"value": @(assoc.resource.value)};
        [actions addObject:resource];
    }
    
    [dataDict setObject:ruleObject.name forKey:@"name"];
    [dataDict setObject:actions forKey:@"actions"];

    if (ruleObject.ruleOperator == GORuleOperatorAny || ruleObject.ruleOperator == GORuleOperatorNone) {
        NSMutableArray *anyNoneArray = [[NSMutableArray alloc] init];
        for (GORuleStateObject *state in ruleObject.conditions) {
            [anyNoneArray addObject:@{@"conditions": @{@"states": @[@(state._id)]}}];
        }
        
        [dataDict setObject:@{[GORuleConditionAssociationObject getApiStringForRuleOperator:ruleObject.ruleOperator]: anyNoneArray} forKey:@"conditions"];
    }
    else {
        NSMutableArray *states = [[NSMutableArray alloc] init];
        for (GORuleStateObject *state in ruleObject.conditions) {
            [states addObject:@(state._id)];
        }
        NSDictionary *stateDict = @{@"states": states};
        [dataDict setObject:stateDict forKey:@"conditions"];
    }
    
    NSLog(@"parsed Rule: %@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);

    return [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - Rule States

+ (GORuleStateObject *)parseRuleStateObjectFromDictionary:(NSDictionary *)dict {
    NSLog(@"retrieved state dict: %@", dict);
    GORuleStateObject *ruleState = [[GORuleStateObject alloc] init];
    ruleState._id = [[dict objectForKey:@"id"] intValue];
    ruleState.name = [dict objectForKey:@"name"];
    
    if ([dict objectForKey:@"conditions"]) {
        ruleState.conditions = [self parseRuleConditionAssociationObjectArrayAsConditionsFromDictionary:[dict objectForKey:@"conditions"] ruleOperatorBlock:^(GORuleOperator ruleOperator) {
            NSLog(@"RuleOperator set (state): %@", [GORuleConditionAssociationObject getApiStringForRuleOperator:ruleOperator]);
            ruleState.ruleOperator = ruleOperator;
        }];
    }
    
    return ruleState;
}

+ (NSData *)parseJSONDataFromRuleStateObject:(GORuleStateObject *)ruleStateObject {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:ruleStateObject.name forKey:@"name"];
    NSMutableDictionary *assocDict = [[NSMutableDictionary alloc] init];
    for (GORuleConditionAssociationObject *assoc in ruleStateObject.conditions) {
        NSDictionary *resource = @{@"id": @(assoc.resource._id),
                                   @"value": @(assoc.resource.value)};
        NSMutableArray *resourceArray;
        NSString *keyOperatorString = [GORuleConditionAssociationObject getApiStringForRuleOperator:assoc.ruleOperator];
        if ([assocDict objectForKey:keyOperatorString]) {
            resourceArray = [assocDict objectForKey:keyOperatorString];
        }
        else {
            resourceArray = [[NSMutableArray alloc] init];
            [assocDict setObject:resourceArray forKey:keyOperatorString];
        }
        [resourceArray addObject:resource];
       // NSDictionary *assocDict = @{[GORuleConditionAssociationObject getApiStringForRuleOperator:assoc.ruleOperator]: resourceArray};
    }
    
    if (ruleStateObject.ruleOperator == GORuleOperatorAny || ruleStateObject.ruleOperator == GORuleOperatorNone) {
        [dataDict setObject:@{[GORuleConditionAssociationObject getApiStringForRuleOperator:ruleStateObject.ruleOperator]: assocDict} forKey:@"conditions"];
    }
    else {
        [dataDict setObject:assocDict forKey:@"conditions"];
    }
    
    
    NSLog(@"parsed STATE: %@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    return [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - Rule Condition Associations

+ (NSMutableArray *)parseRuleConditionAssociationObjectArrayAsConditionsFromDictionary:(NSDictionary *)conditionDict ruleOperatorBlock:(ruleOperatorCompletion)completion {
    NSMutableArray *conditions = [[NSMutableArray alloc] init];
    if (conditionDict) {
        for (NSString *key in conditionDict) {
            if ([key isEqualToString:@"states"]) {
                NSMutableArray *states = [self parseObjectArrayFromJSONData:[conditionDict objectForKey:key] forIdentifier:GOParseRuleStateObjectArray];
                [conditions addObjectsFromArray:states];
            }
            else if ([key isEqualToString:@"any"] || [key isEqualToString:@"none"]) {
                completion([GORuleConditionAssociationObject getRuleOperatorFromApiString:key]);
                for (NSDictionary *anyNoneDict in [conditionDict objectForKey:key]) {
                    NSMutableDictionary *subConditionsDict = [anyNoneDict objectForKey:@"conditions"];
                    [conditions addObjectsFromArray:[self parseRuleConditionAssociationObjectArrayAsConditionsFromDictionary:subConditionsDict ruleOperatorBlock:nil]];
                }
            }
            else {
                NSLog(@"gor rule operatr");
                //completion(GORuleOperatorAll);
                
                for (NSDictionary *ruleResourceDict in [conditionDict objectForKey:key]) {
                    GORuleOperator operator = [GORuleConditionAssociationObject getRuleOperatorFromApiString:key];
                    GORuleConditionAssociationObject *condition = [self parseRuleConditionAssociationObjectFromDictionary:ruleResourceDict];
                    condition.ruleOperator = operator;
                    [conditions addObject:condition];
                }
            }
        }
    }
    return conditions;
}

+ (GORuleConditionAssociationObject *)parseRuleConditionAssociationObjectFromDictionary:(NSDictionary *)dict {
    NSLog(@"retrieved RUle ASSoc for parsing: %@", dict);
    GORuleConditionAssociationObject *association = [[GORuleConditionAssociationObject alloc] init];    
    association.resource = [self parseResourceObjectFromDictionary:dict];

    //TODO: vervollständigen
    return association;
}

+ (NSData *)parseJSONDataFromRuleConditionAssociationObject:(GORuleConditionAssociationObject *)ruleStateObject {
    NSDictionary *dataDict = @{};
    
    return [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - Measurements

+ (GOMeasurementObject *)parseMeasurementObjectFromDictionary:(NSDictionary *)dict {
    GOMeasurementObject *measurement = [[GOMeasurementObject alloc] init];

    measurement.date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"datetime"] doubleValue]];
    measurement.value = [[dict objectForKey:@"value"] isKindOfClass:[NSNull class]] ? 0.0 : [[dict objectForKey:@"value"] floatValue];
    return measurement;
}

#pragma mark - Notifications

+ (GONotificationObject *)parseNotificationObjectFromDictionary:(NSDictionary *)dict {
    GONotificationObject *notification = [[GONotificationObject alloc] init];
    notification._id = [[dict objectForKey:@"id"] intValue];
    notification.text = [dict objectForKey:@"text"];
    
    return notification;
}

#pragma mark - Parse Object-Arrays

+ (NSMutableArray *)parseObjectArrayFromJSONData:(id)data forIdentifier:(GOParseArrayIdentifier)identifier {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSArray *array = [data isKindOfClass:[NSData class]] ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : data;

    NSLog(@"Received array with data: %@", array);
    SEL chosenSelector;
    switch (identifier) {
        case GOParseDeviceObjectArray:
            chosenSelector = @selector(parseDeviceObjectFromDictionary:);
            break;
        case GOParseGroupObjectArray:
            chosenSelector = @selector(parseGroupObjectFromDictionary:);
            break;
        case GOParseUserObjectArray:
            chosenSelector = @selector(parseUserObjectFromDictionary:);
            break;
        case GOParseResourceObjectArray:
            chosenSelector = @selector(parseResourceObjectFromDictionary:);
            break;
        case GOParseRuleObjectArray:
            chosenSelector = @selector(parseRuleObjectFromDictionary:);
            break;
        case GOParseRuleStateObjectArray:
            chosenSelector = @selector(parseRuleStateObjectFromDictionary:);
            break;
        case GOParseRuleConditionAssociationObjectArray:
            chosenSelector = @selector(parseRuleConditionAssociationObjectFromDictionary:);
            break;
        case GOParseMeasurementObjectArray:
            chosenSelector = @selector(parseMeasurementObjectFromDictionary:);
            break;
        case GOParseNotificationObjectArray:
            chosenSelector = @selector(parseNotificationObjectFromDictionary:);
            break;
        default:
            break;
    }
    
    for (id object in array) {
        [results addObject:[self performSelector:chosenSelector withObject:object]];
    }
    
    return results;
}

@end
