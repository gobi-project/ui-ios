//
//  GOResourceObject.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.03.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GOResourceType) {
    GOResourceTypeDevInfo,
    GOResourceTypeActuatorSwitch,
    GOResourceTypeSensorSwitch,
    GOResourceTypeSensorPower,
    GOResourceTypeSensorTemperature,
    GOResourceTypeActuatorLightSwitch,
    GOResourceTypeActuatorLightDimmer,
    GOResourceTypeActuatorLightRGB,
    GOResourceTypeSensorHumidity,
    GOResourceTypeSensorLux
};


typedef NS_ENUM(NSInteger, GOCoreType) {
    GOCoreTypeActuator,
    GOCoreTypeSensor
};

@interface GOResourceObject : NSObject
@property (nonatomic) uint _id;
@property (nonatomic) uint deviceId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) float value;
@property (nonatomic) GOResourceType resourceType;
@property (nonatomic) GOCoreType coreType;
@property (nonatomic) NSString *unit;

+ (GOResourceType)getResourceTypeFromString:(NSString *)resourceString;
+ (NSString *)getDescriptionStringForResourceType:(GOResourceType)resourceType;
+ (GOCoreType)getCoreTypeFromString:(NSString *)coreString;
+ (NSString *)getUnitStringForAPIString:(NSString *)apiString;
@end
