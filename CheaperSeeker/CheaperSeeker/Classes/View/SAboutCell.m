//
//  SAboutCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SAboutCell.h"

@interface SAboutCell()
@property (nonatomic, assign) UILabel *aboutTitle;
@end

@implementation SAboutCell
@synthesize aboutTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        TCustomCellBGView *_bg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
        _bg.lineColor = kCustomCellBGLineColor;
        _bg.fillColor = kCustomCellBGFillColor;
        _bg.innerShadowColor = kCustomCellBGInnerShadowColor;
        _bg.innerShadowWidth = 1.0;
        self.backgroundView = _bg;
        [_bg release];
        TCustomCellBGView *_sbg = [[TCustomCellBGView alloc] initWithFrame:CGRectZero];
        _sbg.lineColor = kCustomCellSelectedBGLineColor;
        _sbg.fillColor = kCustomCellSelectedBGFillColor;
        self.selectedBackgroundView = _sbg;
        [_sbg release];
        
        UILabel *_ttl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width-20, self.contentView.bounds.size.height)];
        _ttl.backgroundColor = [UIColor clearColor];
        _ttl.textColor = [UIColor blackColor];
        _ttl.textAlignment = UITextAlignmentCenter;
        _ttl.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_ttl];
        self.aboutTitle = _ttl;
        [_ttl release];
    }
    return self;
}

+ (CGFloat)cellHeight {
    return 45.0f;
}
- (void)refreshWithTitle:(NSString *)title {
    self.aboutTitle.text = title;
}

@end
