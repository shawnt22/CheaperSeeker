//
//  SListDataStore.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDataLoader.h"

#pragma mark - ListDataStoreProtocol
typedef struct {
    NSInteger originalIndex;
    NSInteger currentIndex;
}PItemLocation;
NS_INLINE PItemLocation PItemLocationMake(NSInteger oIndex, NSInteger cIndex) {
    PItemLocation location;
    location.originalIndex = oIndex;
    location.currentIndex = cIndex;
    return location;
}
#define InvalidItemLocaition PItemLocationMake(-1, -1)
NS_INLINE BOOL isInvalidItemLocation(PItemLocation location) {
    BOOL result = NO;
    PItemLocation invalid = InvalidItemLocaition;
    if (invalid.originalIndex == location.originalIndex && invalid.currentIndex == location.currentIndex) {
        result = YES;
    }
    return result;
}

@protocol PListDataStoreProtocol <NSObject>
@optional
@property (nonatomic, retain) NSMutableArray *items;
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy URL:(NSString *)url;
- (void)loadMoreItemsWithURL:(NSString *)url;
- (BOOL)canLoadMore;
//  PItemLocation 无效时，意味着未对原list进行任何处理
- (PItemLocation)deleteItem:(id)item;
- (PItemLocation)updateItem:(id)item;
- (PItemLocation)insertItem:(id)item atIndex:(NSInteger)index needCheck:(BOOL)needCheck;
@end

#pragma mark - ListDataStore

#define kListDataStoreRefreshCursor @"0"
#define kListDataStoreRefreshPage   1
#define kListDataStoreLimitCount 20

#define kListDataStoreResponseItems     @"items"
#define kListDataStoreResponseCount     @"count"
#define kListDataStoreResponseCursor    @"cursor"

@protocol PListRefreshLoadmoreProtocol <NSObject>
@required
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy;
- (void)loadmoreItems;
@end

@protocol PListDataStoreDelegate <NSObject>
@required
- (id)isExsitedItem:(id)item;
@end

typedef enum {
    PListDataStoreStyleCursor,
    PListDataStoreStylePage,
}PListDataStoreStyle;

@interface PListDataStore : SDataLoader <PListDataStoreProtocol> {
@protected
    BOOL _canLoadMore;
}
@property (nonatomic, assign) id<PListDataStoreDelegate> storeDelegate;
@property (nonatomic, retain) NSString *cursorID;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger limitCount;
@property (nonatomic, assign) PListDataStoreStyle storeStyle;

@end
