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
@property (nonatomic, assign) SCouponsTableView *commonCouponsTableView;
@property (nonatomic, assign) SCouponsTableView *featuredCouponsTableView;
@property (nonatomic, assign) SCouponsTableView *currentCouponsTableView;
- (void)createCommonCouponsTable;
- (void)createFeaturedCouponsTable;
- (void)segmentControlDidChangeValue:(UISegmentedControl *)segmentControl;
@end

@implementation SStoreCouponsViewController
@synthesize commonCouponsTableView, featuredCouponsTableView, currentCouponsTableView;
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
- (void)createCommonCouponsTable {
    SCouponsTableView *_ts = [[SCouponsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _ts.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.couponsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.commonCouponsTableView = _ts;
    [_ts release];
    
    CSMerchantCouponsDataStore *_ds = [[CSMerchantCouponsDataStore alloc] initWithDelegate:_ts];
    _ds.dstype = MerchantCouponsDataStoreCommon;
    _ds.merchant = self.store;
    self.commonCouponsTableView.couponsDataStore = _ds;
    [_ds release];
    
    [_ts startPullToRefreshWithAnimated:YES];
}
- (void)createFeaturedCouponsTable {
    SCouponsTableView *_ts = [[SCouponsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _ts.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.couponsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.featuredCouponsTableView = _ts;
    [_ts release];
    
    CSMerchantCouponsDataStore *_ds = [[CSMerchantCouponsDataStore alloc] initWithDelegate:_ts];
    _ds.dstype = MerchantCouponsDataStoreFeatured;
    _ds.merchant = self.store;
    self.featuredCouponsTableView.couponsDataStore = _ds;
    [_ds release];
    
    [_ts startPullToRefreshWithAnimated:YES];
}

#pragma mark controller delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.store objectForKey:k_merchant_name];
    
    UIBarButtonItem *_refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    self.navigationItem.rightBarButtonItem = _refresh;
    [_refresh release];
    
    UISegmentedControl *_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:k_text_merchant_coupons_segment_item_featured, k_text_merchant_coupons_segment_item_common, nil]];
    _segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [_segment addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segment;
    [_segment release];
    
    _segment.selectedSegmentIndex = 0;
    [self segmentControlDidChangeValue:_segment];
    [self.currentCouponsTableView startPullToRefreshWithAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshAction:(id)sender {
    [self.currentCouponsTableView finishPullToRefreshWithAnimated:NO];
    [self.currentCouponsTableView resetCellOpenState];
    [self.currentCouponsTableView startPullToRefreshWithAnimated:YES];
}

#pragma mark table manager
- (void)segmentControlDidChangeValue:(UISegmentedControl *)segmentControl {
    self.currentCouponsTableView.hidden = YES;
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
        {
            if (!self.commonCouponsTableView) {
                [self createCommonCouponsTable];
            }
            self.currentCouponsTableView = self.commonCouponsTableView;
        }
            break;
        case 1:
        {
            if (!self.featuredCouponsTableView) {
                [self createFeaturedCouponsTable];
            }
            self.currentCouponsTableView = self.featuredCouponsTableView;
        }
            break;
        default:
            break;
    }
    self.currentCouponsTableView.hidden = NO;
}

#pragma mark CouponsTableView Delegate
- (void)couponsTableView:(SCouponsTableView *)couponsTableView didSelectCoupon:(id)coupon atIndexPath:(NSIndexPath *)indexPath {
    [SUtil showCouponTargetLinkWithCoupon:coupon ViewController:self];
}

@end
