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
@property (nonatomic, assign) TSPullTableView *storesTableView;
@property (nonatomic, retain) CSMerchantsDataStore *storesDataStore;
@property (nonatomic, retain) SMerchantStyle *merchantStyle;
@end
@implementation SStoresViewController
@synthesize storesDataStore, storesTableView;
@synthesize merchantStyle;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        self.storesDataStore = [[[CSMerchantsDataStore alloc] initWithDelegate:self] autorelease];
        self.merchantStyle = [[[SMerchantStyle alloc] init] autorelease];
    }
    return self;
}
- (void)initSubobjects {
    [super initSubobjects];
}
- (void)dealloc {
    [self.storesDataStore cancelAllRequests];
    self.storesDataStore.delegate = nil;
    self.storesDataStore = nil;
    
    self.merchantStyle = nil;
    [super dealloc];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kViewControllerStoreTitle;
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    TSPullTableView *_table = [[CSPullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _table.backgroundColor = self.view.backgroundColor;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.pullDelegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    self.storesTableView = _table;
    [_table release];
    
    [self.storesTableView startPullToRefreshWithAnimated:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark table delegate
- (void)tableViewPullToRefresh:(TSPullTableView *)tableView {
    [self.storesDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
}
- (void)tableViewPullToLoadmore:(TSPullTableView *)tableView {
    [self.storesDataStore loadmoreItems];
}
- (void)tableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SStoreCouponsViewController *_scvctr = [[SStoreCouponsViewController alloc] initWithStore:[self.storesDataStore.items objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:_scvctr animated:YES];
    [_scvctr release];
}
- (CGFloat)tableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SMerchantCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.storesDataStore.items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"mrchnt";
    SMerchantCell *_cell = (SMerchantCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SMerchantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
    }
    id _mrchnt = [self.storesDataStore.items objectAtIndex:indexPath.row];
    [_cell refreshWithMerchant:_mrchnt Layout:nil Style:self.merchantStyle];
    _cell.customBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.storesDataStore.items count]];
    _cell.customSelectedBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.storesDataStore.items count]];
    return _cell;
}

#pragma mark dataloader delegate
- (void)dataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request {}
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        [self.storesTableView finishPullToRefreshWithAnimated:YES];
        [self.storesTableView reloadDataWithDataFull:![self.storesDataStore canLoadMore]];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self.storesTableView finishPullToLoadmoreWithAnimated:YES];
        [self.storesTableView reloadDataWithDataFull:![self.storesDataStore canLoadMore]];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader submitResponse:(id)response Request:(SURLRequest *)request {
    
}
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    if (request.tag == SURLRequestItemsRefresh) {
        [self.storesTableView finishPullToRefreshWithAnimated:YES];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self.storesTableView finishPullToLoadmoreWithAnimated:YES];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request {}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}

@end
