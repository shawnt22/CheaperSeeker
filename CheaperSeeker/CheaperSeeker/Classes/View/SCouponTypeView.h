//
//  SCouponTypeView.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-27.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCouponTypeView : UIView
@property (nonatomic, retain) NSString *text;
+ (CGFloat)normalWidth;
+ (CGFloat)normalHeight;
- (void)refreshWithText:(NSString *)text;
@end

@interface SCouponTypeView (Draw)
+ (void)fillBGWithContext:(CGContextRef)context Rect:(CGRect)rect Color:(UIColor *)color Radius:(CGFloat)radius;
+ (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect Text:(NSString *)text Color:(UIColor *)color Font:(UIFont *)font LineBreakMode:(NSInteger)mode Alignment:(NSInteger)alignment;
@end

@interface SButton : UIControl
@property (nonatomic, assign) UIControlState buttonState;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, assign) CGFloat radius;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (NSString *)titleForState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;
- (void)setBGImage:(UIImage *)image forState:(UIControlState)state;
- (UIImage *)bgimageForState:(UIControlState)state;
- (void)setBGColor:(UIColor *)color forState:(UIControlState)state;
- (UIColor *)bgcolorForState:(UIControlState)state;

@end


@interface SCouponCellButton : SButton

@end

typedef struct {
    CGRect image;       //  图片标示
    CGRect text;        //  数字
    CGRect view;        //  整个view
}CanDoViewLayout;
NS_INLINE CanDoViewLayout CanDoViewLayoutUpdateView(CanDoViewLayout layout, CGRect view) {
    layout.view = view;
    return layout;
}
NS_INLINE CanDoViewLayout CanDoViewLayoutZero() {
    CanDoViewLayout layout;
    layout.image = CGRectZero;
    layout.text = CGRectZero;
    layout.view = CGRectZero;
    return layout;
}
@interface SCouponCanDoView : SCouponTypeView
@property (nonatomic, assign) CanDoViewLayout layout;
+ (CanDoViewLayout)layoutWithNumber:(NSString *)number;
- (void)refreshWithText:(NSString *)text Image:(UIImage *)image Layout:(CanDoViewLayout)layout;
@end

@interface SCouponUnionDoView : SCouponCanDoView

@end

