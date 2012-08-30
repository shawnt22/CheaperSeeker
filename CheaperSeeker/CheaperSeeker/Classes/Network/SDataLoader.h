//
//  SDataLoader.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SConfiger.h"
#import "SURLProxy.h"
#import "SDefine.h"
#import "SDataLoaderDelegate.h"
#import "SURLRequest.h"

@interface SDataLoader : NSObject<ASIHTTPRequestDelegate> {
@private
    
}
@property (nonatomic, assign) id<SDataLoaderDelegate> delegate;

- (id)initWithDelegate:(id<SDataLoaderDelegate>)adelegate;
- (void)startRequest:(SURLRequest *)request;
- (void)cancelRequest:(SURLRequest *)request;
- (void)cancelAllRequests;

- (BOOL)parseRequest:(SURLRequest *)request Response:(id)response;

- (void)notifyDataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request;
- (void)notifyDataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error;

@end
