//
//  SLayout.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SLayout.h"

@implementation SLayout
@synthesize height;

- (id)init {
    self = [super init];
    if (self) {
        self.height = 0.0;
    }
    return self;
}

@end

@implementation SCouponLayout
@synthesize icon, title, content, expire;

- (void)layoutWithCoupon:(id)coupon Style:(SCouponStyle *)style {
    //  icon
    self.icon = CGRectMake(kMarginLeft, kMarginTop, 64, 64);
    self.height = self.icon.origin.y+self.icon.size.height+kMarginTop;
    //  title
    NSString *_ttl = [coupon objectForKey:k_coupon_title];
    if (![Util isEmptyString:_ttl]) {
        CGSize _size = [_ttl sizeWithFont:style.titleFont constrainedToSize:CGSizeMake([SUtil cellWidth]-self.icon.origin.x-self.icon.size.width-5-kMarginLeft, 1000) lineBreakMode:style.lineBreakMode];
        self.title = CGRectMake(self.icon.origin.x+self.icon.size.width+5, self.icon.origin.y, _size.width, _size.height);
    }
    CGFloat _tmpHeight = self.title.origin.y+self.title.size.height+kMarginTop;
    self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    //  content
    NSString *_cnt = [coupon objectForKey:k_coupon_excerpt_description];
    if (![Util isEmptyString:_cnt]) {
        CGSize _size = [_cnt sizeWithFont:style.contentFont constrainedToSize:CGSizeMake([SUtil cellWidth]-self.icon.origin.x-self.icon.size.width-5-kMarginLeft, 1000) lineBreakMode:style.lineBreakMode];
        CGFloat _y = self.title.size.height > 0 ? self.title.origin.y+self.title.size.height+5 : self.icon.origin.y;
        self.content = CGRectMake(self.icon.origin.x+self.icon.size.width+5, _y, _size.width, _size.height);
    }
    _tmpHeight = self.content.origin.y+self.content.size.height+kMarginTop;
    self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    //  expire
    if ([SUtil isCouponExpire:coupon]) {
        NSString *_exp = [SUtil couponExpireDescription:[coupon objectForKey:k_coupon_expire_to]];
        if (![Util isEmptyString:_exp]) {
            CGSize _size = [_exp sizeWithFont:style.expireFont forWidth:([SUtil cellWidth]-self.icon.origin.x-self.icon.size.width-5-kMarginLeft) lineBreakMode:style.lineBreakMode];
            CGFloat _y = self.icon.origin.y;
            if (self.content.size.height > 0) {
                _y = self.content.origin.y+self.content.size.height+5;
            } else if (self.title.size.height > 0) {
                _y = self.title.origin.y+self.title.size.height+5;
            }
            self.expire = CGRectMake(self.icon.origin.x+self.icon.size.width+5, _y, _size.width, _size.height);
        }
        _tmpHeight = self.expire.origin.y+self.expire.size.height+kMarginTop;
        self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    }
}

@end