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

@interface SCouponLayout ()
- (void)layoutOpenWithCoupon:(id)coupon Style:(SCouponStyle *)style;
@end
@implementation SCouponLayout
@synthesize icon, title, content, expire, type;
@synthesize icon_open, title_open, content_open, expire_open, type_open, height_open;

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
    //  type
    CGFloat _y = self.icon.origin.y;
    if (self.content.size.height > 0) {
        _y = self.content.origin.y+self.content.size.height+5;
    } else if (self.title.size.height > 0) {
        _y = self.title.origin.y+self.title.size.height+5;
    }
    self.type = CGRectMake(self.icon.origin.x+self.icon.size.width+5, _y, 40.0, 15.0);
    _tmpHeight = self.type.origin.y+self.type.size.height+kMarginTop;
    self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    //  expire
    if ([SUtil needShowExpireDescriptionWithCoupon:coupon]) {
        NSString *_exp = [SUtil couponExpireDescription:coupon];
        if (![Util isEmptyString:_exp]) {
            CGSize _size = [_exp sizeWithFont:style.expireFont forWidth:([SUtil cellWidth]-self.icon.origin.x-self.icon.size.width-5-kMarginLeft) lineBreakMode:style.lineBreakMode];
            self.expire = CGRectMake([SUtil cellWidth]-_size.width-kMarginLeft, self.type.origin.y, _size.width, _size.height);
        }
        _tmpHeight = self.expire.origin.y+self.expire.size.height+kMarginTop;
        self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    }
    
    [self layoutOpenWithCoupon:coupon Style:style];
}
- (void)layoutOpenWithCoupon:(id)coupon Style:(SCouponStyle *)style {
    //  icon
    self.icon_open = CGRectMake(kMarginLeft, kMarginTop, [SUtil cellWidth]-kMarginLeft*2, 128);
    self.height_open = self.icon_open.origin.y+self.icon_open.size.height+kMarginTop;
    //  title
    NSString *_ttl = [coupon objectForKey:k_coupon_title];
    if (![Util isEmptyString:_ttl]) {
        CGSize _size = [_ttl sizeWithFont:style.titleFont constrainedToSize:CGSizeMake([SUtil cellWidth]-kMarginLeft*2, 1000) lineBreakMode:style.lineBreakMode];
        self.title_open = CGRectMake(kMarginLeft, self.icon_open.origin.y+self.icon_open.size.height+5, _size.width, _size.height);
    }
    CGFloat _tmpHeight = self.title_open.origin.y+self.title_open.size.height+kMarginTop;
    self.height_open = _tmpHeight > self.height_open ? _tmpHeight : self.height_open;
    //  content
    NSString *_cnt = [coupon objectForKey:k_coupon_excerpt_description];
    if (![Util isEmptyString:_cnt]) {
        CGSize _size = [_cnt sizeWithFont:style.contentFont constrainedToSize:CGSizeMake([SUtil cellWidth]-kMarginLeft*2, 1000) lineBreakMode:style.lineBreakMode];
        CGFloat _y = self.title_open.size.height > 0 ? self.title_open.origin.y+self.title_open.size.height+5 : self.icon_open.origin.y+self.icon_open.size.height+5;
        self.content_open = CGRectMake(kMarginLeft, _y, _size.width, _size.height);
    }
    _tmpHeight = self.content_open.origin.y+self.content_open.size.height+kMarginTop;
    self.height_open = _tmpHeight > self.height_open ? _tmpHeight : self.height_open;
    //  type
    CGFloat _y = self.icon_open.origin.y+self.icon_open.size.height+5;
    if (self.content_open.size.height > 0) {
        _y = self.content_open.origin.y+self.content_open.size.height+5;
    } else if (self.title_open.size.height > 0) {
        _y = self.title_open.origin.y+self.title_open.size.height+5;
    }
    self.type_open = CGRectMake(kMarginLeft, _y, 40.0, 15.0);
    _tmpHeight = self.type_open.origin.y+self.type_open.size.height+kMarginTop;
    self.height_open = _tmpHeight > self.height_open ? _tmpHeight : self.height_open;
    //  expire
    if ([SUtil needShowExpireDescriptionWithCoupon:coupon]) {
        NSString *_exp = [SUtil couponExpireDescription:coupon];
        if (![Util isEmptyString:_exp]) {
            CGSize _size = [_exp sizeWithFont:style.expireFont forWidth:([SUtil cellWidth]-kMarginLeft*2) lineBreakMode:style.lineBreakMode];
            self.expire_open = CGRectMake([SUtil cellWidth]-_size.width-kMarginLeft, self.type_open.origin.y, _size.width, _size.height);
        }
        _tmpHeight = self.expire_open.origin.y+self.expire_open.size.height+kMarginTop;
        self.height_open = _tmpHeight > self.height_open ? _tmpHeight : self.height_open;
    }
}

@end


@implementation SMerchantLayout
@synthesize banner, title;

- (void)layoutWithMerchant:(id)merchant Style:(SMerchantStyle *)style {
    //  banner
    self.banner = CGRectMake(0, 0, [SUtil cellWidth], MerchantLayoutBannerHeight);
    self.height = self.banner.origin.y + self.banner.size.height;
    //  title
    self.title = CGRectMake(self.banner.origin.x, (self.banner.size.height-24.0), self.banner.size.width, 24.0);
}

@end


