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
@property (nonatomic, assign) UILabel *merchantTitle;
- (void)reStyleWith:(SMerchantStyle *)style;
- (void)reLayoutWith:(SMerchantLayout *)layout;
- (void)reContent;
@end
@implementation SMerchantCell
@synthesize merchant;
@synthesize merchantBanner, merchantTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *_banner = [[UIImageView alloc] initWithFrame:CGRectZero];
        _banner.backgroundColor = [UIColor whiteColor];
        _banner.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_banner];
        self.merchantBanner  =_banner;
        [_banner release];
        
        UILabel *_ttl = [[UILabel alloc] initWithFrame:CGRectZero];
        _ttl.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_ttl];
        self.merchantTitle = _ttl;
        [_ttl release];
    }
    return self;
}
- (void)dealloc {
    self.merchant = nil;
    [super dealloc];
}
+ (CGFloat)cellHeight {
    return MerchantLayoutBannerHeight;
}
- (void)refreshWithMerchant:(id)mchant Layout:(SMerchantLayout *)layout Style:(SMerchantStyle *)style {
    self.merchant = mchant;
    [self reStyleWith:style];
    [self reLayoutWith:layout];
    [self reContent];
}
- (void)reStyleWith:(SMerchantStyle *)style {
    self.merchantTitle.font = style.titleFont;
    self.merchantTitle.textColor = style.titleColor;
}
- (void)reLayoutWith:(SMerchantLayout *)layout {
    self.merchantBanner.frame = layout.banner;
    self.merchantTitle.frame = layout.title;
}
- (void)reContent {
    self.merchantBanner.image = nil;
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[self.merchant objectForKey:k_merchant_banner_image]] delegate:self];
    self.merchantTitle.text = [self.merchant objectForKey:k_merchant_name];
}

#pragma mark SDWebImageManager delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info {
    if ([[url absoluteString] isEqualToString:[self.merchant objectForKey:k_merchant_banner_image]]) {
        self.merchantBanner.image = image;
    }
}

@end
