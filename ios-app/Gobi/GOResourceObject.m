//
//  GOResourceObject.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.03.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOResourceObject.h"

@implementation GOResourceObject

+ (GOResourceType)getResourceTypeFromString:(NSString *)resourceString {
    if ([resourceString isEqualToString:@"dev.info"]) {
        return GOResourceTypeDevInfo;
    }
    else if ([resourceString isEqualToString:@"gobi.a.swt"]) {
        return GOResourceTypeActuatorSwitch;
    }
    else if ([resourceString isEqualToString:@"gobi.s.swt"]) {
        return GOResourceTypeSensorSwitch;
    }
    else if ([resourceString isEqualToString:@"gobi.s.pow"]) {
        return GOResourceTypeSensorPower;
    }
    else if ([resourceString isEqualToString:@"gobi.s.tmp"]) {
        return GOResourceTypeSensorTemperature;
    }
    else if ([resourceString isEqualToString:@"gobi.a.light.swt"]) {
        return GOResourceTypeActuatorLightSwitch;
    }
    else if ([resourceString isEqualToString:@"gobi.a.light.dim"]) {
        return GOResourceTypeActuatorLightDimmer;
    }
    else if ([resourceString isEqualToString:@"gobi.a.light.rgb"]) {
        return GOResourceTypeActuatorLightRGB;
    }
    else if ([resourceString isEqualToString:@"gobi.s.lux"]) {
        return GOResourceTypeSensorLux;
    }
    else {
        return GOResourceTypeSensorHumidity;
    }
}

+ (GOCoreType)getCoreTypeFromString:(NSString *)coreString {
    if ([coreString isEqualToString:@"core.s"]) {
        return GOCoreTypeSensor;
    }
    else if ([coreString isEqualToString:@"core.a"]) {
        return GOCoreTypeActuator;
    }
    return 0;
}

+ (NSString *)getDescriptionStringForResourceType:(GOResourceType)resourceType {
    switch (resourceType) {
        case GOResourceTypeDevInfo:
            return @"Geräte-Info";
        case GOResourceTypeActuatorSwitch:
            return @"Aktuator: Schalter";
        case GOResourceTypeSensorPower:
            return @"Sensor: Energie";
        case GOResourceTypeSensorTemperature:
            return @"Sensor: Temperatur";
        case GOResourceTypeActuatorLightSwitch:
            return @"Aktuator: Lichtschalter";
        case GOResourceTypeActuatorLightRGB:
            return @"Aktuator: RGB-Licht";
        case GOResourceTypeSensorHumidity:
            return @"Sensor: Luftfeuchtigkeit";
        case GOResourceTypeSensorSwitch:
            return @"Sensor: Impuls-Schalter";
        case GOResourceTypeSensorLux:
            return @"Sensor: Helligkeit";
        default:
            return @"Aktuator: Licht-Dimmer";
    }
}

+ (NSString *)getUnitStringForAPIString:(NSString *)apiString {
    if ([apiString isEqualToString:@"Cel"]) {
        return @"C°";
    }
    else if ([apiString isEqualToString:@"Fah"]) {
        return @"F°";
    }
    return apiString;
}

@end
