//
//  GORuleResourceAssociationObject.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.03.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GORuleConditionAssociationObject.h"

@implementation GORuleConditionAssociationObject

+ (NSString *)getStringForRuleOperator:(GORuleOperator)ruleOperator longVersion:(BOOL)longVersion {
    switch (ruleOperator) {
        case GORuleOperatorNone:
            return longVersion ? @"Keine" : @"/";
        case GORuleOperatorAny:
            return longVersion ? @"Welche" : @"?";
        case GORuleOperatorGreater:
            return longVersion ? @"Greater" : @">";
        case GORuleOperatorLess:
            return longVersion ? @"Less" : @"<";
        case GORuleOperatorEqual:
            return longVersion ? @"Equal" : @"==";
        case GORuleOperatorState:
            return longVersion ? @"State" : @"st";
        default:
            return longVersion ? @"Unequal" : @"!=";
    }
}

+ (NSString *)getApiStringForRuleOperator:(GORuleOperator)ruleOperator {
    switch (ruleOperator) {
        case GORuleOperatorNone:
            return @"none";
        case GORuleOperatorAny:
            return @"any";
        case GORuleOperatorGreater:
            return @"greater";
        case GORuleOperatorLess:
            return @"less";
        case GORuleOperatorEqual:
            return @"equal";
        case GORuleOperatorState:
            return @"state";
        default:
            return @"unequal";
    }
}

+ (GORuleOperator)getRuleOperatorFromApiString:(NSString *)string {
    if ([string isEqualToString:@"none"]) {
        return GORuleOperatorNone;
    }
    else if ([string isEqualToString:@"any"]) {
        return GORuleOperatorAny;
    }
    else if ([string isEqualToString:@"greater"]) {
        return GORuleOperatorGreater;
    }
    else if ([string isEqualToString:@"less"]) {
        return GORuleOperatorLess;
    }
    else if ([string isEqualToString:@"equal"]) {
        return GORuleOperatorEqual;
    }
    else if ([string isEqualToString:@"none"]) {
        return GORuleOperatorState;
    }
    else {
        return GORuleOperatorNoOperatorAvailable;
    }
}

@end
