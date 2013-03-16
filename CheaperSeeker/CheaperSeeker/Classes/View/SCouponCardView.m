//
//  SCouponCardView.m
//  CheaperSeeker
//
//  Created by 滕 松 on 13-3-2.
//  Copyright (c) 2013年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponCardView.h"
#import "SCouponTypeView.h"
#import "Util.h"

@interface SCouponCardView ()
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) SCouponCardStyle *style;
@property (nonatomic, assign) CouponCardLayout layout;
@end
@implementation SCouponCardView
@synthesize title;
@synthesize style, layout;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)dealloc {
    self.title = nil;
    self.style = nil;
    [super dealloc];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef _context = UIGraphicsGetCurrentContext();
    CGContextClearRect(_context, rect);
    
    [SCouponTypeView fillBGWithContext:_context Rect:self.bounds Color:self.style.keyColor Radius:2.0];
    [SCouponTypeView fillBGWithContext:_context Rect:CGRectInset(self.bounds, 1, 1) Color:self.style.coverBGColor Radius:2.0];
    
    [self drawTitleBGWith:_context];
    [self drawTitleWith:_context];
}
- (void)drawTitleBGWith:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, self.style.keyColor.CGColor);
    
    CGContextMoveToPoint(context, self.layout.title.origin.x, self.layout.title.origin.y);
    CGContextAddLineToPoint(context, self.layout.title.origin.x+self.layout.title.size.width, self.layout.title.origin.y);
    CGContextAddLineToPoint(context, self.layout.title.origin.x+self.layout.title.size.width, self.layout.title.origin.y+self.layout.title.size.height/2);
    CGContextAddArcToPoint(context, self.layout.title.origin.x+self.layout.title.size.width, self.layout.title.origin.y+self.layout.title.size.height, self.layout.title.origin.x+self.layout.title.size.width/2, self.layout.title.origin.y+self.layout.title.size.height, 2);
    CGContextAddArcToPoint(context, self.layout.title.origin.x, self.layout.title.origin.y+self.layout.title.size.height/2, self.layout.title.origin.x, self.layout.title.size.height/2+self.layout.title.origin.y, 2);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}
- (void)drawTitleWith:(CGContextRef)context {
    [SCouponTypeView drawTextWithContext:context Rect:self.layout.title Text:self.title Color:self.style.titleColor Font:self.style.titleFont LineBreakMode:[Util lineBreakMode:SLineBreakByTruncatingTail] Alignment:[Util textAlignment:STextAlignmentCenter]];
}

#pragma mark refresh
+ (CGFloat)cardTitleHeight {
    return 25.0;
}
- (void)refreshWithTitle:(NSString *)ttl Style:(SCouponCardStyle *)sty Layout:(CouponCardLayout)lay {
    self.style = sty;
    self.title = ttl;
    self.layout = lay;
    
    self.frame = lay.view;
    
    [self setNeedsDisplay];
}

@end
