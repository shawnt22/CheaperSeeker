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
+ (void)fillBGWithContext:(CGContextRef)context Rect:(CGRect)rect Color:(UIColor *)color Radius:(CGFloat)radius;
- (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect;
+ (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect Text:(NSString *)text Color:(UIColor *)color Font:(UIFont *)font LineBreakMode:(NSInteger)mode Alignment:(NSInteger)alignment;
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
    [SCouponTypeView fillBGWithContext:context Rect:rect Color:color Radius:k_coupon_type_view_bg_radius];
}
+ (void)fillBGWithContext:(CGContextRef)context Rect:(CGRect)rect Color:(UIColor *)color Radius:(CGFloat)radius {
    if (!color) {
        return;
    }
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextMoveToPoint(context, rect.origin.x+rect.size.width/2, rect.origin.y);
    CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2, radius);
    CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height, rect.origin.x+rect.size.width/2, rect.size.height+rect.origin.y, radius);
    CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y+rect.size.height, rect.origin.x, rect.origin.y+rect.size.height/2, radius);
    CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width/4, rect.origin.y, radius);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}
- (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect {
    [SCouponTypeView drawTextWithContext:context Rect:rect Text:self.text Color:self.textColor Font:self.textFont LineBreakMode:[Util lineBreakMode:SLineBreakByTruncatingTail] Alignment:[Util textAlignment:STextAlignmentCenter]];
}
+ (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect Text:(NSString *)text Color:(UIColor *)color Font:(UIFont *)font LineBreakMode:(NSInteger)mode Alignment:(NSInteger)alignment {
    if ([Util isEmptyString:text]) {
        return;
    }
    CGContextSaveGState(context);
    [color set];
    [text drawInRect:rect withFont:font lineBreakMode:mode alignment:alignment];
    CGContextRestoreGState(context);
}

@end


#import "UIImage_Additions.h"
@interface SButton ()
@property (nonatomic, retain) NSMutableDictionary *resourceStore;
- (void)drawShineWithContext:(CGContextRef)context Rect:(CGRect)rect Radius:(CGFloat)radius;
- (void)drawImageWithContext:(CGContextRef)context Rect:(CGRect)rect Image:(UIImage *)image;
@end
#define k_action_button_title       @"title"
#define k_action_button_ttl_color   @"ttlcolor"
#define k_action_button_bgimage     @"bgimg"
#define k_action_button_bgcolor     @"bgclr"
@implementation SButton
@synthesize resourceStore;
@synthesize textFont, lineColor;
@synthesize radius;
@synthesize buttonState;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.resourceStore = [NSMutableDictionary dictionary];
        self.buttonState = UIControlStateNormal;
        
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        
        self.lineColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:18];
        self.radius = 5.0;
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
- (void)dealloc {
    self.lineColor = nil;
    self.textFont = nil;
    
    self.resourceStore = nil;
    [super dealloc];
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if ([Util isEmptyString:title]) {
        return;
    }
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self.resourceStore setObject:dic forKey:[NSNumber numberWithInteger:state]];
    }
    [dic setObject:title forKey:k_action_button_title];
}
- (NSString *)titleForState:(UIControlState)state {
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    return [dic objectForKey:k_action_button_title];
}
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    if (!color) {
        return;
    }
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self.resourceStore setObject:dic forKey:[NSNumber numberWithInteger:state]];
    }
    [dic setObject:color forKey:k_action_button_ttl_color];
}
- (UIColor *)titleColorForState:(UIControlState)state {
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    return [dic objectForKey:k_action_button_ttl_color];
}
- (void)setBGImage:(UIImage *)image forState:(UIControlState)state {
    if (!image) {
        return;
    }
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self.resourceStore setObject:dic forKey:[NSNumber numberWithInteger:state]];
    }
    [dic setObject:image forKey:k_action_button_bgimage];
}
- (UIImage *)bgimageForState:(UIControlState)state {
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    return [dic objectForKey:k_action_button_bgimage];
}
- (void)setBGColor:(UIColor *)color forState:(UIControlState)state {
    if (!color) {
        return;
    }
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self.resourceStore setObject:dic forKey:[NSNumber numberWithInteger:state]];
    }
    [dic setObject:color forKey:k_action_button_bgcolor];
}
- (UIColor *)bgcolorForState:(UIControlState)state {
    NSMutableDictionary *dic = [self.resourceStore objectForKey:[NSNumber numberWithInteger:state]];
    return [dic objectForKey:k_action_button_bgcolor];
}

#pragma mark draw
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    //  border
    [SCouponTypeView fillBGWithContext:context Rect:rect Color:self.lineColor Radius:self.radius];
    //  bgcolor
    [SCouponTypeView fillBGWithContext:context Rect:CGRectInset(rect, 1.0, 1.0) Color:[self bgcolorForState:self.buttonState] Radius:self.radius];
    //  bgimage
    [self drawImageWithContext:context Rect:CGRectInset(rect, 1.0, 1.0) Image:[self bgimageForState:self.buttonState]];
    //  title
    [SCouponTypeView drawTextWithContext:context Rect:CGRectInset(rect, 1.0, 1.0) Text:[self titleForState:self.buttonState] Color:[self titleColorForState:self.buttonState] Font:self.textFont LineBreakMode:[Util lineBreakMode:SLineBreakByTruncatingMiddle] Alignment:[Util textAlignment:STextAlignmentCenter]];
    //  shine
    [self drawShineWithContext:context Rect:CGRectInset(rect, 1.0, 1.0) Radius:self.radius];
}
- (void)drawImageWithContext:(CGContextRef)context Rect:(CGRect)rect Image:(UIImage *)image {
    if (!image) {
        return;
    }
    [image drawInRect:rect contentMode:UIViewContentModeScaleAspectFill];
}
- (void)drawShineWithContext:(CGContextRef)context Rect:(CGRect)rect Radius:(CGFloat)r {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat colorGradient[8] = {1, 1, 1, 0.4, 1, 1, 1, 0};
    CGFloat locationGradient[2] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 colorGradient,
                                                                 locationGradient, 2);
    
    CGFloat shineStartY = rect.size.height*0.25;
    CGFloat shineStopY = shineStartY + rect.size.height*0.5;
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.origin.x, shineStartY);
    CGContextAddCurveToPoint(context, rect.origin.x, shineStopY, rect.origin.x+rect.size.width, shineStopY, rect.origin.x+rect.size.width, shineStartY);
    CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y, rect.origin.x+rect.size.width/2, rect.origin.y, r);
    CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x, shineStartY, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y),
                                CGPointMake(rect.origin.x+rect.size.width/2, shineStopY),
                                kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end

@implementation SCouponCellButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = SRGBCOLOR(229, 234, 241);
        [self setBGColor:SRGBCOLOR(62, 87, 129) forState:UIControlStateNormal];
    }
    return self;
}
- (void)drawImageWithContext:(CGContextRef)context Rect:(CGRect)rect Image:(UIImage *)image {
    if (!image) {
        return;
    }
    rect = CGRectMake(rect.origin.x+(rect.size.width-24)/2, rect.origin.y+(rect.size.height-24)/2, 24, 24);
    [image drawInRect:rect contentMode:UIViewContentModeScaleToFill];
}

@end