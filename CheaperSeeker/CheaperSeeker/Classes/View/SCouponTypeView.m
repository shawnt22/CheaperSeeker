//
//  SCouponTypeView.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-27.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponTypeView.h"
#import "Util.h"
#import "SUtil.h"

@interface SCouponTypeView ()
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) UIColor *textColor;
- (void)fillBGWithContext:(CGContextRef)context Rect:(CGRect)rect Color:(UIColor *)color;
- (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect;
@end

@implementation SCouponTypeView
@synthesize text;
@synthesize lineColor, bgColor, textColor, textFont;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        
        self.lineColor = [UIColor whiteColor];
        self.bgColor = [UIColor blackColor];
        self.textColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:10];
    }
    return self;
}
- (void)dealloc {
    self.text = nil;
    self.lineColor = nil;
    self.bgColor = nil;
    self.textFont = nil;
    self.textColor = nil;
    [super dealloc];
}
- (void)refreshWithText:(NSString *)txt {
    self.text = txt;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    [self fillBGWithContext:context Rect:rect Color:self.lineColor];
    [self fillBGWithContext:context Rect:CGRectInset(rect, 1.0, 1.0) Color:self.bgColor];
    [self drawTextWithContext:context Rect:CGRectInset(rect, 1.0, 1.0)];
}
#define k_coupon_type_view_bg_radius 2.0
- (void)fillBGWithContext:(CGContextRef)context Rect:(CGRect)rect Color:(UIColor *)color {
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextMoveToPoint(context, rect.origin.x+rect.size.width/2, rect.origin.y);
    CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2, k_coupon_type_view_bg_radius);
    CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height, rect.origin.x+rect.size.width/2, rect.size.height+rect.origin.y, k_coupon_type_view_bg_radius);
    CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y+rect.size.height, rect.origin.x, rect.origin.y+rect.size.height/2, k_coupon_type_view_bg_radius);
    CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width/4, rect.origin.y, k_coupon_type_view_bg_radius);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}
- (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect {
    CGContextSaveGState(context);
    [self.textColor set];
    [self.text drawInRect:rect withFont:self.textFont lineBreakMode:[Util lineBreakMode:SLineBreakByTruncatingTail] alignment:[Util textAlignment:STextAlignmentCenter]];
    CGContextRestoreGState(context);
}

@end
