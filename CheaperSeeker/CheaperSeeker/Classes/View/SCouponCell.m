//
//  SCouponCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponCell.h"

@interface SCouponCell()
@property (nonatomic, readonly) NSString *couponURLPath;
@property (nonatomic, assign) UIImageView *couponCover;
@property (nonatomic, assign) UILabel *couponTitle;
@property (nonatomic, assign) UILabel *couponContent;
@property (nonatomic, assign) UILabel *couponExpire;
- (void)reStyleWith:(SCouponStyle *)style;
- (void)reLayoutWith:(SCouponLayout *)layout;
- (void)reContent;
@end
@implementation SCouponCell
@synthesize coupon;
@synthesize couponURLPath;
@synthesize couponCover, couponContent, couponExpire, couponTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *_imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgv.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imgv];
        self.couponCover = _imgv;
        [_imgv release];
        
        UILabel *_ttl = [[UILabel alloc] initWithFrame:CGRectZero];
        _ttl.numberOfLines = 20;
        [self.contentView addSubview:_ttl];
        self.couponTitle = _ttl;
        [_ttl release];
        
        UILabel *_cnt = [[UILabel alloc] initWithFrame:CGRectZero];
        _cnt.numberOfLines = 20;
        [self.contentView addSubview:_cnt];
        self.couponContent = _cnt;
        [_cnt release];
        
        UILabel *_exp = [[UILabel alloc] initWithFrame:CGRectZero];
        _exp.numberOfLines = 20;
        [self.contentView addSubview:_exp];
        self.couponExpire = _exp;
        [_exp release];
    }
    return self;
}
- (void)dealloc {
    self.coupon = nil;
    [super dealloc];
}
+ (CGFloat)cellHeight {
    return 44.0;
}
- (NSString *)couponURLPath {
    return [self.coupon objectForKey:k_coupon_image];
}
- (void)refreshWithCoupon:(id)cpn Layout:(SCouponLayout *)layout Style:(SCouponStyle *)style {
    self.coupon = cpn;
    [self reStyleWith:style];
    [self reLayoutWith:layout];
    [self reContent];
}
- (void)reLayoutWith:(SCouponLayout *)layout {
    self.couponCover.frame = layout.icon;
    self.couponTitle.frame = layout.title;
    self.couponContent.frame = layout.content;
    self.couponExpire.frame = layout.expire;
}
- (void)reContent {
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.couponURLPath] delegate:self];
    self.couponTitle.text = [self.coupon objectForKey:k_coupon_title];
    self.couponContent.text = [self.coupon objectForKey:k_coupon_excerpt_description];
    self.couponExpire.text = [SUtil couponExpireDescription:[self.coupon objectForKey:k_coupon_expire_to]];
}
- (void)reStyleWith:(SCouponStyle *)style {
    self.couponTitle.font = style.titleFont;
    self.couponTitle.textColor = style.titleColor;
    self.couponContent.font = style.contentFont;
    self.couponContent.textColor = style.contentColor;
    self.couponExpire.font = style.expireFont;
    self.couponExpire.textColor = style.expireColor;
}

#pragma mark SDWebImageManager delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info {
    if ([[url absoluteString] isEqualToString:self.couponURLPath]) {
        self.couponCover.image = image;
    }
}

@end
