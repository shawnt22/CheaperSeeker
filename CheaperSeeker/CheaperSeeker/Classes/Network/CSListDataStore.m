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
@implementation CSCategoriesDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getCategoriesWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self loadMoreItemsWithURL:[SURLProxy getCategoriesWithCursor:self.cursorID Count:self.limitCount]];
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


