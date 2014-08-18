//
//  GORuleActionConditionObject.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 12.03.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GORuleConditionAssociationObject.h"

@interface GORuleStateObject : NSObject

@property (nonatomic) uint _id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) GORuleOperator ruleOperator;

@property (nonatomic) NSMutableArray *conditions;

@end
