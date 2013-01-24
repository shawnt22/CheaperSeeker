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

@interface CSEmailMeLaterDataStore ()
@property (nonatomic, retain) SURLRequest *emailRequest;
@end
@implementation CSEmailMeLaterDataStore
@synthesize emailRequest;

- (void)dealloc {
    [super dealloc];
    self.emailRequest = nil;
}
- (void)cancelAllRequests {
    [super cancelAllRequests];
    [self cancelRequest:self.emailRequest];
}
- (void)postEmail:(NSString *)email CouponID:(NSString *)couponID {
    [self cancelRequest:self.emailRequest];
    
    SURLRequest *_request = [[SURLRequest alloc] initWithURL:[NSURL URLWithString:[SURLProxy postEmailAddress]]];
    _request.delegate = self;
    _request.tag = SURLRequestPostEmail;
    _request.cachePolicy = ASIDoNotReadFromCacheCachePolicy;
    
    _request.requestMethod = @"POST";
    [_request addRequestHeader:@"Platform" value:[Util platform]];
    [_request addPostValue:email forKey:@"email"];
    [_request addPostValue:[Util currentUUIDString] forKey:@"uuid"];
    [_request addPostValue:couponID forKey:@"c_id"];
    
    self.emailRequest = _request;
    [_request release];
    
    [self startRequest:self.emailRequest];
}

@end