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
@property (nonatomic, assign) BOOL isCellOpening;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) NSMutableDictionary *originalCellFrames;
@property (nonatomic, retain) UIView *originalTableFooterView;

- (void)openCellAtIndexPath:(NSIndexPath *)indexPath Animated:(BOOL)animated;
- (void)performOpenCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)finishOpenCellAnimated:(BOOL)animated;
- (void)closeCellAtIndexPath:(NSIndexPath *)indexPath Animated:(BOOL)animated;
- (void)performCloseCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)finishCloseCellAnimated:(BOOL)animated;

- (void)addOriginalFrame:(CGRect)oframe forIndexPath:(NSIndexPath *)indexPath;
- (CGRect)originalFrameForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation SCouponsTableView
@synthesize couponsDataStore;
@synthesize couponStyle, couponLayouts;
@synthesize couponsTableViewDelegate;
@synthesize isCellOpening, originalCellFrames, selectedIndexPath, originalTableFooterView;

#pragma mark init & dealloc
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.isCellOpening = NO;
        
        self.dataSource = self;
        self.pullDelegate = self;
        self.couponsTableViewDelegate = nil;
        
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
    
    self.originalCellFrames = nil;
    self.selectedIndexPath = nil;
    self.originalTableFooterView = nil;
    
    [super dealloc];
}

#pragma mark open/close animation
- (void)openCellAtIndexPath:(NSIndexPath *)indexPath Animated:(BOOL)animated {
    self.scrollEnabled = NO;
    self.originalTableFooterView = self.tableFooterView;
    self.tableFooterView = nil;
    
    self.originalCellFrames = [NSMutableDictionary dictionary];
    for (UITableViewCell *cell in self.visibleCells) {
        [self addOriginalFrame:cell.frame forIndexPath:[self indexPathForCell:cell]];
    }
    
    if (animated) {
        [UIView animateWithDuration:k_coupons_table_cell_animation_duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self performOpenCellAtIndexPath:indexPath];
                         }
                         completion:^(BOOL finished){
                             [self finishOpenCellAnimated:animated];
                         }];
    } else {
        [self performOpenCellAtIndexPath:indexPath];
        [self finishOpenCellAnimated:animated];
    }
}
- (void)performOpenCellAtIndexPath:(NSIndexPath *)indexPath {
    CGRect _convertRect = [self convertRect:[self cellForRowAtIndexPath:indexPath].frame toView:self.superview];
    
    for (UITableViewCell *_vcell in self.visibleCells) {
        NSIndexPath *_idph = [self indexPathForCell:_vcell];
        CGRect _f = _vcell.frame;
        if (_idph.row < indexPath.row) {
            _f.origin.y = _f.origin.y - _convertRect.origin.y;
            _vcell.frame = _f;
        } else if (_idph.row > indexPath.row) {
            _f.origin.y = self.bounds.size.height - _convertRect.origin.y + _f.origin.y;
            _vcell.frame = _f;
        } else if (_idph.row == indexPath.row) {
            _f.origin.y = _f.origin.y - _convertRect.origin.y;
            _f.size.width = self.bounds.size.width;
            _f.size.height = self.bounds.size.height;
            _vcell.frame = _f;
        }
    }
}
- (void)finishOpenCellAnimated:(BOOL)animated {
    
}
- (void)closeCellAtIndexPath:(NSIndexPath *)indexPath Animated:(BOOL)animated {
    self.scrollEnabled = YES;
    self.tableFooterView = self.originalTableFooterView;
    
    if (animated) {
        [UIView animateWithDuration:k_coupons_table_cell_animation_duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self performCloseCellAtIndexPath:indexPath];
                         }
                         completion:^(BOOL finished){
                             [self finishCloseCellAnimated:animated];
                         }];
    } else {
        [self performCloseCellAtIndexPath:indexPath];
        [self finishCloseCellAnimated:animated];
    }
}
- (void)performCloseCellAtIndexPath:(NSIndexPath *)indexPath {
    for (UITableViewCell *cell in self.visibleCells) {
        cell.frame = [self originalFrameForIndexPath:[self indexPathForCell:cell]];
    }
}
- (void)finishCloseCellAnimated:(BOOL)animated {
    
}
- (void)addOriginalFrame:(CGRect)oframe forIndexPath:(NSIndexPath *)indexPath {
    [self.originalCellFrames setObject:NSStringFromCGRect(oframe) forKey:indexPath];
}
- (CGRect)originalFrameForIndexPath:(NSIndexPath *)indexPath {
    NSString *frameStr = [self.originalCellFrames objectForKey:indexPath];
    return [Util isEmptyString:frameStr] ? CGRectZero : CGRectFromString(frameStr);
}
- (void)resetCellOpenState {
    self.scrollEnabled = YES;
    self.isCellOpening = NO;
    self.selectedIndexPath = nil;
    self.originalCellFrames = nil;
    self.tableFooterView = self.originalTableFooterView;
    self.originalTableFooterView = nil;
    [self reloadData];
}

#pragma mark table delegate
- (void)tableViewPullToRefresh:(TSPullTableView *)tableView {
    [self.couponsDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
}
- (void)tableViewPullToLoadmore:(TSPullTableView *)tableView {
    [self.couponsDataStore loadmoreItems];
}
- (void)tableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.isCellOpening) {
        [self closeCellAtIndexPath:self.selectedIndexPath Animated:YES];
        [(SCouponCell *)[tableView cellForRowAtIndexPath:self.selectedIndexPath] closeWithAnimated:YES];
    } else {
        self.selectedIndexPath = indexPath;
        [self openCellAtIndexPath:indexPath Animated:YES];
        [(SCouponCell *)[tableView cellForRowAtIndexPath:self.selectedIndexPath] openWithAnimated:YES];
    }
    self.isCellOpening = !self.isCellOpening;
    
    
    
//    if (self.couponsTableViewDelegate && [self.couponsTableViewDelegate respondsToSelector:@selector(couponsTableView:didSelectCoupon:atIndexPath:)]) {
//        [self.couponsTableViewDelegate couponsTableView:self didSelectCoupon:[self.couponsDataStore.items objectAtIndex:indexPath.row] atIndexPath:indexPath];
//    }
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
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id _coupon = [self.couponsDataStore.items objectAtIndex:indexPath.row];
    SCouponLayout *_layout = [self.couponLayouts objectAtIndex:indexPath.row];
    [_cell refreshWithCoupon:_coupon Layout:_layout Style:self.couponStyle];
    _cell.customBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.couponsDataStore.items count]];
    _cell.customSelectedBackgroundView.bgStyle = [TCustomCellBGView plainStyleWithIndex:indexPath.row Count:[self.couponsDataStore.items count]];
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
