//
//  SCouponCodeContentView.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-11-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponCodeContentView.h"
#import "SDefine.h"
#import <QuartzCore/QuartzCore.h>

@interface SCouponCodeContentView ()
@property (nonatomic, assign) UILabel *codeLabel;
@end
@implementation SCouponCodeContentView
@synthesize codeLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SRGBACOLOR(0, 0, 0, 0.5);
        self.layer.shadowColor = SRGBCOLOR(0, 0, 0).CGColor;
        self.layer.shadowOpacity = 0.7;
        
        UILabel *_lbl = [[UILabel alloc] initWithFrame:self.bounds];
        _lbl.backgroundColor = [UIColor clearColor];
        _lbl.textColor = [UIColor whiteColor];
        _lbl.font = [UIFont boldSystemFontOfSize:14];
        _lbl.textAlignment = UITextAlignmentCenter;
        [self addSubview:_lbl];
        self.codeLabel = _lbl;
        [_lbl release];
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}
- (void)refreshContentViewWithCoupon:(id)coupon {
    self.codeLabel.text = [coupon objectForKey:k_coupon_code];
}

@end
