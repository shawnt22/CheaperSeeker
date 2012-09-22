//
//  SStyle.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SStyle.h"

@implementation SStyle
@synthesize lineBreakMode;

- (id)init {
    self = [super init];
    if (self) {
        self.lineBreakMode = UILineBreakModeWordWrap;
    }
    return self;
}
- (void)dealloc {
    
    [super dealloc];
}

@end


@implementation SCouponStyle
@synthesize titleColor, titleFont, contentColor, contentFont, expireColor, expireFont;

- (id)init {
    self = [super init];
    if (self) {
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:18];
        self.contentColor = [UIColor grayColor];
        self.contentFont = [UIFont systemFontOfSize:12];
        self.expireColor = [UIColor redColor];
        self.expireFont = [UIFont systemFontOfSize:12];
    }
    return self;
}
- (void)dealloc {
    self.titleColor = nil;
    self.titleFont = nil;
    self.contentFont = nil;
    self.contentColor = nil;
    self.expireColor = nil;
    self.expireFont = nil;
    [super dealloc];
}

@end


@implementation SMerchantStyle
@synthesize titleColor, titleFont;

- (id)init {
    self = [super init];
    if (self) {
        self.titleFont = [UIFont systemFontOfSize:16];
        self.titleColor = [UIColor blackColor];
    }
    return self;
}
- (void)dealloc {
    self.titleColor = nil;
    self.titleFont = nil;
    [super dealloc];
}

@end


