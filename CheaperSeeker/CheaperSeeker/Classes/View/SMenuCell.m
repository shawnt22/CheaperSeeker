//
//  SMenuCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SMenuCell.h"

@interface SMenuCell()
@property (nonatomic, assign) UIImageView *icon;
@property (nonatomic, assign) UILabel *description;
@property (nonatomic, assign) MenuItem currentMenuItem;
@property (nonatomic, readonly) NSString *currentDescription;
@property (nonatomic, readonly) UIImage *currentIcon;
@end
@implementation SMenuCell
@synthesize icon, description;
@synthesize currentMenuItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        TCustomCellBGView *_bg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
//        _bg.lineColor = kCustomCellBGLineColor;
//        _bg.fillColor = [UIColor viewFlipsideBackgroundColor];
//        _bg.innerShadowColor = kCustomCellBGInnerShadowColor;
//        _bg.innerShadowWidth = 1.0;
//        self.backgroundView = _bg;
//        [_bg release];
//        TCustomCellBGView *_sbg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
//        _sbg.lineColor = kCustomCellBGLineColor;
//        _sbg.fillColor = kCustomCellSelectedBGFillColor;
//        self.selectedBackgroundView = _sbg;
//        [_sbg release];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *_sbg = [[UIView alloc] initWithFrame:CGRectZero];
        _sbg.backgroundColor = SRGBACOLOR(0, 0, 0, 0.3);
        self.selectedBackgroundView = _sbg;
        [_sbg release];
        
        UIImageView *_in = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, 6, 32, 32)];
        _in.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_in];
        self.icon = _in;
        [_in release];
        
        UILabel *_desc = [[UILabel alloc] initWithFrame:CGRectMake(_in.frame.size.width+_in.frame.origin.x+10, 0, 100, [SMenuCell cellHeight])];
        _desc.backgroundColor = [UIColor clearColor];
        _desc.font = [UIFont systemFontOfSize:15];
        _desc.textColor = kTextColor;
        _desc.shadowColor = kTextShadowColor;
        _desc.shadowOffset = kTextShadowOffset;
        [self.contentView addSubview:_desc];
        self.description = _desc;
        [_desc release];
        
        UIView *_line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        _line1.backgroundColor = kSiderCellBGLineColor;
        _line1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_line1];
        [_line1 release];
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}
+ (CGFloat)cellHeight {
    return 45.0;
}
- (NSString *)currentDescription {
    NSString *result = nil;
    switch (self.currentMenuItem) {
        case MenuAbout:
            result = @"About";
            break;
        case MenuCategory:
            result = @"Category";
            break;
        case MenuHome:
            result = @"Home";
            break;
        case MenuStore:
            result = @"Store";
            break;
        default:
            break;
    }
    return result;
}
- (UIImage *)currentIcon {
    UIImage *result = nil;
    switch (self.currentMenuItem) {
        case MenuAbout:
            result = [Util imageWithName:@""];
            break;
        case MenuCategory:
            result = [Util imageWithName:@""];
            break;
        case MenuHome:
            result = [Util imageWithName:@""];
            break;
        case MenuStore:
            result = [Util imageWithName:@""];
            break;
        default:
            break;
    }
    return result;
}
- (void)refreshMenuItem:(MenuItem)menuItem {
    self.currentMenuItem = menuItem;
    self.description.text = self.currentDescription;
    self.icon.image = self.currentIcon;
}

@end
