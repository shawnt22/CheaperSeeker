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
@synthesize cardStyle;

- (id)init {
    self = [super init];
    if (self) {
        self.titleColor = SRGBCOLOR(36, 115, 196);
        self.titleFont = [UIFont systemFontOfSize:18];
        self.contentColor = SRGBCOLOR(68, 67, 94);
        self.contentFont = [UIFont systemFontOfSize:12];
        self.didExpireColor = [UIColor redColor];
        self.unExpireColor = [UIColor orangeColor];
        self.expireFont = [UIFont systemFontOfSize:12];
        
        SCouponCardStyle *_cds = [[SCouponCardStyle alloc] init];
        self.cardStyle = _cds;
        [_cds release];
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
    self.cardStyle = nil;
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


#import "Sconfiger.h"
@implementation SCouponCardStyle
@synthesize keyColor, coverBGColor, titleColor, titleFont;

- (id)init {
    self = [super init];
    if (self) {
        self.keyColor = SRGBCOLOR(243, 120, 43);
//        self.keyColor = SRGBCOLOR(96, 166, 241);
        self.coverBGColor = [UIColor whiteColor];
        self.titleFont = [UIFont boldSystemFontOfSize:12];
        self.titleColor = [UIColor whiteColor];
    }
    return self;
}
- (void)dealloc {
    self.keyColor = nil;
    self.coverBGColor = nil;
    self.titleFont = nil;
    self.titleColor = nil;
    [super dealloc];
}

@end
