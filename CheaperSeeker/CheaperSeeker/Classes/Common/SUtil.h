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

+ (void)setNavigationBarSplitButtonItemWith:(UIViewController *)viewController;
+ (void)splitActionWith:(UIViewController<SSplitControllerProtocol> *)viewController;

@end
