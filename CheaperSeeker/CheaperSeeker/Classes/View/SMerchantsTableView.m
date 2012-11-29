//
//  SMerchantsTableView.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-11-29.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SMerchantsTableView.h"
#import "SStyle.h"
#import "SMerchantCell.h"

@interface SMerchantsTableView ()
@property (nonatomic, retain) SMerchantStyle *merchantStyle;
@end

@implementation SMerchantsTableView
@synthesize merchantsDataStore, merchantsTableViewDelegate;
@synthesize merchantStyle;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.dataSource = self;
        self.pullDelegate = self;
        self.merchantsTableViewDelegate = nil;
        
        self.merchantStyle = [[[SMerchantStyle alloc] init] autorelease];
    }
    return self;
}
- (void)dealloc {
    [self.merchantsDataStore cancelAllRequests];
    self.merchantsDataStore.delegate = nil;
    self.merchantsDataStore = nil;
    
    self.merchantStyle = nil;
    [super dealloc];
}

#pragma mark table delegate
- (void)tableViewPullToRefresh:(TSPullTableView *)tableView {
    [self.merchantsDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
}
- (void)tableViewPullToLoadmore:(TSPullTableView *)tableView {
    [self.merchantsDataStore loadmoreItems];
}
- (void)tableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.merchantsTableViewDelegate && [self.merchantsTableViewDelegate respondsToSelector:@selector(merchantsTableView:didSelectMerchant:atIndexPath:)]) {
        [self.merchantsTableViewDelegate merchantsTableView:self didSelectMerchant:[self.merchantsDataStore.items objectAtIndex:indexPath.row] atIndexPath:indexPath];
    }
}
- (CGFloat)tableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SMerchantCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.merchantsDataStore.items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"mrchnt";
    SMerchantCell *_cell = (SMerchantCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SMerchantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
    }
    id _mrchnt = [self.merchantsDataStore.items objectAtIndex:indexPath.row];
    [_cell refreshWithMerchant:_mrchnt Layout:nil Style:self.merchantStyle];
    _cell.customBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.merchantsDataStore.items count]];
    _cell.customSelectedBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.merchantsDataStore.items count]];
    return _cell;
}

#pragma mark dataloader delegate
- (void)dataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request {}
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        [self finishPullToRefreshWithAnimated:YES];
        [self reloadDataWithDataFull:![self.merchantsDataStore canLoadMore]];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self finishPullToLoadmoreWithAnimated:YES];
        [self reloadDataWithDataFull:![self.merchantsDataStore canLoadMore]];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader submitResponse:(id)response Request:(SURLRequest *)request {
    
}
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    if (request.tag == SURLRequestItemsRefresh) {
        [self finishPullToRefreshWithAnimated:YES];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self finishPullToLoadmoreWithAnimated:YES];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request {}

@end
