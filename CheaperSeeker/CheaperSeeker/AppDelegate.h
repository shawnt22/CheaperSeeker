//
//  AppDelegate.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHomeViewController.h"
#import "SStoresViewController.h"
#import "SCategoriesViewController.h"
#import "SAboutViewController.h"
#import "SSplitContentDelegate.h"
#import "SSplitRootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) SHomeViewController *homeViewController;
@property (nonatomic, retain) SStoresViewController *storesViewController;
@property (nonatomic, retain) SCategoriesViewController *categoriesViewController;
@property (nonatomic, retain) SAboutViewController *aboutViewController;
@property (nonatomic, retain) SSplitRootViewController *splitRootViewController;

+ (AppDelegate *)shareAppDelegate;
+ (SHomeViewController *)shareHomeViewController;
+ (SStoresViewController *)shareStoresViewController;
+ (SCategoriesViewController *)shareCategoriesViewController;
+ (SAboutViewController *)shareAboutViewController;
+ (SSplitRootViewController *)shareSplitRootViewController;

@end
