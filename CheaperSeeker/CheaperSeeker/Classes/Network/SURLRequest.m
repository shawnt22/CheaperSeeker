//
//  SURLRequest.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SURLRequest.h"

@implementation SURLRequest
@synthesize responseResult;

- (void)dealloc {
    self.responseResult = nil;
    [super dealloc];
}

@end
