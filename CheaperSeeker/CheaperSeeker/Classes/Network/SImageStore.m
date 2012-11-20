//
//  SImageStore.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-5.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SImageStore.h"

#define kImageStoreImage        @"img"
#define kImageStoreObservers    @"obvs"
@interface PImageStore()
@property (nonatomic, retain) NSMutableDictionary *imageStore;
@property (nonatomic, retain) SImageLoader *imageLoader;
- (void)loadImageWithURL:(NSString *)url;
- (void)addImage:(UIImage *)img WithURL:(NSString *)url;
- (void)addObserver:(id<PImageStoreDelegate>)observer forImageURL:(NSString *)url;
- (void)removeObserver:(id<PImageStoreDelegate>)observer forImageURL:(NSString *)url;
@end

#pragma mark - Notify
@interface PImageStore(Notify)
- (void)notifyImageStore:(PImageStore *)imageStore didFinishLoadImage:(UIImage *)image forURL:(NSString *)url;
- (void)notifyImageStore:(PImageStore *)imageStore didStartLoadImageForURL:(NSString *)url;
- (void)notifyImageStore:(PImageStore *)imageStore didFailLoadImageForURL:(NSString *)url Error:(NSError *)error;
- (void)notifyImageStore:(PImageStore *)imageStore didCancelLoadImageForURL:(NSString *)url;
@end
@implementation PImageStore(Notify)

- (void)notifyImageStore:(PImageStore *)imageStore didFinishLoadImage:(UIImage *)image forURL:(NSString *)url {
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    if (imgInfo) {
        NSMutableSet *observers = [imgInfo objectForKey:kImageStoreObservers];
        for (id<PImageStoreDelegate>obv in [observers allObjects]) {
            if ([obv respondsToSelector:@selector(imageStore:didFinishLoadImage:forURL:)]) {
                [obv imageStore:imageStore didFinishLoadImage:image forURL:url];
            }
        }
        //  通知完成后，清空observer
        [imgInfo setObject:[NSMutableSet set] forKey:kImageStoreObservers];
    }
}
- (void)notifyImageStore:(PImageStore *)imageStore didStartLoadImageForURL:(NSString *)url {
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    if (imgInfo) {
        NSMutableSet *observers = [imgInfo objectForKey:kImageStoreObservers];
        for (id<PImageStoreDelegate>obv in [observers allObjects]) {
            if ([obv respondsToSelector:@selector(imageStore:didStartLoadImageForURL:)]) {
                [obv imageStore:imageStore didStartLoadImageForURL:url];
            }
        }
    }
}
- (void)notifyImageStore:(PImageStore *)imageStore didFailLoadImageForURL:(NSString *)url Error:(NSError *)error {
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    if (imgInfo) {
        NSMutableSet *observers = [imgInfo objectForKey:kImageStoreObservers];
        for (id<PImageStoreDelegate>obv in [observers allObjects]) {
            if ([obv respondsToSelector:@selector(ima)]) {
                [obv imageStore:imageStore didFailLoadImageForURL:url Error:error];
            }
        }
        //  通知完成后，清空observer
        [imgInfo setObject:[NSMutableSet set] forKey:kImageStoreObservers];
    }
}
- (void)notifyImageStore:(PImageStore *)imageStore didCancelLoadImageForURL:(NSString *)url {
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    if (imgInfo) {
        NSMutableSet *observers = [imgInfo objectForKey:kImageStoreObservers];
        for (id<PImageStoreDelegate>obv in [observers allObjects]) {
            if ([obv respondsToSelector:@selector(imageStore:didCancelLoadImageForURL:)]) {
                [obv imageStore:imageStore didCancelLoadImageForURL:url];
            }
        }
        //  通知完成后，清空observer
        [imgInfo setObject:[NSMutableSet set] forKey:kImageStoreObservers];
    }
}

@end

#pragma mark - ImageStore
@implementation PImageStore
@synthesize defaultImage, storedImageMaxNumber;
@synthesize imageStore, imageLoader;

#pragma mark init & dealloc
- (id)init {
    self = [super init];
    if (self) {
        self.storedImageMaxNumber = 50;
        
        self.imageStore = [NSMutableDictionary dictionary];
        SImageLoader *_loader = [[SImageLoader alloc] initWithDataLoaderDelegate:self];
        self.imageLoader = _loader;
        [_loader release];
    }
    return self;
}
- (void)dealloc {
    [self.imageLoader cancelAllRequests];
    self.imageLoader = nil;
    
    self.defaultImage = nil;
    self.imageStore = nil;
    [super dealloc];
}

#pragma mark image manager
- (UIImage *)resumeImageWithURL:(NSString *)url Observer:(id<PImageStoreDelegate>)observer {
    //  有效性判断
    if (!url || [url length] == 0 || [url isEqualToString:@""]) {
        return nil;
    }
    //  内存是否存在
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    UIImage *imgMemory = [imgInfo objectForKey:kImageStoreImage];
    if (imgMemory) {
        return imgMemory;
    }
    //  磁盘是否存在
    NSData *dataCache = [[ASIDownloadCache shareImageDownloadCache] cachedResponseDataForURL:[NSURL URLWithString:url]];
    if (dataCache) {
        UIImage *imgCache = [UIImage imageWithData:dataCache];
        [self addImage:imgCache WithURL:url];
        return imgCache;
    }
    //  自网络获取
    [self addObserver:observer forImageURL:url];
    [self loadImageWithURL:url];
    return self.defaultImage;
}
- (void)addObserver:(id<PImageStoreDelegate>)observer forImageURL:(NSString *)url {
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    if (!imgInfo) {
        imgInfo = [NSMutableDictionary dictionary];
        [self.imageStore setObject:imgInfo forKey:url];
    }
    NSMutableSet *observers = [imgInfo objectForKey:kImageStoreObservers];
    if (!observers) {
        observers = [NSMutableSet set];
        [imgInfo setObject:observers forKey:kImageStoreObservers];
    }
    [observers addObject:observer];
}
- (void)removeObserver:(id<PImageStoreDelegate>)observer {
    NSArray *_keys = [self.imageStore allKeys];
    for (NSString *_akey in _keys) {
        NSDictionary *_imgInfo = [self.imageStore objectForKey:_akey];
        NSMutableSet *_obsvrs = [_imgInfo objectForKey:kImageStoreObservers];
        [_obsvrs removeObject:observer];
    }
}
- (void)removeObserver:(id<PImageStoreDelegate>)observer forImageURL:(NSString *)url {
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    if (imgInfo) {
        NSMutableSet *observers = [imgInfo objectForKey:kImageStoreObservers];
        [observers removeObject:observer];
    }
}
- (void)addImage:(UIImage *)img WithURL:(NSString *)url {
    if (!img) {
        return;
    }
    if (self.storedImageMaxNumber > 0) {
        while ([[self.imageStore allKeys] count] > self.storedImageMaxNumber) {
            NSString *_storedURL = [[self.imageStore allKeys] lastObject];
            [self.imageStore removeObjectForKey:_storedURL];
        }
    }
    NSMutableDictionary *imgInfo = [self.imageStore objectForKey:url];
    if (!imgInfo) {
        imgInfo = [NSMutableDictionary dictionary];
        [self.imageStore setObject:imgInfo forKey:url];
    }
    [imgInfo setObject:img forKey:kImageStoreImage];
}
- (void)loadImageWithURL:(NSString *)url {
    [self.imageLoader loadImageWith:url];
}
- (void)receiveMemoryWarning {
    //  低内存时释放内存内的images
    self.imageStore = [NSMutableDictionary dictionary];
}

#pragma mark loader delegate
- (void)imageloader:(SImageLoader *)imageloader didStartRequest:(SURLRequest *)request {
    [self notifyImageStore:self didStartLoadImageForURL:[request.url absoluteString]];
}
- (void)imageloader:(SImageLoader *)imageloader didFinishLoadRequest:(SURLRequest *)request Image:(UIImage *)image {
    [self addImage:image WithURL:[request.url absoluteString]];
    [self notifyImageStore:self didFinishLoadImage:image forURL:[request.url absoluteString]];
}
- (void)imageloader:(SImageLoader *)imageloader didFailLoadRequest:(SURLRequest *)request Error:(NSError *)error {
    [self notifyImageStore:self didFailLoadImageForURL:[request.url absoluteString] Error:error];
}
- (void)imageloader:(SImageLoader *)imageloader didCancelRequest:(SURLRequest *)request {
    [self notifyImageStore:self didCancelLoadImageForURL:[request.url absoluteString]];
}

@end
