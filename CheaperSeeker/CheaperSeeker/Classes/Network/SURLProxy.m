//
//  SURLProxy.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SURLProxy.h"

@interface SURLProxy()
+ (NSString *)prepareURL:(NSString *)url;
@end
@implementation SURLProxy

+ (NSString *)prepareURL:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@%@", k_base_url, k_base_url_version, url];
}
//  已验证
+ (NSString *)getHomeCouponsWithCursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/getHomeCoupons?size=%d&cursor=%@", count, cursor];
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)searchCouponsWithKey:(NSString *)key Cursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = nil;
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)searchCouponsIDsInPoolWithKey:(NSString *)key Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/searchCoupon/?word=%@&size=%d", key, count];
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)searchCouponsInPoolThroughIDs {
    NSString *url = @"coupon/getCoupons";
    url = [SURLProxy prepareURL:url];
    return url;
}
//  已验证，但不接受参数
+ (NSString *)getCategoriesWithCursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = @"category/getCategories";
    url = [SURLProxy prepareURL:url];
    return url;
}
//  已验证
+ (NSString *)getCommonMerchantsWithCursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/getCommonMerchants?size=%d&cursor=%@", count, cursor];
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)getFeaturedMerchantsWithCursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/getFeaturedMerchants?size=%d&cursor=%@", count, cursor];
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)getCouponWithCouponID:(NSString *)cid {
    NSString *url = nil;
    url = [SURLProxy prepareURL:url];
    return url;
}
//  已验证
+ (NSString *)getMerchantWithMerchantID:(NSString *)mid {
    NSString *url = [NSString stringWithFormat:@"coupon/getMerchant?id=%@", mid];
    url = [SURLProxy prepareURL:url];
    return url;
}
//  已验证 
+ (NSString *)getMerchantCommonCouponsWithMerchantID:(NSString *)mid Cursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/getMerchantCommonCoupons?id=%@&cursor=%@&size=%d", mid, cursor, count];
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)getMerchantFeaturedCouponsWithMerchantID:(NSString *)mid Cursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/getMerchantFeaturedCoupons?id=%@&cursor=%@&size=%d", mid, cursor, count];
    url = [SURLProxy prepareURL:url];
    return url;
}
//  已验证
+ (NSString *)getCategoryCouponsWithCategoryID:(NSString *)cid Cursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/getCategoryCoupons?id=%@&cursor=%@&size=%d", cid, cursor, count];
    url = [SURLProxy prepareURL:url];
    return url;
}

+ (NSString *)getAboutInfo {
    NSString *url = @"about";
    url = [SURLProxy prepareURL:url];
    return url;
}

+ (NSString *)postEmailAddress {
    NSString *url = @"user/addEmail";
    url = [SURLProxy prepareURL:url];
    return url;
}

@end
