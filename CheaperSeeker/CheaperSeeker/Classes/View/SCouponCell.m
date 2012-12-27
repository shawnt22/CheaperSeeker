//
//  SCouponCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponCell.h"
#import "SCouponTypeView.h"

@interface SCouponCell()
@property (nonatomic, readonly) NSString *couponURLPath;
@property (nonatomic, assign) UIImageView *couponCover;
@property (nonatomic, assign) UILabel *couponTitle;
@property (nonatomic, assign) UILabel *couponContent;
@property (nonatomic, assign) UILabel *couponExpire;
@property (nonatomic, assign) SCouponTypeView *couponType;
@property (nonatomic, retain) SCouponLayout *couponLayout;
@property (nonatomic, retain) SCouponStyle *couponStyle;
- (void)reStyleWith:(SCouponStyle *)style;
- (void)reLayoutWith:(SCouponLayout *)layout;
- (void)reContent;
@end
@implementation SCouponCell
@synthesize coupon, couponLayout, couponStyle;
@synthesize couponURLPath;
@synthesize couponCover, couponContent, couponExpire, couponTitle, couponType;
@synthesize customBackgroundView, customSelectedBackgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [SUtil setCustomCellBGView:self];
        
        UIColor *_bgcolor = kCustomCellBGFillColor;
        
        UIImageView *_imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgv.backgroundColor = _bgcolor;
        _imgv.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgv];
        self.couponCover = _imgv;
        [_imgv release];
        
        UILabel *_ttl = [[UILabel alloc] initWithFrame:CGRectZero];
        _ttl.backgroundColor = _bgcolor;
        _ttl.numberOfLines = 20;
        [self.contentView addSubview:_ttl];
        self.couponTitle = _ttl;
        [_ttl release];
        
        UILabel *_cnt = [[UILabel alloc] initWithFrame:CGRectZero];
        _cnt.backgroundColor = _bgcolor;
        _cnt.numberOfLines = 20;
        [self.contentView addSubview:_cnt];
        self.couponContent = _cnt;
        [_cnt release];
        
        UILabel *_exp = [[UILabel alloc] initWithFrame:CGRectZero];
        _exp.backgroundColor = _bgcolor;
        _exp.numberOfLines = 20;
        [self.contentView addSubview:_exp];
        self.couponExpire = _exp;
        [_exp release];
        
        SCouponTypeView *_tpv = [[SCouponTypeView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_tpv];
        self.couponType = _tpv;
        [_tpv release];
    }
    return self;
}
- (void)dealloc {
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
    self.coupon = nil;
    self.couponLayout = nil;
    self.couponStyle = nil;
    [super dealloc];
}
- (TCustomCellBGView *)customBackgroundView {
    return [self.backgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.backgroundView : nil;
}
- (TCustomCellBGView *)customSelectedBackgroundView {
    return [self.selectedBackgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.selectedBackgroundView : nil;
}
+ (CGFloat)cellHeight {
    return 44.0;
}
- (NSString *)couponURLPath {
    NSString *resutl = nil;
    resutl = [self.coupon objectForKey:k_coupon_image];
    if ([Util isEmptyString:resutl]) {
        resutl = [[self.coupon objectForKey:k_coupon_merchant] objectForKey:k_merchant_banner_image];
    }
    return resutl;
}
- (void)refreshWithCoupon:(id)cpn Layout:(SCouponLayout *)layout Style:(SCouponStyle *)style {
    self.coupon = cpn;
    self.couponLayout = layout;
    self.couponStyle = style;
    [self reStyleWith:style];
    [self reLayoutWith:layout];
    [self reContent];
}
- (void)reLayoutWith:(SCouponLayout *)layout {
    self.couponCover.frame = layout.icon;
    self.couponTitle.frame = layout.title;
    self.couponContent.frame = layout.content;
    self.couponExpire.frame = layout.expire;
    self.couponType.frame = layout.type;
}
- (void)reContent {
    self.couponCover.image = nil;
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.couponURLPath] delegate:self];
    self.couponTitle.text = [self.coupon objectForKey:k_coupon_title];
    self.couponContent.text = [self.coupon objectForKey:k_coupon_excerpt_description];
    self.couponExpire.text = [SUtil couponExpireDescription:self.coupon];
    self.couponType.text = [SUtil descriptionWithCouponType:[SUtil couponType:self.coupon]];
}
- (void)reStyleWith:(SCouponStyle *)style {
    self.couponTitle.font = style.titleFont;
    self.couponTitle.textColor = style.titleColor;
    self.couponContent.font = style.contentFont;
    self.couponContent.textColor = style.contentColor;
    self.couponExpire.font = style.expireFont;
    self.couponExpire.textColor = [SUtil isCouponExpire:self.coupon] ? style.didExpireColor : style.unExpireColor;
}

#pragma mark SDWebImageManager delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info {
    if ([[url absoluteString] isEqualToString:self.couponURLPath]) {
        self.couponCover.image = image;
    }
}

@end


@implementation SCouponCell (OpenClose)

- (void)openWithAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:k_coupons_table_cell_animation_duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.couponCover.frame = self.couponLayout.icon_open;
                             self.couponTitle.frame = self.couponLayout.title_open;
                             self.couponContent.frame = self.couponLayout.content_open;
                             self.couponExpire.frame = self.couponLayout.expire_open;
                             self.couponType.frame = self.couponLayout.type_open;
                         }
                         completion:^(BOOL finished){
                             [self finishOpenAnimation:animated];
                         }];
    } else {
        self.couponCover.frame = self.couponLayout.icon_open;
        self.couponTitle.frame = self.couponLayout.title_open;
        self.couponContent.frame = self.couponLayout.content_open;
        self.couponExpire.frame = self.couponLayout.expire_open;
        self.couponType.frame = self.couponLayout.type_open;
        [self finishOpenAnimation:animated];
    }
}
- (void)closeWithAnimated:(BOOL)animated {
    SCouponLayout *layout = self.couponLayout;
    if (animated) {
        [UIView animateWithDuration:k_coupons_table_cell_animation_duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.couponCover.frame = layout.icon;
                             self.couponTitle.frame = layout.title;
                             self.couponContent.frame = layout.content;
                             self.couponExpire.frame = layout.expire;
                             self.couponType.frame = layout.type;
                         }
                         completion:^(BOOL finished){
                             [self finishCloseAnimation:animated];
                         }];
    } else {
        self.couponCover.frame = layout.icon;
        self.couponTitle.frame = layout.title;
        self.couponContent.frame = layout.content;
        self.couponExpire.frame = layout.expire;
        self.couponType.frame = layout.type;
        [self finishCloseAnimation:animated];
    }
}
- (void)finishOpenAnimation:(BOOL)animated {}
- (void)finishCloseAnimation:(BOOL)animated {}

@end