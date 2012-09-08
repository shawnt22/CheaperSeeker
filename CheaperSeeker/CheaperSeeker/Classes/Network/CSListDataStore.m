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
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy getHomeCouponsWithCursor:self.cursorID Count:self.limitCount]];
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
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy searchCouponsWithKey:self.key Cursor:self.cursorID Count:self.limitCount]];
}

@end

@implementation CSMerchantsDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getMerchantsWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy getMerchantsWithCursor:self.cursorID Count:self.limitCount]];
}

@end

@implementation CSMerchantCouponsDataStore
@synthesize merchant;

- (void)dealloc {
    self.merchant = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    
}
- (void)loadmoreItems {
    
}

@end

@implementation CSCategoriesDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getCategoriesWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy getCategoriesWithCursor:self.cursorID Count:self.limitCount]];
}

@end

@implementation CSCategoryCouponsDataStore
@synthesize category;

- (void)dealloc {
    self.category = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    
}
- (void)loadmoreItems {
    
}

@end
