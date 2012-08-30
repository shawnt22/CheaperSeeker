//
//  SSplitContentDelegate.m
//  SSplitControllerDemo
//
//  Created by 滕 松 on 12-8-17.
//  Copyright (c) 2012年 滕 松. All rights reserved.
//

#import "SSplitContentDelegate.h"

@implementation SSplitContentUtil


+ (UIViewController<SSplitControllerProtocol> *)splitViewControllerWithSplitNavigationController:(UINavigationController<SSplitControllerProtocol> *)nctr {
    if ([nctr.viewControllers count] > 0) {
        UIViewController *_root = [nctr.viewControllers objectAtIndex:0];
        if ([_root conformsToProtocol:@protocol(SSplitControllerProtocol)]) {
            return (UIViewController<SSplitControllerProtocol> *)_root;
        }
    }
    return nil;
}
+ (UINavigationController<SSplitControllerProtocol> *)splitNavigationControllerWithSplitViewController:(UIViewController<SSplitControllerProtocol> *)vctr {
    UINavigationController *snctr = vctr.navigationController;
    if ([snctr conformsToProtocol:@protocol(SSplitControllerProtocol)]) {
        return (UINavigationController<SSplitControllerProtocol> *)snctr;
    } else {
        return nil;
    }
}

@end
