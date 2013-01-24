//
//  SURLProxy.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>

#define k_base_url  @"http://www.cheaperseeker.com/mo/api/"
#define k_base_url_version  @"v1/"

typedef enum {
    SURLRequestInvalid,
    
    SURLRequestItemsRefresh,
    SURLRequestItemsLoadmore,
    
    SURLRequestAboutInfo,
    SURLRequestPostEmail,
    
}SURLRequestTag;

@interface SURLProxy : NSObject

+ (NSString *)getHomeCouponsWithCursor:(NSString *)cursor Count:(NSInteger)count;

+ (NSString *)searchCouponsWithKey:(NSString *)key Cursor:(NSString *)cursor Count:(NSInteger)count;
+ (NSString *)searchCouponsIDsInPoolWithKey:(NSString *)key Count:(NSInteger)count;
+ (NSString *)searchCouponsInPoolThroughIDs;

+ (NSString *)getCategoriesWithCursor:(NSString *)cursor Count:(NSInteger)count;

+ (NSString *)getCommonMerchantsWithCursor:(NSString *)cursor Count:(NSInteger)count;
+ (NSString *)getFeaturedMerchantsWithCursor:(NSString *)cursor Count:(NSInteger)count;
+ (NSString *)getCouponWithCouponID:(NSString *)cid;
+ (NSString *)getMerchantWithMerchantID:(NSString *)mid;

+ (NSString *)getMerchantCommonCouponsWithMerchantID:(NSString *)mid Cursor:(NSString *)cursor Count:(NSInteger)count;
+ (NSString *)getMerchantFeaturedCouponsWithMerchantID:(NSString *)mid Cursor:(NSString *)cursor Count:(NSInteger)count;
+ (NSString *)getCategoryCouponsWithCategoryID:(NSString *)cid Cursor:(NSString *)cursor Count:(NSInteger)count;

+ (NSString *)getAboutInfo;
+ (NSString *)postEmailAddress;

@end
