//
//  SDataLoader.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SDataLoader.h"
#import "JSONKit.h"

@interface SDataLoader()

@end

@interface SDataLoader(Notify)
- (void)notifyDataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request;
- (void)notifyDataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request;
@end
@implementation SDataLoader(Notify)
- (void)notifyDataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataloader:didStartRequest:)]) {
        [self.delegate dataloader:dataloader didStartRequest:request];
    }
}
- (void)notifyDataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataloader:didCancelRequest:)]) {
        [self.delegate dataloader:dataloader didCancelRequest:request];
    }
}
@end

@implementation SDataLoader
@synthesize delegate;

#pragma mark init & dealloc
- (id)initWithDelegate:(id<SDataLoaderDelegate>)adelegate {
    self = [super init];
    if (self) {
        self.delegate = adelegate;
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}
- (void)notifyDataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataloader:didFinishRequest:)]) {
        [self.delegate dataloader:dataloader didFinishRequest:request];
    }
}
- (void)notifyDataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataloader:didFailRequest:Error:)]) {
        [self.delegate dataloader:dataloader didFailRequest:request Error:error];
    }
}

#pragma mark Request manager
- (void)cancelAllRequests {}
- (void)cancelRequest:(SURLRequest *)request {
    [request clearDelegatesAndCancel];
}
- (void)startRequest:(SURLRequest *)request {
    [request startAsynchronous];
}
- (void)requestStarted:(ASIHTTPRequest *)request {
    [self notifyDataloader:self didStartRequest:(SURLRequest *)request];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
#warning need logic
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    if ([error code] == ASIRequestCancelledErrorType) {
        [self notifyDataloader:self didCancelRequest:(SURLRequest *)request];
        return;
    }
    [self notifyDataloader:self didFailRequest:(SURLRequest *)request Error:error];
}
- (BOOL)parseRequest:(SURLRequest *)request Response:(id)response {
    BOOL result = YES;
    return result;
}

@end
