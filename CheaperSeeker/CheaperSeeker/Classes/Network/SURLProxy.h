//
//  SURLProxy.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>

#define k_base_url  @"http://www.cheaperseeker.com/mo/api/"

typedef enum {
    SURLRequestInvalid,
    
    SURLRequestItemsRefresh,
    SURLRequestItemsLoadmore,
    
}SURLRequestTag;

@interface SURLProxy : NSObject

+ (NSString *)getHomeCouponsWithCursor:(NSString *)cursor Count:(NSInteger)count;
+ (NSString *)searchCouponsWithKey:(NSString *)key Cursor:(NSString *)cursor Count:(NSInteger)count;

+ (NSString *)getCategoriesWithCursor:(NSString *)cursor Count:(NSInteger)count;

+ (NSString *)getMerchantsWithCursor:(NSString *)cursor Count:(NSInteger)count;
+ (NSString *)getCouponWithCouponID:(NSString *)cid;
+ (NSString *)getMerchantWithMerchantID:(NSString *)mid;

@end
