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

#import "SCouponCell.h"
@interface SCouponLayout ()
- (void)layoutOpenWithCoupon:(id)coupon Style:(SCouponStyle *)style;
@end
@implementation SCouponLayout
@synthesize icon, title, content, expire, type;
@synthesize card, can_do, cannt_do, comment;
@synthesize icon_open, title_open, content_open, expire_open, type_open, height_open;
@synthesize card_open, can_do_open, cannt_do_open, comment_open;

- (void)layoutWithCoupon:(id)coupon Style:(SCouponStyle *)style {
    //  card
    CGRect _card_view = CGRectMake(kMarginLeft, kMarginTop, 66, 66);
    CGRect _f = CGRectInset(_card_view, 1, 1);
    _f.size.height = 46;
    self.icon = _f;
    CGFloat _card_ttl_h = _card_view.size.height - self.icon.size.height - 1;
    CGRect _card_title = CGRectMake(0, _card_view.size.height - _card_ttl_h, _card_view.size.width, _card_ttl_h);
    self.card = CouponCardLayoutMake(_card_title, _card_view);
    
    self.height = self.card.view.origin.y+self.card.view.size.height+kMarginTop;
    //  title
    NSString *_ttl = [coupon objectForKey:k_coupon_title];
    if (![Util isEmptyString:_ttl]) {
        CGSize _size = [_ttl sizeWithFont:style.titleFont constrainedToSize:CGSizeMake([SUtil cellWidth]-self.card.view.origin.x-self.card.view.size.width-5-kMarginLeft, 40) lineBreakMode:style.lineBreakMode];     //  title 默认最多显示2行
        self.title = CGRectMake(self.card.view.origin.x+self.card.view.size.width+5, self.card.view.origin.y, _size.width, _size.height);
    }
    CGFloat _tmpHeight = self.title.origin.y+self.title.size.height+kMarginTop;
    self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    //  content
    NSString *_cnt = [coupon objectForKey:k_coupon_excerpt_description];
    if (![Util isEmptyString:_cnt]) {
        CGSize _size = [_cnt sizeWithFont:style.contentFont constrainedToSize:CGSizeMake([SUtil cellWidth]-self.card.view.origin.x-self.card.view.size.width-5-kMarginLeft, 30) lineBreakMode:style.lineBreakMode];   //  content 默认最多显示2行
        CGFloat _y = self.title.size.height > 0 ? self.title.origin.y+self.title.size.height+5 : self.icon.origin.y;
        self.content = CGRectMake(self.card.view.origin.x+self.card.view.size.width+5, _y, _size.width, _size.height);
    }
    _tmpHeight = self.content.origin.y+self.content.size.height+kMarginTop;
    self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    
    //  type
    CGFloat _y = self.card.view.origin.y;
    if (self.content.size.height > 0) {
        _y = self.content.origin.y+self.content.size.height+5;
    } else if (self.title.size.height > 0) {
        _y = self.title.origin.y+self.title.size.height+5;
    }
    self.type = CGRectMake(self.card.view.origin.x+self.card.view.size.width+5, _y, [SCouponTypeView normalWidth], [SCouponTypeView normalHeight]);
    _tmpHeight = self.type.origin.y+self.type.size.height+kMarginTop;
    self.height = _tmpHeight > self.height ? _tmpHeight : self.height;
    
    //  can|cannt do
    self.can_do = [SCouponCanDoView layoutWithNumber:[SUtil couponCanDoNumString:coupon]];
    CGRect _can_do_view = CGRectMake(self.type.origin.x+self.type.size.width+2, self.type.origin.y, self.can_do.view.size.width, self.can_do.view.size.height);
    self.can_do = CanDoViewLayoutUpdateView(self.can_do, _can_do_view);
    self.cannt_do = [SCouponCanDoView layoutWithNumber:[SUtil couponCanntDoNumString:coupon]];
    _can_do_view = CGRectMake(self.can_do.view.origin.x+self.can_do.view.size.width+2, self.type.origin.y, self.cannt_do.view.size.width, self.cannt_do.view.size.height);
    self.cannt_do = CanDoViewLayoutUpdateView(self.cannt_do, _can_do_view);
    
    //  comment
    self.comment = [SCouponCanDoView layoutWithNumber:[SUtil couponCommentNumString:coupon]];
    CGRect _cmt = CGRectMake(self.cannt_do.view.origin.x+self.cannt_do.view.size.width+2, self.cannt_do.view.origin.y, 0, 0);
    self.comment = CanDoViewLayoutUpdateView(self.comment, _cmt);
    
    //  expire
    if ([SUtil needShowExpireDescriptionWithCoupon:coupon]) {
        NSString *_exp = [SUtil couponExpireDescription:coupon];
        if (![Util isEmptyString:_exp]) {
            CGSize _size = [_exp sizeWithFont:style.expireFont forWidth:([SUtil cellWidth]-self.cannt_do.view.origin.x-self.cannt_do.view.size.width-3-kMarginLeft) lineBreakMode:style.lineBreakMode];
            self.expire = CGRectMake(self.cannt_do.view.origin.x+self.cannt_do.view.size.width+3, self.type.origin.y, _size.width, _size.height);
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
        CGSize _size = [_ttl sizeWithFont:style.titleFont constrainedToSize:CGSizeMake([SUtil cellWidth]-kMarginLeft*2, 200) lineBreakMode:style.lineBreakMode];
        self.title_open = CGRectMake(kMarginLeft, self.icon_open.origin.y+self.icon_open.size.height+5, _size.width, _size.height);
    }
    CGFloat _tmpHeight = self.title_open.origin.y+self.title_open.size.height+kMarginTop;
    self.height_open = _tmpHeight > self.height_open ? _tmpHeight : self.height_open;
    
    //  type
    CGFloat _y = self.icon_open.origin.y+self.icon_open.size.height+5;
    if (self.title_open.size.height > 0) {
        _y = self.title_open.origin.y+self.title_open.size.height+5;
    }
    self.type_open = CGRectMake(kMarginLeft, _y, [SCouponTypeView normalWidth], [SCouponTypeView normalHeight]);
    
    //  can|cannt do
    CGRect _can_do_view = CGRectMake(self.type_open.origin.x+self.type_open.size.width+3, self.type_open.origin.y, self.can_do.view.size.width, self.can_do.view.size.height);
    self.can_do_open = CanDoViewLayoutUpdateView(self.can_do, _can_do_view);
    
    _can_do_view = CGRectMake(self.can_do_open.view.size.width+self.can_do_open.view.origin.x+3, self.type_open.origin.y, self.cannt_do.view.size.width, self.cannt_do.view.size.height);
    self.cannt_do_open = CanDoViewLayoutUpdateView(self.cannt_do, _can_do_view);
    
    //  comment
    self.comment_open = [SCouponCanDoView layoutWithNumber:[SUtil couponCommentNumString:coupon]];
    CGRect _cmmt_view = CGRectMake(self.cannt_do_open.view.origin.x+self.cannt_do_open.view.size.width+2, self.type_open.origin.y, self.comment_open.view.size.width, self.comment_open.view.size.height);
    self.comment_open = CanDoViewLayoutUpdateView(self.comment_open, _cmmt_view);
    
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
    
    //  content
    NSString *_cnt = [coupon objectForKey:k_coupon_excerpt_description];
    if (![Util isEmptyString:_cnt]) {
        CGSize _size = [_cnt sizeWithFont:style.contentFont constrainedToSize:CGSizeMake([SUtil cellWidth]-kMarginLeft*2, 1000) lineBreakMode:style.lineBreakMode];
        CGFloat _y = self.type_open.origin.y+self.type_open.size.height+5;
        CGFloat _delta = [UIScreen mainScreen].bounds.size.height - 44 - 20 - k_coupon_cell_tool_bar_height - (_y + _size.height);
        _size.height = _delta < 0 ? _size.height + _delta : _size.height;
        self.content_open = CGRectMake(kMarginLeft, _y, _size.width, _size.height);
    }
    _tmpHeight = self.content_open.origin.y+self.content_open.size.height+kMarginTop;
    self.height_open = _tmpHeight > self.height_open ? _tmpHeight : self.height_open;
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

