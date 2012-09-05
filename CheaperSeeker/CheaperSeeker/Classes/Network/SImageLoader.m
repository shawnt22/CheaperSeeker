//
//  SImageLoader.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-5.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SImageLoader.h"

@interface SImageLoader()
@property (nonatomic, retain) NSMutableDictionary *requestSource;
@end

@interface SImageLoader(Notify)
- (void)notifyImageloader:(SImageLoader *)imageloader didFinishLoadRequest:(SURLRequest *)request Image:(UIImage *)image;
- (void)notifyImageloader:(SImageLoader *)imageloader didFailLoadRequest:(SURLRequest *)request Error:(NSError *)error;
- (void)notifyImageloader:(SImageLoader *)imageloader didCancelRequest:(SURLRequest *)request;
- (void)notifyImageloader:(SImageLoader *)imageloader didStartRequest:(SURLRequest *)request;
@end
@implementation SImageLoader(Notify)
- (void)notifyImageloader:(SImageLoader *)imageloader didFinishLoadRequest:(SURLRequest *)request Image:(UIImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageloader:didFinishLoadRequest:Image:)]) {
        [self.delegate imageloader:imageloader didFinishLoadRequest:request Image:image];
    }
}
- (void)notifyImageloader:(SImageLoader *)imageloader didFailLoadRequest:(SURLRequest *)request Error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageloader:didFailLoadRequest:Error:)]) {
        [self.delegate imageloader:imageloader didFailLoadRequest:request Error:error];
    }
}
- (void)notifyImageloader:(SImageLoader *)imageloader didCancelRequest:(SURLRequest *)request {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageloader:didCancelRequest:)]) {
        [self.delegate imageloader:imageloader didCancelRequest:request];
    }
}
- (void)notifyImageloader:(SImageLoader *)imageloader didStartRequest:(SURLRequest *)request {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageloader:didStartRequest:)]) {
        [self.delegate imageloader:imageloader didStartRequest:request];
    }
}
@end

#import "Util.h"
@implementation SImageLoader
@synthesize requestSource;
@synthesize delegate;

- (id)initWithDataLoaderDelegate:(id<SImageLoaderDelegate>)adelegate {
    self = [super init];
    if (self) {
        self.delegate = adelegate;
        self.requestSource = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)dealloc {
    self.requestSource = nil;
    [super dealloc];
}
- (void)cancelAllRequests {
    NSArray *requests = [self.requestSource allValues];
    for (SURLRequest *ar in requests) {
        [ar clearDelegatesAndCancel];
    }
}
- (void)loadImageWith:(NSString *)url {
    SURLRequest *request = [self.requestSource objectForKey:url];
    if (!request) {
        request = [[SURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        request.downloadCache = [ASIDownloadCache shareImageDownloadCache];
        request.cachePolicy = ASIUseDefaultCachePolicy;
        [self.requestSource setObject:request forKey:url];
        [request release];
    }
    if (!request.inProgress) {
        [request startAsynchronous];
    }
}
- (void)requestStarted:(ASIHTTPRequest *)request {
    [self notifyImageloader:self didStartRequest:(SURLRequest *)request];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    UIImage *_image = [UIImage imageWithData:request.responseData];
    [self notifyImageloader:self didFinishLoadRequest:(SURLRequest *)request Image:_image];
    [self.requestSource removeObjectForKey:[request.url absoluteString]];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    if ([error code] == ASIRequestCancelledErrorType) {
        [self notifyImageloader:self didCancelRequest:(SURLRequest *)request];
        [self.requestSource removeObjectForKey:[request.url absoluteString]];
    } else {
        [self notifyImageloader:self didFailLoadRequest:(SURLRequest *)request Error:error];
    }
}

@end
