//
//  TCustomBGCell.m
//  TCustomCellBGViewDemo
//
//  Created by 滕 松 on 12-8-22.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "TCustomBGCell.h"

@implementation TCustomBGCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        
        TCustomCellBGView *_bg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
        self.backgroundView = _bg;
        [_bg release];
        
        TCustomCellBGView *_sbg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = _sbg;
        [_sbg release];
    }
    return self;
}
- (TCustomCellBGView *)customBackgroundView {
    return [self.backgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)(self.backgroundView) : nil;
}
- (TCustomCellBGView *)customSelectedBackgroundView {
    return [self.selectedBackgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)(self.selectedBackgroundView) : nil;
}

@end

typedef enum {
    CustomBGCellViewFillColorLine,
    CustomBGCellViewFillColorBackground,
    CustomBGCellViewFillColorInnerShadow,
    CustomBGCellViewFillColorDropShadow,
}CustomBGCellViewFillColorType;

@interface TCustomCellBGView()
@property (nonatomic, assign) CustomBGCellViewFillColorType currentFillType;
@end

@interface TCustomCellBGView(Draw)
- (void)fillBGWithContext:(CGContextRef)context Rect:(CGRect)rect;
- (void)fillLineWithContext:(CGContextRef)context Rect:(CGRect)rect;
- (void)fillInnerShadowWithContext:(CGContextRef)context Rect:(CGRect)rect;
- (void)fillDropShadowWithContext:(CGContextRef)context Rect:(CGRect)rect;
- (void)fillRectWithContext:(CGContextRef)context Rect:(CGRect)rect Color:(UIColor *)color FillType:(CustomBGCellViewFillColorType)fillType;
@end
@implementation TCustomCellBGView(Draw)

- (void)fillBGWithContext:(CGContextRef)context Rect:(CGRect)rect {
    [self fillRectWithContext:context Rect:rect Color:self.fillColor FillType:CustomBGCellViewFillColorBackground];
}
- (void)fillLineWithContext:(CGContextRef)context Rect:(CGRect)rect {
    [self fillRectWithContext:context Rect:rect Color:self.lineColor FillType:CustomBGCellViewFillColorLine];
}
- (void)fillInnerShadowWithContext:(CGContextRef)context Rect:(CGRect)rect {
    if (!self.innerShadowColor) {
        return;
    }
    [self fillRectWithContext:context Rect:rect Color:self.innerShadowColor FillType:CustomBGCellViewFillColorInnerShadow];
}
- (void)fillDropShadowWithContext:(CGContextRef)context Rect:(CGRect)rect {
    if (!self.dropShadowColor) {
        return;
    }
    [self fillRectWithContext:context Rect:rect Color:self.dropShadowColor FillType:CustomBGCellViewFillColorDropShadow];
}
- (void)fillRectWithContext:(CGContextRef)context Rect:(CGRect)rect Color:(UIColor *)color FillType:(CustomBGCellViewFillColorType)fillType {
    self.currentFillType = fillType;
    
    UIColor *fillColor = color;
    if (!fillColor) {
        return;
    }
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    switch (self.bgStyle) {
        case CustomBGCellStyleGroupSingle:
        {
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-self.dropShadowWidth);
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth*2 - self.dropShadowWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth*2 - self.dropShadowWidth - self.innerShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x+rect.size.width/2, rect.origin.y);
            CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2, self.lineRadius);
            CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height, rect.origin.x+rect.size.width/2, rect.size.height+rect.origin.y, self.lineRadius);
            CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y+rect.size.height, rect.origin.x, rect.origin.y+rect.size.height/2, self.lineRadius);
            CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width/4, rect.origin.y, self.lineRadius);
        }
            break;
        case CustomBGCellStyleGroupTop:
        {
            //  无外阴影
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = CGRectZero;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth - self.innerShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x+rect.size.width/2, rect.origin.y);
            CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y, rect.size.width+rect.origin.x, rect.origin.y+rect.size.height, self.lineRadius);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.size.height+rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x, rect.size.height+rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x, rect.size.height/2+rect.origin.y);
            CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width/4, rect.origin.y, self.lineRadius);
        }
            break;
        case CustomBGCellStyleGroupMiddle:
        {
            //  无外阴影
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = CGRectZero;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth - self.innerShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
        }
            break;
        case CustomBGCellStyleGroupBottom:
        {
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - self.dropShadowWidth);
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth*2 - self.dropShadowWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x + self.lineWidth;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width - self.lineWidth*2, rect.size.height - self.lineWidth*2 - self.innerShadowWidth - self.dropShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y+rect.size.height, rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height, self.lineRadius);
            CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2, self.lineRadius);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
        }
            break;
        case CustomBGCellStylePlainTop:
        {
            //  无外阴影
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = CGRectZero;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth - self.innerShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
        }
            break;
        case CustomBGCellStylePlainMiddle:
        {
            //  无外阴影
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = CGRectZero;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth - self.innerShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
        }
            break;
        case CustomBGCellStylePlainBottom:
        {
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - self.dropShadowWidth);
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth*2 - self.dropShadowWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth*2 - self.innerShadowWidth - self.dropShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
        }
            break;
        case CustomBGCellStylePlainSingle:
        {
            switch (self.currentFillType) {
                case CustomBGCellViewFillColorDropShadow:
                {
                    rect = rect;
                }
                    break;
                case CustomBGCellViewFillColorLine:
                {
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - self.dropShadowWidth);
                }
                    break;
                case CustomBGCellViewFillColorInnerShadow:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth*2 - self.dropShadowWidth);
                }
                    break;
                default:
                {
                    float _x = rect.origin.x;
                    float _y = rect.origin.y + self.lineWidth + self.innerShadowWidth;
                    rect = CGRectMake(_x, _y, rect.size.width, rect.size.height - self.lineWidth*2 - self.innerShadowWidth - self.dropShadowWidth);
                }
                    break;
            }
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
        }
            break;
        default:
            break;
    }
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

@end

@implementation TCustomCellBGView
@synthesize lineColor, lineWidth, lineRadius = _lineRadius, fillColor;
@synthesize bgStyle = _bgStyle, contentInsets;
@synthesize currentFillType;
@synthesize innerShadowColor, dropShadowColor, innerShadowWidth, dropShadowWidth;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.lineColor = [UIColor colorWithRed:(183/255.0) green:(183/255.0) blue:(183/255.0) alpha:1.0];
        self.lineRadius = 5.0;
        self.lineWidth = 1.0;
        self.fillColor = [UIColor colorWithRed:(253/255.0) green:(253/255.0) blue:(253/255.0) alpha:1.0];
        
        self.innerShadowColor = nil;
        self.dropShadowColor = nil;
        self.innerShadowWidth = 0.0;
        self.dropShadowWidth = 0.0;
        
        _bgStyle = CustomBGCellStyleGroupSingle;
    }
    return self;
}
- (void)dealloc {
    self.lineColor = nil;
    self.fillColor = nil;
    self.innerShadowColor = nil;
    self.dropShadowColor = nil;
    [super dealloc];
}
- (void)setBgStyle:(TCustomBGCellStyle)bgStyle {
    _bgStyle = bgStyle;
    [self setNeedsDisplay];
}
- (float)lineRadius {
    float result = self.currentFillType == CustomBGCellViewFillColorBackground ? _lineRadius : _lineRadius+1;
    return result;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect validRect = CGRectMake(rect.origin.x+self.contentInsets.left,
                                  rect.origin.y+self.contentInsets.top,
                                  rect.size.width-(self.contentInsets.left+self.contentInsets.right),
                                  rect.size.height-(self.contentInsets.top+self.contentInsets.bottom));
    [self fillDropShadowWithContext:context Rect:validRect];
    [self fillLineWithContext:context Rect:validRect];
    [self fillInnerShadowWithContext:context Rect:validRect];
    [self fillBGWithContext:context Rect:validRect];
}
+ (TCustomBGCellStyle)groupStyleWithIndex:(NSInteger)index Count:(NSInteger)count {
    if (count > 0) {
        if (count > 1) {
            if (index == 0) {
                return CustomBGCellStyleGroupTop;
            }
            if (index == count - 1) {
                return CustomBGCellStyleGroupBottom;
            }
            return CustomBGCellStyleGroupMiddle;
        }
        return CustomBGCellStyleGroupSingle;
    }
    return CustomBGCellStyleNone;
}
+ (TCustomBGCellStyle)plainStyleWithIndex:(NSInteger)index Count:(NSInteger)count {
    if (count > 0) {
        if (count > 1) {
            if (index == 0) {
                return CustomBGCellStylePlainTop;
            }
            if (index == count - 1) {
                return CustomBGCellStylePlainBottom;
            }
            return CustomBGCellStylePlainMiddle;
        }
        return CustomBGCellStylePlainSingle;
    }
    return CustomBGCellStyleNone;
}

@end
