//
//  GORuleResourceAssociationObject.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.03.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOResourceObject.h"

typedef NS_ENUM(NSInteger, GORuleOperator) {
    GORuleOperatorNoOperatorAvailable = -1,
    GORuleOperatorAll,
    GORuleOperatorAny,
    GORuleOperatorNone,
    GORuleOperatorEqual,
    GORuleOperatorUnequal,
    GORuleOperatorGreater,
    GORuleOperatorLess,
    GORuleOperatorState
};

@interface GORuleConditionAssociationObject : NSObject

@property (nonatomic) uint _id;
@property (nonatomic) GOResourceObject *resource;
@property (nonatomic) GORuleOperator ruleOperator;

+ (NSString *)getStringForRuleOperator:(GORuleOperator)ruleOperator longVersion:(BOOL)longVersion;
+ (NSString *)getApiStringForRuleOperator:(GORuleOperator)ruleOperator;
+ (GORuleOperator)getRuleOperatorFromApiString:(NSString *)string;

@end
