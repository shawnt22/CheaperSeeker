//
//  SViewController.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SConfiger.h"
#import "Util.h"
#import "SUtil.h"
#import "SSplitContentDelegate.h"
#import "MBProgressHUD.h"

@interface SViewController : UIViewController<SSplitControllerProtocol, MBProgressHUDDelegate>
@property (nonatomic, retain) MBProgressHUD *messageHUD;

- (void)initSubobjects;

- (void)showMessageHUD:(NSString *)message Animated:(BOOL)animated;
- (void)hideMessageHUD:(BOOL)animated;

@end
