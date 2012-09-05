//
//  SImageLoader.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-5.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SURLRequest.h"

@class SImageLoader;
@protocol SImageLoaderDelegate <NSObject>
@optional
- (void)imageloader:(SImageLoader *)imageloader didFinishLoadRequest:(SURLRequest *)request Image:(UIImage *)image;
- (void)imageloader:(SImageLoader *)imageloader didFailLoadRequest:(SURLRequest *)request Error:(NSError *)error;
- (void)imageloader:(SImageLoader *)imageloader didCancelRequest:(SURLRequest *)request;
- (void)imageloader:(SImageLoader *)imageloader didStartRequest:(SURLRequest *)request;
@end

@interface SImageLoader : NSObject<ASIHTTPRequestDelegate> {
}
@property (nonatomic, assign) id<SImageLoaderDelegate> delegate;

- (id)initWithDataLoaderDelegate:(id<SImageLoaderDelegate>)delegate;
- (void)loadImageWith:(NSString *)url;
- (void)cancelAllRequests;

@end
