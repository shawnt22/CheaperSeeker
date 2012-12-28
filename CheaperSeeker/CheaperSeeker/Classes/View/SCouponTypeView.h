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
- (void)refreshWithText:(NSString *)text;
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
