//
//  GORuleObject.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 20.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GORuleConditionAssociationObject.h"

@interface GORuleObject : NSObject

@property (nonatomic) uint _id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) GORuleOperator ruleOperator;

@property (nonatomic) NSMutableArray *conditions;
@property (nonatomic) NSMutableArray *actions;

@end
