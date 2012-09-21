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
#import "SWebViewController.h"

@implementation SUtil

+ (NSString *)currentDocumentCacheStoragePath {
    return nil;
}
+ (NSString *)currentImageCacheStoragePath {
    return nil;
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

+ (BOOL)isCouponExpire:(id)coupon {
    BOOL result = NO;
    NSDate *_expire = [NSDate dateWithTimeIntervalSince1970:[[coupon objectForKey:k_coupon_expire_to] doubleValue]];
    NSDate *_now = [NSDate date];
    if ([_expire compare:_now] == NSOrderedAscending) {
        result = YES;
    }
    return result;
}
+ (NSString *)couponExpireDescription:(id)expire {
    return nil;
}

+ (void)showCouponTargetLinkWithCoupon:(id)coupon ViewController:(UIViewController *)viewController {
    SWebViewController *_web = [[SWebViewController alloc] initWithURLPath:[coupon objectForKey:k_coupon_target_link]];
    [viewController.navigationController pushViewController:_web animated:YES];
    [_web release];
}

@end
