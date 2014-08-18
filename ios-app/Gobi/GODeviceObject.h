//
//  GODeviceObject.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 21.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GODeviceObject : NSObject

@property (nonatomic) uint _id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *description;
@property (nonatomic) NSMutableArray *resources;

@property (nonatomic) BOOL unfolded;

@end
