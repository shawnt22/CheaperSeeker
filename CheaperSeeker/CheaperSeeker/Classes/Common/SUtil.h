//
//  SUtil.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSplitContentDelegate.h"

@interface SUtil : NSObject

+ (NSString *)currentDocumentCacheStoragePath;
+ (NSString *)currentImageCacheStoragePath;
+ (NSString *)commonFilePath;
+ (NSString *)commonDocFilePath;

+ (void)setNavigationBarSplitButtonItemWith:(UIViewController *)viewController;
+ (void)splitActionWith:(UIViewController<SSplitControllerProtocol> *)viewController;

+ (NSError *)errorWithCode:(NSInteger)code;
+ (NSError *)errorWithCode:(NSInteger)code Message:(NSString *)message;

+ (CGFloat)cellWidth;

+ (void)showCouponTargetLinkWithCoupon:(id)coupon ViewController:(UIViewController *)viewController;
+ (void)emailMeLaterWithCoupon:(id)coupon ViewController:(UIViewController *)viewController;

+ (NSString *)bundleVersion;
+ (BOOL)isCurrentVersionLowerThanVersion:(NSString *)version;

+ (void)openAppStore;
+ (void)setCustomCellBGView:(UITableViewCell *)cell;
+ (BOOL)needShowExpireDescriptionWithCoupon:(id)coupon;

@end

typedef enum {
    CouponSale,         //  deal
    CouponCode,         //  coupon
}CouponType;

@interface SUtil (CouponType)
+ (BOOL)hasCouponCode:(id)coupon;
+ (CouponType)couponType:(id)coupon;
+ (NSString *)descriptionWithCouponType:(CouponType)type;
@end

typedef enum {
    CouponDateBefore,           //  期限前 expire_from > now
    CouponDateIn,               //  期限中 expire_from < now < expire_to
    CouponDateAfter,            //  期限后，过期  expire_to < now
}CouponDateState;
@interface SUtil (DateFormate)

+ (CouponDateState)stateWithCoupon:(id)coupon;
+ (BOOL)isCouponExpire:(id)coupon;
+ (NSString *)couponExpireDescription:(id)coupon;
+ (NSString *)natureDescriptionWithDate:(NSDate *)date;

@end
