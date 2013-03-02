//
//  SStyle.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SStyle.h"
#import "Util.h"

@implementation SStyle
@synthesize lineBreakMode;

- (id)init {
    self = [super init];
    if (self) {
        self.lineBreakMode = [Util lineBreakMode:SLineBreakByWordWrapping];
    }
    return self;
}
- (void)dealloc {
    
    [super dealloc];
}

@end

@interface SCouponStyle ()
@end
@implementation SCouponStyle
@synthesize titleColor, titleFont, contentColor, contentFont, expireFont;
@synthesize didExpireColor, unExpireColor;

- (id)init {
    self = [super init];
    if (self) {
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:18];
        self.contentColor = [UIColor grayColor];
        self.contentFont = [UIFont systemFontOfSize:12];
        self.didExpireColor = [UIColor redColor];
        self.unExpireColor = [UIColor orangeColor];
        self.expireFont = [UIFont systemFontOfSize:12];
    }
    return self;
}
- (void)dealloc {
    self.didExpireColor = nil;
    self.unExpireColor = nil;
    self.titleColor = nil;
    self.titleFont = nil;
    self.contentFont = nil;
    self.contentColor = nil;
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
        self.titleColor = [UIColor whiteColor];
    }
    return self;
}
- (void)dealloc {
    self.titleColor = nil;
    self.titleFont = nil;
    [super dealloc];
}

@end


@implementation SCouponCardStyle
@synthesize keyColor, titleColor, titleFont, canDoColor, canDoFont;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc {
    self.keyColor = nil;
    self.titleFont = nil;
    self.titleColor = nil;
    self.canDoFont = nil;
    self.canDoColor = nil;
    [super dealloc];
}

@end
