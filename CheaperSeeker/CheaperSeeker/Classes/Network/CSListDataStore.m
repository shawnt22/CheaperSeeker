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


