//
//  SCouponCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponCell.h"

@interface SCouponCell()
@property (nonatomic, assign)UIImageView *couponCover;
@property (nonatomic, readonly) NSString *couponURLPath;
@end
@implementation SCouponCell
@synthesize coupon;
@synthesize couponURLPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        TCustomCellBGView *_bg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
        _bg.lineColor = kCustomCellBGLineColor;
        _bg.fillColor = [UIColor viewFlipsideBackgroundColor];
        _bg.innerShadowColor = kCustomCellBGInnerShadowColor;
        _bg.innerShadowWidth = 1.0;
        self.backgroundView = _bg;
        [_bg release];
        TCustomCellBGView *_sbg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
        _sbg.lineColor = kCustomCellBGLineColor;
        _sbg.fillColor = kCustomCellSelectedBGFillColor;
        self.selectedBackgroundView = _sbg;
        [_sbg release];
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
    
    UIImage *_cvr = [self.imageStore resumeImageWithURL:self.couponURLPath Observer:self];
    self.couponCover.image = _cvr ? _cvr : [Util imageWithName:@""];
}
- (void)imageStore:(PImageStore *)imageStore didFinishLoadImage:(UIImage *)image forURL:(NSString *)url {
    if ([self.couponURLPath isEqualToString:url]) {
        self.couponCover.image = image ? image : [Util imageWithName:@""];
    }
}

@end
