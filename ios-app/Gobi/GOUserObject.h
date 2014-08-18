//
//  GOUserObject.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 28.11.13.
//  Copyright (c) 2013 Gobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOUserObject : NSObject

@property (nonatomic) uint _id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *email;
@property (nonatomic) uint accessRights;

@end
