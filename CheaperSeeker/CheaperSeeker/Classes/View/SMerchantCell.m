//
//  SMerchantCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-22.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SMerchantCell.h"

@interface SMerchantCell()
@property (nonatomic, assign) UIImageView *merchantBanner;
@property (nonatomic, assign) UILabel *merchantTitleLabel;
- (void)reContent;
@end
@implementation SMerchantCell
@synthesize merchant;
@synthesize merchantBanner;
@synthesize customBackgroundView, customSelectedBackgroundView;
@synthesize merchantTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [SUtil setCustomCellBGView:self];
        
        UIImageView *_banner = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop, self.contentView.bounds.size.width-kMarginLeft*2, self.contentView.bounds.size.height-kMarginTop*2)];
        _banner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _banner.backgroundColor = kCustomCellBGFillColor;
        _banner.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_banner];
        self.merchantBanner  =_banner;
        [_banner release];
        
        CGFloat _height = 20;
        UILabel *_lbl = [[UILabel alloc] initWithFrame:CGRectMake(_banner.frame.origin.x, self.contentView.bounds.size.height-kMarginTop-_height, _banner.frame.size.width, _height)];
        _lbl.backgroundColor = [UIColor clearColor];
        _lbl.textColor = SRGBCOLOR(118, 118, 118);
        _lbl.shadowColor = SRGBCOLOR(242, 242, 242);
        _lbl.shadowOffset = CGSizeMake(1.0, -1.0);
        _lbl.textAlignment = UITextAlignmentCenter;
        _lbl.font = [UIFont boldSystemFontOfSize:16];
        _lbl.numberOfLines = 1;
        _lbl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_lbl];
        self.merchantTitleLabel = _lbl;
        [_lbl release];
    }
    return self;
}
- (void)dealloc {
    self.merchant = nil;
    [super dealloc];
}
- (TCustomCellBGView *)customBackgroundView {
    return [self.backgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.backgroundView : nil;
}
- (TCustomCellBGView *)customSelectedBackgroundView {
    return [self.selectedBackgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.selectedBackgroundView : nil;
}
+ (CGFloat)cellHeight {
    return MerchantLayoutBannerHeight;
}
- (void)refreshWithMerchant:(id)mchant Layout:(SMerchantLayout *)layout Style:(SMerchantStyle *)style {
    self.merchant = mchant;
    [self reContent];
}
- (void)reContent {
    self.merchantBanner.image = nil;
    self.merchantTitleLabel.hidden = NO;
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[self.merchant objectForKey:k_merchant_banner_image]] delegate:self];
    
    self.merchantTitleLabel.text = [self.merchant objectForKey:k_merchant_name];
}

#pragma mark SDWebImageManager delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info {
    if ([[url absoluteString] isEqualToString:[self.merchant objectForKey:k_merchant_banner_image]]) {
        self.merchantBanner.image = image;
        self.merchantTitleLabel.hidden = YES;
    }
}

@end
