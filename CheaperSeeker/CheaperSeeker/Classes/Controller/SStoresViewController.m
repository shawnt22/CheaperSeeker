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
@property (nonatomic, assign) TSPullTableView *featuredStoresTableView;
@property (nonatomic, retain) CSFeaturedMerchantsDataStore *featuredStoresDataStore;
@property (nonatomic, retain) SMerchantStyle *merchantStyle;
@end
@implementation SStoresViewController
@synthesize featuredStoresDataStore, featuredStoresTableView;
@synthesize merchantStyle;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        self.featuredStoresDataStore = [[[CSFeaturedMerchantsDataStore alloc] initWithDelegate:self] autorelease];
        self.merchantStyle = [[[SMerchantStyle alloc] init] autorelease];
    }
    return self;
}
- (void)initSubobjects {
    [super initSubobjects];
}
- (void)dealloc {
    [self.featuredStoresDataStore cancelAllRequests];
    self.featuredStoresDataStore.delegate = nil;
    self.featuredStoresDataStore = nil;
    
    self.merchantStyle = nil;
    [super dealloc];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kViewControllerStoreTitle;
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    UIBarButtonItem *_refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    self.navigationItem.rightBarButtonItem = _refresh;
    [_refresh release];
    
    TSPullTableView *_table = [[CSPullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _table.backgroundColor = self.view.backgroundColor;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.pullDelegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    self.featuredStoresTableView = _table;
    [_table release];
    
    [self.featuredStoresTableView startPullToRefreshWithAnimated:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark table delegate
- (void)tableViewPullToRefresh:(TSPullTableView *)tableView {
    [self.featuredStoresDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
}
- (void)tableViewPullToLoadmore:(TSPullTableView *)tableView {
    [self.featuredStoresDataStore loadmoreItems];
}
- (void)tableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SStoreCouponsViewController *_scvctr = [[SStoreCouponsViewController alloc] initWithStore:[self.featuredStoresDataStore.items objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:_scvctr animated:YES];
    [_scvctr release];
}
- (CGFloat)tableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SMerchantCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.featuredStoresDataStore.items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"mrchnt";
    SMerchantCell *_cell = (SMerchantCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SMerchantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
    }
    id _mrchnt = [self.featuredStoresDataStore.items objectAtIndex:indexPath.row];
    [_cell refreshWithMerchant:_mrchnt Layout:nil Style:self.merchantStyle];
    _cell.customBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.featuredStoresDataStore.items count]];
    _cell.customSelectedBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.featuredStoresDataStore.items count]];
    return _cell;
}

#pragma mark dataloader delegate
- (void)dataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request {}
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        [self.featuredStoresTableView finishPullToRefreshWithAnimated:YES];
        [self.featuredStoresTableView reloadDataWithDataFull:![self.featuredStoresDataStore canLoadMore]];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self.featuredStoresTableView finishPullToLoadmoreWithAnimated:YES];
        [self.featuredStoresTableView reloadDataWithDataFull:![self.featuredStoresDataStore canLoadMore]];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader submitResponse:(id)response Request:(SURLRequest *)request {
    
}
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    if (request.tag == SURLRequestItemsRefresh) {
        [self.featuredStoresTableView finishPullToRefreshWithAnimated:YES];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self.featuredStoresTableView finishPullToLoadmoreWithAnimated:YES];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request {}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}
- (void)refreshAction:(id)sender {
    [self.featuredStoresTableView finishPullToRefreshWithAnimated:NO];
    [self.featuredStoresTableView startPullToRefreshWithAnimated:YES];
}

@end
