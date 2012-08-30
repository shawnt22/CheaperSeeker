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
+ (NSString *)settingFilePath;
+ (id)resumeSetting;
- (BOOL)saveSetting;
@optional
- (BOOL)clearSetting;
- (void)resetSetting;
@end

@interface SSetting : NSObject<SSettingProtocol>

- (void)initSubobjects;

@end
