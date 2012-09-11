//
//  SDataLoader.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SDataLoader.h"

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
- (void)notifyDataloader:(SDataLoader *)dataloader submitResponse:(id)response Request:(SURLRequest *)request {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataloader:submitResponse:Request:)]) {
        [self.delegate dataloader:dataloader submitResponse:response Request:request];
    }
}

#pragma mark Request manager
- (void)cancelAllRequests {}
- (void)cancelRequest:(SURLRequest *)request {
    [request clearDelegatesAndCancel];
}
- (void)startRequest:(SURLRequest *)request {
    request.downloadCache = [ASIDownloadCache shareDocumentDownloadCache];
    [request startAsynchronous];
}
- (void)requestStarted:(ASIHTTPRequest *)request {
    [self notifyDataloader:self didStartRequest:(SURLRequest *)request];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    SURLRequest *srequest = [self prepareRequest:(SURLRequest *)request];
    if (!srequest.error) {
        [self notifyDataloader:self didFinishRequest:srequest];
    } else {
        [self notifyDataloader:self didFailRequest:srequest Error:srequest.error];
    }
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


#import "SUtil.h"
#import "JSONKit.h"
@implementation SDataLoader(Prepare)

- (SURLRequest *)prepareRequest:(SURLRequest *)request {
    id _fmdResponse = [request.responseString objectFromJSONString];
    NSString *_state = [_fmdResponse objectForKey:@"status"];
    if (_state) {
        if ([_state isEqualToString:@"success"]) {
            request.formatedResponse = [_fmdResponse objectForKey:@"value"];
        } else if ([_state isEqualToString:@"fail"]) {
            request.error = [SUtil errorWithCode:SErrorResponseParserFail];
        } else {
            request.error = [SUtil errorWithCode:SErrorResponseParserFail];
        }
    } else {
        request.error = [SUtil errorWithCode:SErrorResponseParserFail];
    }
    return request;
}

@end