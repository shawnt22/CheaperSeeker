//
//  SDataManager.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SConfiger.h"

@interface SDataManager : NSObject
@property (nonatomic, assign) id currentUser;

+ (SDataManager *)shareDataManager;

- (void)prepareBeforeLogin;
- (void)prepareAfterLogin;
- (BOOL)isLogin;

@end
