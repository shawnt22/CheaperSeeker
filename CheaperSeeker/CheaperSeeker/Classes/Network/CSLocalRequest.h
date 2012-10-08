//
//  CSLocalRequest.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDefine.h"

@interface CSLocalRequest : NSObject

+ (NSString *)couponsJSONString;
+ (NSString *)merchantsJSONString;
+ (NSString *)categoriesJSONString;

@end
