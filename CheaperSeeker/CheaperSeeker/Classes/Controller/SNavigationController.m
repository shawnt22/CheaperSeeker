//
//  SNavigationController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SNavigationController.h"

@implementation SNavigationController
@synthesize splitViewController, splitNavigationController;

- (UINavigationController<SSplitControllerProtocol> *)splitNavigationController {
    return self;
}
- (UIViewController<SSplitControllerProtocol> *)splitViewController {
    return [SSplitContentUtil splitViewControllerWithSplitNavigationController:self];
}

@end
