//
//  SCouponCardView.m
//  CheaperSeeker
//
//  Created by 滕 松 on 13-3-2.
//  Copyright (c) 2013年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponCardView.h"

@implementation SCouponCardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef _context = UIGraphicsGetCurrentContext();
    CGContextClearRect(_context, rect);
    
    
}

#pragma mark layout
- (void)relayoutWithAnimated:(BOOL)animated isOpen:(BOOL)isOpen {
    
}

@end
