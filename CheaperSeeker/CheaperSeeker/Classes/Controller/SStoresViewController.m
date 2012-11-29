//
//  SStoresViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SStoresViewController.h"
#import "SStyle.h"
#import "SLayout.h"
#import "SMerchantCell.h"
#import "SStoreCouponsViewController.h"

@interface SStoresViewController()
@property (nonatomic, assign) SMerchantsTableView *commonMerchantsTableView;
@property (nonatomic, assign) SMerchantsTableView *featuredMerchantsTableView;
@property (nonatomic, assign) SMerchantsTableView *currentMerchantsTableView;
- (void)createCommonMerchantsTableView;
- (void)createFeaturedMerchantsTableView;
- (void)segmentControlDidChangeValue:(UISegmentedControl *)segmentControl;
@end

@implementation SStoresViewController
@synthesize commonMerchantsTableView, featuredMerchantsTableView, currentMerchantsTableView;

#pragma mark init
- (void)createCommonMerchantsTableView {
    SMerchantsTableView *_ts = [[SMerchantsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _ts.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.merchantsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.commonMerchantsTableView = _ts;
    [_ts release];
    
    CSMerchantsDataStore *_ds = [[CSMerchantsDataStore alloc] initWithDelegate:_ts];
    _ds.dstype = MerchantsDataStoreCommon;
    self.commonMerchantsTableView.merchantsDataStore = _ds;
    [_ds release];
    
    [_ts startPullToRefreshWithAnimated:YES];
}
- (void)createFeaturedMerchantsTableView {
    SMerchantsTableView *_ts = [[SMerchantsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _ts.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _ts.backgroundColor = self.view.backgroundColor;
    _ts.merchantsTableViewDelegate = self;
    [self.view addSubview:_ts];
    self.featuredMerchantsTableView = _ts;
    [_ts release];
    
    CSMerchantsDataStore *_ds = [[CSMerchantsDataStore alloc] initWithDelegate:_ts];
    _ds.dstype = MerchantsDataStoreFeatured;
    self.featuredMerchantsTableView.merchantsDataStore = _ds;
    [_ds release];
    
    [_ts startPullToRefreshWithAnimated:YES];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kViewControllerStoreTitle;
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    UIBarButtonItem *_refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    self.navigationItem.rightBarButtonItem = _refresh;
    [_refresh release];
    
    UISegmentedControl *_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:k_text_merchants_segment_item_fetured, k_text_merchants_segment_item_all, nil]];
    _segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [_segment addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segment;
    [_segment release];
    
    _segment.selectedSegmentIndex = 0;
    [self segmentControlDidChangeValue:_segment];
    [self.currentMerchantsTableView startPullToRefreshWithAnimated:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark table delegate
- (void)segmentControlDidChangeValue:(UISegmentedControl *)segmentControl {
    self.currentMerchantsTableView.hidden = YES;
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
        {
            if (!self.featuredMerchantsTableView) {
                [self createFeaturedMerchantsTableView];
            }
            self.currentMerchantsTableView = self.featuredMerchantsTableView;
        }
            break;
        case 1:
        {
            if (!self.commonMerchantsTableView) {
                [self createCommonMerchantsTableView];
            }
            self.currentMerchantsTableView = self.commonMerchantsTableView;
        }
            break;
        default:
            break;
    }
    self.currentMerchantsTableView.hidden = NO;
}
- (void)merchantsTableView:(SMerchantsTableView *)merchantsTableView didSelectMerchant:(id)merchant atIndexPath:(NSIndexPath *)indexPath {
    SStoreCouponsViewController *_scvctr = [[SStoreCouponsViewController alloc] initWithStore:merchant];
    [self.navigationController pushViewController:_scvctr animated:YES];
    [_scvctr release];
}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}
- (void)refreshAction:(id)sender {
    [self.currentMerchantsTableView finishPullToRefreshWithAnimated:NO];
    [self.currentMerchantsTableView startPullToRefreshWithAnimated:YES];
}

@end
