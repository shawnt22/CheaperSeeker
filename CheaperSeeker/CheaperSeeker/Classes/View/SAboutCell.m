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
@synthesize customSelectedBackgroundView, customBackgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [SUtil setCustomCellBGView:self];
        
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
- (TCustomCellBGView *)customBackgroundView {
    return [self.backgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.backgroundView : nil;
}
- (TCustomCellBGView *)customSelectedBackgroundView {
    return [self.selectedBackgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.selectedBackgroundView : nil;
}
+ (CGFloat)cellHeight {
    return 45.0f;
}
- (void)refreshWithTitle:(NSString *)title {
    self.aboutTitle.text = title;
}

@end
