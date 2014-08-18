//
//  GOGroupObject.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 20.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOGroupObject : NSObject

@property (nonatomic) uint _id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSMutableArray *resources;
@property (nonatomic) NSMutableArray *rules;

@property (nonatomic) BOOL unfolded;

@end
