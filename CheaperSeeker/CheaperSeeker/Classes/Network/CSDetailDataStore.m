//
//  CSDetailDataStore.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-11-20.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "CSDetailDataStore.h"

@interface CSAboutInfoDataStore ()
@property (nonatomic, retain) SURLRequest *aboutRequest;
@end
@implementation CSAboutInfoDataStore
@synthesize aboutRequest;

- (void)dealloc {
    [super dealloc];
    self.aboutRequest = nil;
}
- (void)cancelAllRequests {
    [super cancelAllRequests];
    [self cancelRequest:self.aboutRequest];
}
- (void)getAboutInfo:(ASICachePolicy)cachePolicy {
    [self cancelRequest:self.aboutRequest];
    
    SURLRequest *_request = [[SURLRequest alloc] initWithURL:[NSURL URLWithString:[SURLProxy getAboutInfo]]];
    _request.delegate = self;
    _request.tag = SURLRequestAboutInfo;
    _request.cachePolicy = cachePolicy;
    self.aboutRequest = _request;
    [_request release];
    
    [self startRequest:self.aboutRequest];
}

@end