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

@implementation SUtil

+ (NSString *)currentDocumentCacheStoragePath {
    return nil;
}
+ (NSString *)currentImageCacheStoragePath {
    return nil;
}

+ (void)setNavigationBarSplitButtonItemWith:(UIViewController *)viewController {
    UIButton *split = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [split setBackgroundColor:[UIColor blueColor]];
    [split setTitle:@"split" forState:UIControlStateNormal];
    [split addTarget:viewController action:@selector(splitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *splitItem = [[UIBarButtonItem alloc] initWithCustomView:split];
    [split release];
    viewController.navigationItem.leftBarButtonItem = splitItem;
    [splitItem release];
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

@end
