//
//  SDataLoaderDelegate.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

@class SDataLoader, SURLRequest;
@protocol SDataLoaderDelegate <NSObject>

@optional
- (void)dataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request;
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request;
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error;
- (void)dataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request;

@end
