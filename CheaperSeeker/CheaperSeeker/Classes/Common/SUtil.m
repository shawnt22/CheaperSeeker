//
//  SUtil.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SUtil.h"
#import "SConfiger.h"
#import "AppDelegate.h"
#import "SSplitContentDelegate.h"
#import "SCouponWebViewController.h"
#import "SEmailMeLaterViewController.h"
#import "TCustomBGCell.h"

@implementation SUtil

+ (NSString *)currentDocumentCacheStoragePath {
    return nil;
}
+ (NSString *)currentImageCacheStoragePath {
    return nil;
}
+ (NSString *)commonFilePath {
    return [Util filePathWith:@"common" isDirectory:YES];
}
+ (NSString *)commonDocFilePath {
    return [Util filePathWith:@"common/doc" isDirectory:YES];
}

+ (void)setNavigationBarSplitButtonItemWith:(UIViewController *)viewController {
    UIBarButtonItem *_splitItem = [[UIBarButtonItem alloc] initWithTitle:kNavigationBarSplitItemTitle style:UIBarButtonItemStylePlain target:viewController action:@selector(splitAction:)];
    viewController.navigationItem.leftBarButtonItem = _splitItem;
    [_splitItem release];
}
+ (void)splitActionWith:(UIViewController<SSplitControllerProtocol> *)viewController {
    switch ([AppDelegate shareSplitRootViewController].contentBoard.status) {
        case SSplitContentViewStatusCover:
            [[AppDelegate shareSplitRootViewController] splitContentViewController:viewController Animated:YES];
            break;
        case SSplitContentViewStatusSplit:
            [[AppDelegate shareSplitRootViewController] coverContentViewController:viewController Animated:YES];
            break;
        default:
            break;
    }
}


+ (NSError *)errorWithCode:(NSInteger)code {
    return [SUtil errorWithCode:code Message:nil];
}
+ (NSError *)errorWithCode:(NSInteger)code Message:(NSString *)message {
    NSError *error = nil;
    if ([Util isEmptyString:message]) {
        switch (code) {
            case SErrorResponseParserFail:
                message = @"Parse Response Fail";
                break;
            default:
                message = @"Something Wrong";
                break;
        }
    }
    error = [NSError errorWithDomain:kErrorDomain code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, nil]];
    return error;
}

+ (CGFloat)cellWidth {
    return 320.0;
}

+ (void)showCouponTargetLinkWithCoupon:(id)coupon ViewController:(UIViewController *)viewController {
    SCouponWebViewController *_web = [[SCouponWebViewController alloc] initWithURLPath:[coupon objectForKey:k_coupon_target_link]];
    _web.coupon = coupon;
    [viewController.navigationController pushViewController:_web animated:YES];
    [_web release];
}
+ (void)emailMeLaterWithCoupon:(id)coupon ViewController:(UIViewController<SEmailMeLaterViewControllerDelegate> *)viewController {
    SEmailMeLaterViewController *_eml = [[SEmailMeLaterViewController alloc] initWithCoupon:coupon];
    _eml.controllerDelegate = viewController;
    [viewController.navigationController pushViewController:_eml animated:YES];
    [_eml release];
}

+ (NSString *)bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
+ (BOOL)isCurrentVersionLowerThanVersion:(NSString *)version {
    BOOL result = NO;
    if ([version floatValue] > [[SUtil bundleVersion] floatValue]) {
        result = YES;
    }
    return result;
}

+ (void)openAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
}

+ (void)setCustomCellBGView:(UITableViewCell *)cell {
    TCustomCellBGView *_bg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
    _bg.lineColor = kCustomCellBGLineColor;
    _bg.fillColor = kCustomCellBGFillColor;
    _bg.innerShadowColor = kCustomCellBGInnerShadowColor;
    _bg.innerShadowWidth = 1.0;
    _bg.dropShadowColor = kCustomCellBGDropShadowColor;
    _bg.dropShadowWidth = 1.0;
    cell.backgroundView = _bg;
    [_bg release];
    TCustomCellBGView *_sbg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
    _sbg.lineColor = kCustomCellSelectedBGLineColor;
    _sbg.fillColor = kCustomCellSelectedBGFillColor;
    cell.selectedBackgroundView = _sbg;
    [_sbg release];
}
+ (BOOL)needShowExpireDescriptionWithCoupon:(id)coupon {
    if ([SUtil stateWithCoupon:coupon] > CouponDateBefore) {
        NSTimeInterval _interval = [[coupon objectForKey:k_coupon_expire_to] doubleValue];
        NSDate *_date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSTimeInterval _delta = [_date timeIntervalSinceNow];
        if (_delta > S_MONTH * 10) {
            return NO;
        }
        return YES;
    }
    return NO;
}

@end


@implementation SUtil (CouponType)
+ (BOOL)hasCouponCode:(id)coupon {
    return [Util isEmptyString:[coupon objectForKey:k_coupon_code]] ? NO : YES;
}
+ (CouponType)couponType:(id)coupon {
    return [SUtil hasCouponCode:coupon] ? CouponCode : CouponSale;
}
+ (NSString *)descriptionWithCouponType:(CouponType)type {
    NSString *_desc = nil;
    switch (type) {
        case CouponCode:
            _desc = k_text_coupon_type_code;
            break;
        default:
            _desc = k_text_coupon_type_sale;
            break;
    }
    return _desc;
}
@end


@implementation SUtil (DateFormate)

+ (CouponDateState)stateWithCoupon:(id)coupon {
    CouponDateState _state = CouponDateBefore;
    
    NSTimeInterval _to_interval = [[coupon objectForKey:k_coupon_expire_to] doubleValue];
    NSTimeInterval _from_interval = [[coupon objectForKey:k_coupon_expire_from] doubleValue];
    NSDate *_to_date = [NSDate dateWithTimeIntervalSince1970:_to_interval];
    NSDate *_from_date = [NSDate dateWithTimeIntervalSince1970:_from_interval];
    NSDate *_now_date = [NSDate date];
    
    if ([_to_date compare:_now_date] == NSOrderedAscending) {
        //  过期
        _state = CouponDateAfter;
    }else if ([_from_date compare:_now_date] == NSOrderedAscending) {
        //  期限中
        _state = CouponDateIn;
    }
    
    return _state;
}
+ (BOOL)isCouponExpire:(id)coupon {
    return [SUtil stateWithCoupon:coupon] == CouponDateAfter ? YES : NO;
}
+ (NSString *)couponExpireDescription:(id)coupon {
    NSString *_result = nil;
    
    NSTimeInterval _to_interval = [[coupon objectForKey:k_coupon_expire_to] doubleValue];
    NSTimeInterval _from_interval = [[coupon objectForKey:k_coupon_expire_from] doubleValue];
    NSDate *_to_date = [NSDate dateWithTimeIntervalSince1970:_to_interval];
    NSDate *_from_date = [NSDate dateWithTimeIntervalSince1970:_from_interval];
    
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    NSLocale *_locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    _formatter.locale = _locale;
    _formatter.dateFormat = @"MMM dd";
    
    switch ([SUtil stateWithCoupon:coupon]) {
        case CouponDateAfter:
        {
            _result = k_text_coupon_date_description_expired;
        }
            break;
        case CouponDateBefore:
        {
            _result = [NSString stringWithFormat:@"%@ - %@", [_formatter stringFromDate:_from_date], [_formatter stringFromDate:_to_date]];
        }
            break;
        default:
        {
            _result = [NSString stringWithFormat:@"%@ %@", k_text_coupon_date_nature_description, [SUtil natureDescriptionWithDate:_to_date]];
        }
            break;
    }
    
    [_locale release];
    [_formatter release];
    
    return _result;
}
+ (NSString *)natureDescriptionWithDate:(NSDate *)date {
    NSString *_result = @"";
    NSInteger _number = 0;
    NSTimeInterval _delta = [date timeIntervalSinceNow];
    if (_delta > S_MONTH * 10) {
        _result = k_text_coupon_date_nature_description_too_long;
    } else if (_delta > S_MONTH) {
        _number = _delta / S_MONTH + 1;
        _result = [NSString stringWithFormat:@"%d %@", _number, k_text_coupon_date_nature_description_months];
    } else if (_delta > S_WEEK) {
        _number = _delta / S_WEEK + 1;
        _result = [NSString stringWithFormat:@"%d %@", _number, k_text_coupon_date_nature_description_weeks];
    } else if (_delta > S_DAY) {
        _number = _delta / S_DAY + 1;
        _result = [NSString stringWithFormat:@"%d %@", _number, k_text_coupon_date_nature_description_days];
    } else if (_delta > S_HOUR) {
        _number = _delta / S_HOUR + 1;
        _result = [NSString stringWithFormat:@"%d %@", _number, k_text_coupon_date_nature_description_hours];
    } else {
        _result = k_text_coupon_date_nature_description_too_short;
    }
    return _result;
}

@end



