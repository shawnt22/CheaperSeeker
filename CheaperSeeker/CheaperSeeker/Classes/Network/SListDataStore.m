//
//  SListDataStore.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SListDataStore.h"

#pragma mark - ListDataStore
@interface PListDataStore()
@property (nonatomic, retain) SURLRequest *listRequest;
- (id)notifyIsExsitedItem:(id)item;
@end

@implementation PListDataStore
@synthesize storeDelegate;
@synthesize items;
@synthesize cursorID, pageIndex, limitCount;
@synthesize listRequest;
@synthesize storeStyle;

#pragma mark init & dealloc
- (void)initSubobjects {
    [super initSubobjects];
    self.storeDelegate = nil;
    self.items = [NSMutableArray array];
    _canLoadMore = YES;
    self.storeStyle = PListDataStoreStyleCursor;
    self.cursorID = kListDataStoreRefreshCursor;
    self.pageIndex = kListDataStoreRefreshPage;
    self.limitCount = kListDataStoreLimitCount;
    self.listRequest = nil;
}
- (void)dealloc {
    self.listRequest = nil;
    self.storeDelegate = nil;
    self.items = nil;
    self.cursorID = nil;
    [super dealloc];
}

#pragma mark request delegate
- (void)cancelAllRequests {
    [super cancelAllRequests];
    [self cancelRequest:self.listRequest];
}
- (void)strequestFinished:(SURLRequest *)request {
    switch (request.tag) {
        case SURLRequestItemsRefresh:{
            NSArray *_items = [request.responseData objectForKey:kListDataStoreResponseItems];
            NSInteger _count = [[request.responseData objectForKey:kListDataStoreResponseCount] integerValue];
            if ([_items count] > 0) {
                [self notifyRequest:request submitResponse:_items];
                self.items = [NSMutableArray arrayWithArray:_items];
                if (self.storeStyle == PListDataStoreStyleCursor) {
                    self.cursorID = [request.responseData objectForKey:kListDataStoreResponseCursor];
                }
            }
            _canLoadMore = _count > [_items count] ? YES : NO;
        }
            break;
        case SURLRequestItemsLoadmore:{
            NSArray *_items = [request.responseData objectForKey:kListDataStoreResponseItems];
            NSInteger _count = [[request.responseData objectForKey:kListDataStoreResponseCount] integerValue];
            if ([_items count] > 0) {
                [self notifyRequest:request submitResponse:_items];
                [self.items addObjectsFromArray:_items];
                if (self.storeStyle == PListDataStoreStyleCursor) {
                    self.cursorID = [request.responseData objectForKey:kListDataStoreResponseCursor];
                }
            }
            _canLoadMore = _count > [_items count] ? YES : NO;
        }
            break;
        default:
            break;
    }
    [super notifyRequestFinished:request];
}

#pragma mark items manager
- (PItemLocation)deleteItem:(id)item {
    PItemLocation location = InvalidItemLocaition;
    id exsited = [self notifyIsExsitedItem:item];
    if (exsited) {
        NSInteger index = [self.items indexOfObject:exsited];
        location.originalIndex = index;
        [self.items removeObject:exsited];
    }
    return location;
}
- (PItemLocation)updateItem:(id)item {
    PItemLocation location = InvalidItemLocaition;
    id exsited = [self notifyIsExsitedItem:item];
    if (exsited) {
        NSInteger index = [self.items indexOfObject:exsited];
        location.originalIndex = index;
        location.currentIndex = index;
        [self.items replaceObjectAtIndex:index withObject:item];
    }
    return location;
}
- (PItemLocation)insertItem:(id)item atIndex:(NSInteger)index needCheck:(BOOL)needCheck {
    PItemLocation location = InvalidItemLocaition;
    location.currentIndex = index;
    if (needCheck) {
        id existed = [self notifyIsExsitedItem:item];
        if (existed) {
            NSInteger existedIndex = [self.items indexOfObject:existed];
            location.originalIndex = existedIndex;
            index = index > existedIndex ? index - 1 : index;
            [self.items removeObject:existed];
        }
    }
    [self.items insertObject:item atIndex:index];
    return location;
}
- (id)notifyIsExsitedItem:(id)item {
    if (self.storeDelegate && [self.storeDelegate respondsToSelector:@selector(isExsitedItem:)]) {
        return [self.storeDelegate isExsitedItem:item];
    }
    return nil;
}
- (BOOL)canLoadMore {
    return _canLoadMore;
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy URL:(NSString *)url {
    [self cancelRequest:self.listRequest];
    
    self.cursorID = kListDataStoreRefreshCursor;
    SURLRequest *_request = [[SURLRequest alloc] initWithURL:nil];
    _request.tag = SURLRequestItemsRefresh;
    [_request prepareRequestWith:url CachePolicy:cachePolicy];
    self.listRequest = _request;
    [_request release];
    
    [self startRequest:self.listRequest];
}
- (void)loadMoreItemsWithURL:(NSString *)url {
    [self cancelRequest:self.listRequest];
    
    SURLRequest *_request = [[SURLRequest alloc] initWithRequestDelegate:self];
    _request.tag = SURLRequestItemsLoadmore;
    [_request prepareRequestWith:url CachePolicy:TTURLRequestCachePolicyNetwork];
    self.listRequest = _request;
    [_request release];
    
    [self startRequest:self.listRequest];
}

@end
