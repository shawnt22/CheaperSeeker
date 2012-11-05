//
//  SCategoryItem.m
//  SCategoryControlDemo
//
//  Created by 滕 松 on 12-10-25.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCategoryItem.h"

#define k_category_item_content_linebreak_mode NSLineBreakByWordWrapping

@interface SCategoryItem()
@property (nonatomic, assign) CGFloat radius;
- (UIColor *)currentBGColor;
@end

@interface SCategoryItem (Draw)
- (void)drawBackgroundWithContext:(CGContextRef)context Rect:(CGRect)rect FillColor:(UIColor *)fillColor;
- (void)drawContentWithContext:(CGContextRef)context Rect:(CGRect)rect;
@end
@implementation SCategoryItem (Draw)
- (void)drawBackgroundWithContext:(CGContextRef)context Rect:(CGRect)rect FillColor:(UIColor *)fillColor {
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGFloat _r = self.radius;
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+rect.size.height/2);
    CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width/2, rect.origin.y, _r);
    CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2, _r);
    CGContextAddArcToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height, rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height, _r);
    CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y+rect.size.height, rect.origin.x, rect.origin.y+rect.size.height/2, _r);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}
- (void)drawContentWithContext:(CGContextRef)context Rect:(CGRect)rect {
    CGContextSaveGState(context);
    
    [self.contentColor set];
    NSLineBreakMode _lineBreadMode = k_category_item_content_linebreak_mode;
    
    CGSize _contentSize = [self.content sizeWithFont:self.contentFont constrainedToSize:self.contentConstrainedToSize lineBreakMode:_lineBreadMode];
    rect = CGRectMake(ceilf(rect.origin.x+(rect.size.width-_contentSize.width)/2), ceilf(rect.origin.y+(rect.size.height-_contentSize.height)/2), _contentSize.width, _contentSize.height);
    [self.content drawInRect:rect withFont:self.contentFont lineBreakMode:_lineBreadMode];
    
    CGContextRestoreGState(context);
}
@end

#define kCategoryItemStateKeyPath   @"itemState"

@implementation SCategoryItem
@synthesize radius, innerShadowHeight;
@synthesize itemState;
@synthesize reusableIdentifier, itemIndexPath;
@synthesize bgColor, bgSelectedColor, innerShadowColor, contentColor, contentFont, contentConstrainedToSize, borderWidth, borderColor;
@synthesize content;
@synthesize itemDelegate;

- (SCategoryItem *)defaultItemWithReusableIdentifier:(NSString *)rIdentifier {
    self = [self initWithFrame:CGRectZero ReusableIdentifier:rIdentifier];
    if (self) {
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame ReusableIdentifier:(NSString *)rIdentifier {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        self.reusableIdentifier = rIdentifier;
        
        self.bgColor = k_category_item_bgcolor_normal_default;
        self.bgSelectedColor = k_category_item_bgcolor_selected_default;
        self.innerShadowColor = [UIColor colorWithRed:(68/255.0) green:(71/255.0) blue:(77/255.0) alpha:1.0];
        self.borderColor = [UIColor colorWithRed:(25/255.0) green:(25/255.0) blue:(27/255.0) alpha:1.0];
        self.borderWidth = 1.0;
        
        self.contentColor = [UIColor whiteColor];
        self.contentFont = k_category_item_content_font;
        self.content = nil;
        self.contentConstrainedToSize = k_category_item_content_constrained_size;
        
        self.innerShadowHeight = 1.0;
        
        UITapGestureRecognizer *_tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseTapGesture:)];
        [self addGestureRecognizer:_tapGesture];
        [_tapGesture release];
        
        [self addObserver:self forKeyPath:kCategoryItemStateKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:kCategoryItemStateKeyPath];
    
    self.bgColor = nil;
    self.innerShadowColor = nil;
    self.contentFont = nil;
    self.contentColor = nil;
    self.borderColor = nil;
    self.reusableIdentifier = nil;
    [super dealloc];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kCategoryItemStateKeyPath]) {
        [self setNeedsDisplay];
        return;
    }
}
- (void)responseTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(categoryItem:responseTapGesture:)]) {
        [self.itemDelegate categoryItem:self responseTapGesture:tapGesture];
    }
}
- (void)refreshItemWithContent:(NSString *)cnt Frame:(CGRect)frm {
    self.frame = frm;
    self.content = cnt;
    [self setNeedsDisplay];
}
+ (CGSize)itemSizeWithContent:(NSString *)cnt Font:(UIFont *)fnt ConstrainedToSize:(CGSize)sze {
    CGSize _cntSize = [cnt sizeWithFont:fnt constrainedToSize:sze lineBreakMode:k_category_item_content_linebreak_mode];
    return CGSizeMake(_cntSize.width+k_category_item_height_default, k_category_item_height_default);
}
- (UIColor *)currentBGColor {
    UIColor *_result = self.bgColor;
    switch (self.itemState) {
        case UIControlStateSelected:
            _result = self.bgSelectedColor;
            break;
        default:
            break;
    }
    return _result;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    //  border
    CGRect originalRect = rect;
    self.radius = ceilf(originalRect.size.height / 2.0);
    [self drawBackgroundWithContext:context Rect:originalRect FillColor:self.borderColor];
    rect = CGRectInset(originalRect, self.borderWidth, self.borderWidth);
    //  inner shadow
    [self drawBackgroundWithContext:context Rect:rect FillColor:self.innerShadowColor];
    //  bg
    [self drawBackgroundWithContext:context Rect:CGRectMake(rect.origin.x, rect.origin.y+self.innerShadowHeight, rect.size.width, rect.size.height-self.innerShadowHeight) FillColor:[self currentBGColor]];
    //  content
    [self drawContentWithContext:context Rect:CGRectMake(self.radius, 0, rect.size.width-2*self.radius, rect.size.height)];
}

@end
