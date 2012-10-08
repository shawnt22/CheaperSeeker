//
//  SURLRequest.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SURLRequest.h"
#import "JSONKit.h"

@implementation SURLRequest
@synthesize formatedResponse;

- (void)dealloc {
    self.formatedResponse = nil;
    [super dealloc];
}
- (NSString *)responseString {
#ifdef LOCAL_REQUEST
    if (LOCAL_REQUEST && delegate && [delegate conformsToProtocol:@protocol(SURLRequestLocalResponseDelegate)] && [delegate respondsToSelector:@selector(localResponseString:)]) {
        id<SURLRequestLocalResponseDelegate> lrdelegate = (id<SURLRequestLocalResponseDelegate>)delegate;
        return [lrdelegate localResponseString:self];
    }
#endif
    return [super responseString];
}

@end


#import "SUtil.h"
static ASIDownloadCache *_imgDownloadCache = nil;
static ASIDownloadCache *_docDownloadCache = nil;
@implementation ASIDownloadCache(SDownloadCache)

+ (ASIDownloadCache *)shareDocumentDownloadCache {
    if (!_docDownloadCache) {
        _docDownloadCache = [[ASIDownloadCache alloc] init];
    }
    _docDownloadCache.storagePath = [SUtil currentDocumentCacheStoragePath];
    return _docDownloadCache;
}
+ (ASIDownloadCache *)shareImageDownloadCache {
    if (!_imgDownloadCache) {
        _imgDownloadCache = [[ASIDownloadCache alloc] init];
        _imgDownloadCache.storagePath = [SUtil currentImageCacheStoragePath];
    }
    return _imgDownloadCache;
}

@end