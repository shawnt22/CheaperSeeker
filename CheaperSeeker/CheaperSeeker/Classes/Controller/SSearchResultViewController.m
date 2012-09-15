//
//  SSearchResultViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SSearchResultViewController.h"
#import "CSListDataStore.h"
#import "SWebViewController.h"

@interface SSearchCouponsViewController()
@property (nonatomic, assign) SCouponsTableView *couponsTableView;
@end

@implementation SSearchCouponsViewController
@synthesize keyword;
@synthesize couponsTableView;

#pragma mark init & dealloc
- (id)initWithKeyword:(NSString *)kw {
    self = [super init];
    if (self) {
        self.keyword = kw;
    }
    return self;
}
- (void)dealloc {
    self.keyword = nil;
    [super dealloc];
}

#pragma mark controller delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.keyword;
    
    SCouponsTableView *_ts = [[SCouponsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.couponsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.couponsTableView = _ts;
    [_ts release];
    
    CSSearchDataStore *_ds = [[CSSearchDataStore alloc] initWithDelegate:_ts];
    _ds.key = self.keyword;
    self.couponsTableView.couponsDataStore = _ds;
    [_ds release];
    
    [self.couponsTableView startPullToRefreshWithAnimated:YES];
}

#pragma mark CouponsTableView Delegate
- (void)couponsTableView:(SCouponsTableView *)couponsTableView didSelectCoupon:(id)coupon atIndexPath:(NSIndexPath *)indexPath {
    [SUtil showCouponTargetLinkWithCoupon:coupon ViewController:self];
}

@end