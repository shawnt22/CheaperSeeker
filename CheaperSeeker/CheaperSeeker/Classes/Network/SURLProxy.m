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
    return [NSString stringWithFormat:@"%@%@", k_base_url, url];
}

+ (NSString *)getHomeCouponsWithCursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:@"coupon/getHomeCoupons/%@", @"20"];
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)searchCouponsWithKey:(NSString *)key Cursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = nil;
    url = [SURLProxy prepareURL:url];
    return url;
}

+ (NSString *)getCategoriesWithCursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = nil;
    url = [SURLProxy prepareURL:url];
    return url;
}

+ (NSString *)getMerchantsWithCursor:(NSString *)cursor Count:(NSInteger)count {
    NSString *url = @"";
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)getCouponWithCouponID:(NSString *)cid {
    NSString *url = nil;
    url = [SURLProxy prepareURL:url];
    return url;
}
+ (NSString *)getMerchantWithMerchantID:(NSString *)mid {
    NSString *url = nil;
    url = [SURLProxy prepareURL:url];
    return url;
}

@end
