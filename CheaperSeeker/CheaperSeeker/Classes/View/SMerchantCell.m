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
- (void)reContent;
@end
@implementation SMerchantCell
@synthesize merchant;
@synthesize merchantBanner;
@synthesize customBackgroundView, customSelectedBackgroundView;

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
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[self.merchant objectForKey:k_merchant_banner_image]] delegate:self];
}

#pragma mark SDWebImageManager delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info {
    if ([[url absoluteString] isEqualToString:[self.merchant objectForKey:k_merchant_banner_image]]) {
        self.merchantBanner.image = image;
    }
}

@end
