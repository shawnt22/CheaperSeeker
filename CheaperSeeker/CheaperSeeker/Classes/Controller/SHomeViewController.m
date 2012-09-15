//
//  SHomeViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SHomeViewController.h"
#import "CSListDataStore.h"
#import "SWebViewController.h"

@interface SHomeViewController()
@property (nonatomic, assign) SCouponsTableView *couponsTableView;
- (void)createTableView;
@end
@implementation SHomeViewController
@synthesize couponsTableView;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)initSubobjects {
    [super initSubobjects];
}
- (void)dealloc {
    [super dealloc];
}
- (void)createTableView {
    SCouponsTableView *_ts = [[SCouponsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.couponsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.couponsTableView = _ts;
    [_ts release];
    
    CSHomeDataStore *_ds = [[CSHomeDataStore alloc] initWithDelegate:_ts];
    self.couponsTableView.couponsDataStore = _ds;
    [_ds release];
    
    [self.couponsTableView startPullToRefreshWithAnimated:YES];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Home";
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    [self createTableView];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark CouponsTableView Delegate
- (void)couponsTableView:(SCouponsTableView *)couponsTableView didSelectCoupon:(id)coupon atIndexPath:(NSIndexPath *)indexPath {
    SWebViewController *_web = [[SWebViewController alloc] initWithURLPath:[coupon objectForKey:k_coupon_target_link]];
    [self.navigationController pushViewController:_web animated:YES];
    [_web release];
}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}

@end
