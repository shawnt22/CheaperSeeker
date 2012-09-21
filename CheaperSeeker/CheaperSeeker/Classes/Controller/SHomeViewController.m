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
#import "SSearchResultViewController.h"

@interface SHomeViewController()
@property (nonatomic, assign) SCouponsTableView *couponsTableView;
@property (nonatomic, retain) UIControl *searchCover;
@property (nonatomic, assign) UISearchBar *theSearchBar;
- (void)createTableView;
- (void)cancelSearchAction:(id)sender;
@end
@implementation SHomeViewController
@synthesize couponsTableView;
@synthesize searchCover, theSearchBar;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        self.searchCover = nil;
    }
    return self;
}
- (void)initSubobjects {
    [super initSubobjects];
}
- (void)dealloc {
    self.searchCover = nil;
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
    self.title = kViewControllerHomeTitle;
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    [self createTableView];
    
    UISearchBar *_sbar = [[UISearchBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    _sbar.tintColor = self.navigationController.navigationBar.tintColor;
    _sbar.delegate = self;
    _sbar.placeholder = kHomeSearchBarPlaceHolder;
    self.navigationItem.titleView = _sbar;
    self.theSearchBar = _sbar;
    [_sbar release];
    
    UIControl *_scover = [[UIControl alloc] initWithFrame:self.view.bounds];
    _scover.backgroundColor = SRGBACOLOR(0, 0, 0, 0.5);
    [_scover addTarget:self action:@selector(cancelSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.searchCover = _scover;
    [_scover release];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    if (self.searchCover.superview) {
        [self.searchCover removeFromSuperview];
    }
}

#pragma mark search delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    if (!self.searchCover.superview) {
        [self.view addSubview:self.searchCover];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    if (self.searchCover.superview) {
        [self.searchCover removeFromSuperview];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    SSearchCouponsViewController *_search = [[SSearchCouponsViewController alloc] initWithKeyword:searchBar.text];
    [self.navigationController pushViewController:_search animated:YES];
    [_search release];
    [self cancelSearchAction:searchBar];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self cancelSearchAction:searchBar];
}

#pragma mark CouponsTableView Delegate
- (void)couponsTableView:(SCouponsTableView *)couponsTableView didSelectCoupon:(id)coupon atIndexPath:(NSIndexPath *)indexPath {
    [SUtil showCouponTargetLinkWithCoupon:coupon ViewController:self];
}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}
- (void)cancelSearchAction:(id)sender {
    [self.theSearchBar resignFirstResponder];
    self.theSearchBar.text = nil;
}

@end
