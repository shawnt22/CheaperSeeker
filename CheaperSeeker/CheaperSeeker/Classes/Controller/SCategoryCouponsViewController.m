//
//  SCategoryCouponsViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCategoryCouponsViewController.h"
#import "CSListDataStore.h"
#import "SWebViewController.h"

@interface SCategoryCouponsViewController ()
@property (nonatomic, assign) SCouponsTableView *couponsTableView;
@end

@implementation SCategoryCouponsViewController
@synthesize category;
@synthesize couponsTableView;

#pragma mark init & dealloc
- (id)initWithCategory:(id)ctgy {
    self = [super init];
    if (self) {
        self.category = ctgy;
    }
    return self;
}
- (void)dealloc {
    self.category = nil;
    [super dealloc];
}

#pragma mark controller delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.category objectForKey:k_category_title];
    
    SCouponsTableView *_ts = [[SCouponsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.couponsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.couponsTableView = _ts;
    [_ts release];
    
    CSCategoryCouponsDataStore *_ds = [[CSCategoryCouponsDataStore alloc] initWithDelegate:_ts];
    _ds.category = self.category;
    self.couponsTableView.couponsDataStore = _ds;
    [_ds release];
    
    [self.couponsTableView startPullToRefreshWithAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CouponsTableView Delegate
- (void)couponsTableView:(SCouponsTableView *)couponsTableView didSelectCoupon:(id)coupon atIndexPath:(NSIndexPath *)indexPath {
    [SUtil showCouponTargetLinkWithCoupon:coupon ViewController:self];
}

@end
