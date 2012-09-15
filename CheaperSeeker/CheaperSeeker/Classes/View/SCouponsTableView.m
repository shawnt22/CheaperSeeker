//
//  SCouponsTableView.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponsTableView.h"
#import "SCouponCell.h"
#import "SStyle.h"
#import "SLayout.h"

@interface SCouponsTableView()
@property (nonatomic, retain) SCouponStyle *couponStyle;
@property (nonatomic, retain) NSMutableArray *couponLayouts;
@end

@implementation SCouponsTableView
@synthesize couponsDataStore;
@synthesize couponStyle, couponLayouts;

#pragma mark init & dealloc
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.pullDelegate = self;
        
        self.couponLayouts = [NSMutableArray array];
        self.couponStyle = [[[SCouponStyle alloc] init] autorelease];
    }
    return self;
}
- (void)dealloc {
    [self.couponsDataStore cancelAllRequests];
    self.couponsDataStore.delegate = nil;
    self.couponsDataStore = nil;
    
    self.couponStyle = nil;
    self.couponLayouts = nil;
    
    [super dealloc];
}

#pragma mark table delegate
- (void)tableViewPullToRefresh:(TSPullTableView *)tableView {
    [self.couponsDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
}
- (void)tableViewPullToLoadmore:(TSPullTableView *)tableView {
    [self.couponsDataStore loadmoreItems];
}
- (void)tableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCouponLayout *_layout = [self.couponLayouts objectAtIndex:indexPath.row];
    return _layout ? _layout.height : [SCouponCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.couponsDataStore.items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"coupon";
    SCouponCell *_cell = (SCouponCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
    }
    id _coupon = [self.couponsDataStore.items objectAtIndex:indexPath.row];
    SCouponLayout *_layout = [self.couponLayouts objectAtIndex:indexPath.row];
    [_cell refreshWithCoupon:_coupon Layout:_layout Style:self.couponStyle];
    return _cell;
}

#pragma mark loader delegate
- (void)dataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request {}
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        [self finishPullToRefreshWithAnimated:YES];
        [self reloadDataWithDataFull:![self.couponsDataStore canLoadMore]];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self finishPullToLoadmoreWithAnimated:YES];
        [self reloadDataWithDataFull:![self.couponsDataStore canLoadMore]];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader submitResponse:(id)response Request:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        self.couponLayouts = [NSMutableArray array];
        for (id _coupon in response) {
            SCouponLayout *_layout = [[SCouponLayout alloc] init];
            [_layout layoutWithCoupon:_coupon Style:self.couponStyle];
            [self.couponLayouts addObject:_layout];
            [_layout release];
        }
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        for (id _coupon in response) {
            SCouponLayout *_layout = [[SCouponLayout alloc] init];
            [_layout layoutWithCoupon:_coupon Style:self.couponStyle];
            [self.couponLayouts addObject:_layout];
            [_layout release];
        }
        return;
    }
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
