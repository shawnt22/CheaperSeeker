//
//  AppDelegate.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "AppDelegate.h"
#import "SNavigationController.h"

@interface AppDelegate()
- (void)launchControllers;
@end
@implementation AppDelegate
@synthesize homeViewController, storesViewController, categoriesViewController, aboutViewController, splitRootViewController;

- (void)dealloc {
    self.homeViewController = nil;
    self.categoriesViewController = nil;
    self.storesViewController = nil;
    self.aboutViewController = nil;
    self.splitRootViewController = nil;
    
    [_window release];
    [super dealloc];
}

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
+ (SHomeViewController *)shareHomeViewController {
    return [AppDelegate shareAppDelegate].homeViewController;
}
+ (SStoresViewController *)shareStoresViewController {
    return [AppDelegate shareAppDelegate].storesViewController;
}
+ (SCategoriesViewController *)shareCategoriesViewController {
    return [AppDelegate shareAppDelegate].categoriesViewController;
}
+ (SAboutViewController *)shareAboutViewController {
    return [AppDelegate shareAppDelegate].aboutViewController;
}
+ (SSplitRootViewController *)shareSplitRootViewController {
    return [AppDelegate shareAppDelegate].splitRootViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self launchControllers];
    
    return YES;
}
- (void)launchControllers {
    SHomeViewController *_home = [[SHomeViewController alloc] init];
    SNavigationController *_nhome = [[SNavigationController alloc] initWithRootViewController:_home];
    [_home release];
    self.homeViewController = _home;
    [_home release];
    
    SStoresViewController *_store = [[SStoresViewController alloc] init];
    SNavigationController *_nstore = [[SNavigationController alloc] initWithRootViewController:_store];
    [_store release];
    self.storesViewController = _store;
    [_store release];
    
    SCategoriesViewController *_categories = [[SCategoriesViewController alloc] init];
    SNavigationController *_ncategories = [[SNavigationController alloc] initWithRootViewController:_categories];
    [_categories release];
    self.categoriesViewController = _categories;
    [_categories release];
    
    SAboutViewController *_about = [[SAboutViewController alloc] init];
    SNavigationController *_nabout = [[SNavigationController alloc] initWithRootViewController:_about];
    [_about release];
    self.aboutViewController = _about;
    [_about release];
    
    SSplitRootViewController *_split = [[SSplitRootViewController alloc] initWithFrame:self.window.bounds];
    _split.splitContentViewControllers = [NSArray arrayWithObjects:_nhome, _nstore, _ncategories, _nabout, nil];
    self.splitRootViewController = _split;
    [_split release];
    [self.window addSubview:self.splitRootViewController];
    
    [_nhome release];
    [_nstore release];
    [_ncategories release];
    [_nabout release];
    
    [self.splitRootViewController splitContentViewController:self.homeViewController Animated:NO];
    [self.splitRootViewController coverContentViewController:self.homeViewController Animated:YES];
}



- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
