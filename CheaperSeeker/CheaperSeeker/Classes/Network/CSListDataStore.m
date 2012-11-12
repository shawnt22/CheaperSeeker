//
//  CSListDataStore.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "CSListDataStore.h"


#pragma mark - Home
@implementation CSHomeDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getHomeCouponsWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self loadMoreItemsWithURL:[SURLProxy getHomeCouponsWithCursor:self.cursorID Count:self.limitCount]];
}

@end

#pragma mark - Search
@implementation CSSearchDataStore
@synthesize key;

- (void)dealloc {
    self.key = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy searchCouponsWithKey:self.key Cursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self loadMoreItemsWithURL:[SURLProxy searchCouponsWithKey:self.key Cursor:self.cursorID Count:self.limitCount]];
}

@end

@interface CSSearchPoolDataStore()
@property (nonatomic, retain) NSMutableArray *itemIDs;
@property (nonatomic, retain) CSPoolCouponsDataStore *couponsDataStore;
@property (nonatomic, assign) NSInteger currentPageIndex;
- (BOOL)loadPoolCoupons;
- (NSArray *)poolCouponIDs;
- (BOOL)isFirstPageInPool;
- (NSString *)urlencodeKeywords;
@end
@implementation CSSearchPoolDataStore
@synthesize key;
@synthesize itemIDs;
@synthesize couponsDataStore;
@synthesize currentPageIndex;

- (id)initWithDelegate:(id<SDataLoaderDelegate>)adelegate {
    self = [super initWithDelegate:adelegate];
    if (self) {
        self.limitCount = 200;
        self.couponsDataStore = [[[CSPoolCouponsDataStore alloc] initWithDelegate:self] autorelease];
    }
    return self;
}
- (void)dealloc {
    [self.couponsDataStore cancelAllRequests];
    self.couponsDataStore.delegate = nil;
    self.couponsDataStore = nil;
    
    self.key = nil;
    [super dealloc];
}
- (NSString *)urlencodeKeywords {
    return [Util urlDecode:self.key];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    self.currentPageIndex = 0;
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy searchCouponsIDsInPoolWithKey:[self urlencodeKeywords] Count:self.limitCount]];
}
- (void)loadmoreItems {
    if (![self loadPoolCoupons]) {
        [self notifyDataloader:self didFailRequest:nil Error:nil];
    }
}
- (BOOL)canLoadMore {
    return [self.items count] < [self.itemIDs count] ? YES : NO;
}
- (void)requestFinished:(ASIHTTPRequest *)asirequest {
    SURLRequest *request = [self prepareRequest:(SURLRequest *)asirequest];
    if (!request.error) {
        if (request.tag == SURLRequestItemsRefresh) {
            NSArray *_items = [request.formatedResponse objectForKey:kListDataStoreResponseItems];
            if ([_items count] > 0) {
                [self notifyDataloader:self submitResponse:_items Request:request];
                self.itemIDs = [NSMutableArray arrayWithArray:_items];
            }
        }
        if (![self loadPoolCoupons]) {
            [self notifyDataloader:self didFailRequest:request Error:request.error];
        }
    } else {
        [self notifyDataloader:self didFailRequest:request Error:request.error];
    }
}
- (NSArray *)poolCouponIDs {
    NSRange _range = NSMakeRange((self.currentPageIndex - 1) * kListDataStoreLimitCount, kListDataStoreLimitCount);
    if (_range.location < [self.itemIDs count]) {
        NSInteger _length = [self.itemIDs count] - _range.location;
        _range.length = _range.length > _length ? _length : _range.length;
        [self.itemIDs subarrayWithRange:_range];
    }
    return nil;
}
- (BOOL)loadPoolCoupons {
    BOOL _result = YES;
    self.currentPageIndex += 1;
    self.couponsDataStore.couponIDs = [self poolCouponIDs];
    [self.couponsDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    return _result;
}
- (BOOL)isFirstPageInPool {
    return self.currentPageIndex == 1 ? YES : NO;
}
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (dataloader == self.couponsDataStore && request.tag == SURLRequestItemsRefresh) {
        if ([self isFirstPageInPool]) {
            self.items = [NSMutableArray array];
        }
        [self.items addObjectsFromArray:self.couponsDataStore.items];
    }
    [self notifyDataloader:self didFinishRequest:request];
}
- (void)dataloader:(SDataLoader *)dataloader submitResponse:(id)response Request:(SURLRequest *)request {
    [self notifyDataloader:self submitResponse:[request.formatedResponse objectForKey:kListDataStoreResponseItems] Request:request];
}
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    [self notifyDataloader:self didFailRequest:request Error:request.error];
}

@end

@interface CSPoolCouponsDataStore()
@property (nonatomic, retain) SURLRequest *couponsRequest;
- (NSString *)couponIDsParameterString;
@end
@implementation CSPoolCouponsDataStore
@synthesize couponIDs;
@synthesize couponsRequest;

- (void)dealloc {
    self.couponsRequest = nil;
    self.couponIDs = nil;
    [super dealloc];
}
- (void)cancelAllRequests {
    [super cancelAllRequests];
    [self cancelRequest:self.couponsRequest];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy searchCouponsInPoolThroughIDs]];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy URL:(NSString *)url {
    [self cancelRequest:self.couponsRequest];
    
    self.cursorID = kListDataStoreRefreshCursor;
    SURLRequest *_request = [[SURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.delegate = self;
    _request.tag = SURLRequestItemsRefresh;
    _request.requestMethod = @"POST";
    _request.cachePolicy = cachePolicy;
    
    [_request setPostValue:[self couponIDsParameterString] forKey:@"ids"];
    
    self.couponsRequest = _request;
    [_request release];
    
    [self startRequest:self.couponsRequest];
}
- (void)loadmoreItems {
}
- (BOOL)canLoadMore {
    return NO;
}
- (NSString *)couponIDsParameterString {
    NSString *_result = @"";
    for (id _cponID in self.couponIDs) {
        _result = [NSString stringWithFormat:@"%@%@,", _result, _cponID];
    }
    _result = [Util isEmptyString:_result] ? _result : [_result substringToIndex:([_result length]-1)];
    return _result;
}

@end

#pragma mark - Merchant
@implementation CSMerchantsDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getMerchantsWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self loadMoreItemsWithURL:[SURLProxy getMerchantsWithCursor:self.cursorID Count:self.limitCount]];
}

@end

@implementation CSMerchantCouponsDataStore
@synthesize merchant;

- (void)dealloc {
    self.merchant = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getMerchantCouponsWithMerchantID:[self.merchant objectForKey:k_merchant_id] Cursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self loadMoreItemsWithURL:[SURLProxy getMerchantCouponsWithMerchantID:[self.merchant objectForKey:k_merchant_id] Cursor:self.cursorID Count:self.limitCount]];
}

@end

#pragma mark - Category
@interface CSCategoriesDataStore()
- (NSMutableDictionary *)superCategoryWith:(id)category;
- (void)appendSuperCategoryWith:(NSMutableArray *)items;
@end
@implementation CSCategoriesDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getCategoriesWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self loadMoreItemsWithURL:[SURLProxy getCategoriesWithCursor:self.cursorID Count:self.limitCount]];
}
- (NSMutableDictionary *)superCategoryWith:(id)category {
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionary];
    id _v = [category objectForKey:k_category_id];
    if (_v) {
        [_mdic setObject:_v forKey:k_category_id];
    }
    _v = [category objectForKey:k_category_title];
    if (_v) {
        [_mdic setObject:_v forKey:k_category_title];
    }
    _mdic = [[_mdic allKeys] count] > 0 ? _mdic : nil;
    return _mdic;
}
- (void)appendSuperCategoryWith:(NSMutableArray *)items {
    for (NSInteger index = 0; index < [items count]; index++) {
        NSMutableDictionary *_categoryDic = [NSMutableDictionary dictionaryWithDictionary:[items objectAtIndex:index]];
        NSMutableArray *_subCategories = [NSMutableArray arrayWithArray:[_categoryDic objectForKey:k_category_subitems]];
        [_subCategories insertObject:[self superCategoryWith:_categoryDic] atIndex:0];
        [_categoryDic setObject:_subCategories forKey:k_category_subitems];
        [items replaceObjectAtIndex:index withObject:_categoryDic];
    }
}
- (void)requestFinished:(ASIHTTPRequest *)asirequest {
    SURLRequest *request = [self prepareRequest:(SURLRequest *)asirequest];
    if (!request.error) {
        switch (request.tag) {
            case SURLRequestItemsRefresh:{
                NSArray *_items = [request.formatedResponse objectForKey:kListDataStoreResponseItems];
                NSInteger _count = [[request.formatedResponse objectForKey:kListDataStoreResponseCount] integerValue];
                if ([_items count] > 0) {
                    [self notifyDataloader:self submitResponse:_items Request:request];
                    self.items = [NSMutableArray arrayWithArray:_items];
                    if (self.storeStyle == PListDataStoreStyleCursor) {
                        self.cursorID = [request.formatedResponse objectForKey:kListDataStoreResponseCursor];
                    }
                }
                _canLoadMore = _count > [_items count] ? YES : NO;
                [self appendSuperCategoryWith:self.items];
            }
                break;
            case SURLRequestItemsLoadmore:{
                NSArray *_items = [request.formatedResponse objectForKey:kListDataStoreResponseItems];
                NSInteger _count = [[request.formatedResponse objectForKey:kListDataStoreResponseCount] integerValue];
                if ([_items count] > 0) {
                    [self notifyDataloader:self submitResponse:_items Request:request];
                    [self.items addObjectsFromArray:_items];
                    if (self.storeStyle == PListDataStoreStyleCursor) {
                        self.cursorID = [request.formatedResponse objectForKey:kListDataStoreResponseCursor];
                    }
                }
                _canLoadMore = _count > [_items count] ? YES : NO;
            }
                break;
            default:
                break;
        }
        [self notifyDataloader:self didFinishRequest:request];
    } else {
        [self notifyDataloader:self didFailRequest:request Error:request.error];
    }
}

@end

@implementation CSCategoryCouponsDataStore
@synthesize category;

- (void)dealloc {
    self.category = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getCategoryCouponsWithCategoryID:[self.category objectForKey:k_category_id] Cursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self loadMoreItemsWithURL:[SURLProxy getCategoryCouponsWithCategoryID:[self.category objectForKey:k_category_id] Cursor:self.cursorID Count:self.limitCount]];
}

@end






#pragma mark - Local Request
#import "CSLocalRequest.h"

@implementation CSHomeDataStore(LocalRequest)
- (NSString *)localResponseString:(SURLRequest *)request {
    return [CSLocalRequest couponsJSONString];
}
@end

@implementation CSSearchDataStore(LocalRequest)
- (NSString *)localResponseString:(SURLRequest *)request {
    return [CSLocalRequest couponsJSONString];
}
@end

@implementation CSMerchantsDataStore(LocalRequest)
- (NSString *)localResponseString:(SURLRequest *)request {
    return [CSLocalRequest merchantsJSONString];
}
@end

@implementation CSMerchantCouponsDataStore(LocalRequest)
- (NSString *)localResponseString:(SURLRequest *)request {
    return [CSLocalRequest couponsJSONString];
}
@end

@implementation CSCategoriesDataStore(LocalRequest)
- (NSString *)localResponseString:(SURLRequest *)request {
    return [CSLocalRequest categoriesJSONString];
}
@end

@implementation CSCategoryCouponsDataStore(LocalRequest)
- (NSString *)localResponseString:(SURLRequest *)request {
    return [CSLocalRequest couponsJSONString];
}
@end


