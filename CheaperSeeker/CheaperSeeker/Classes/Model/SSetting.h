//
//  SSetting.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SConfiger.h"

#pragma mark - Base
@protocol SSettingProtocol <NSObject, NSCoding>
@required
+ (NSString *)filePath;
+ (id)resume;
- (BOOL)save;
@optional
- (BOOL)clear;
- (void)reset;
@end

@interface SSetting : NSObject<SSettingProtocol>
+ (id)shareSetting;
@end

#define k_usetting_email    @"email"
@interface SGSetting : SSetting
@property (nonatomic, retain) NSString *email;
@end
