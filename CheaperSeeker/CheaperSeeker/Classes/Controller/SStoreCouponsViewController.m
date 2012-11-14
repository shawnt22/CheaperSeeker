//
//  SStoreCouponsViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SStoreCouponsViewController.h"
#import "CSListDataStore.h"
#import "SWebViewController.h"

@interface SStoreCouponsViewController ()
@property (nonatomic, assign) SCouponsTableView *couponsTableView;
@end

@implementation SStoreCouponsViewController
@synthesize couponsTableView;
@synthesize store;

#pragma mark init & dealloc
- (id)initWithStore:(id)stre {
    self = [super init];
    if (self) {
        self.store = stre;
    }
    return self;
}
- (void)dealloc {
    self.store = nil;
    [super dealloc];
}

#pragma mark controller delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.store objectForKey:k_merchant_name];
    
    UIBarButtonItem *_refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    self.navigationItem.rightBarButtonItem = _refresh;
    [_refresh release];
    
    SCouponsTableView *_ts = [[SCouponsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.couponsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.couponsTableView = _ts;
    [_ts release];
    
    CSMerchantCouponsDataStore *_ds = [[CSMerchantCouponsDataStore alloc] initWithDelegate:_ts];
    _ds.merchant = self.store;
    self.couponsTableView.couponsDataStore = _ds;
    [_ds release];
    
    [self.couponsTableView startPullToRefreshWithAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshAction:(id)sender {
    [self.couponsTableView finishPullToRefreshWithAnimated:NO];
    [self.couponsTableView startPullToRefreshWithAnimated:YES];
}

#pragma mark CouponsTableView Delegate
- (void)couponsTableView:(SCouponsTableView *)couponsTableView didSelectCoupon:(id)coupon atIndexPath:(NSIndexPath *)indexPath {
    [SUtil showCouponTargetLinkWithCoupon:coupon ViewController:self];
}

@end
