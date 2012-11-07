//
//  SCategoryCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCategoryCell.h"

@interface SCategoryCell()
@property (nonatomic, assign) UILabel *categoryTitle;
@end

@implementation SCategoryCell
@synthesize category;
@synthesize categoryTitle;
@synthesize customBackgroundView, customSelectedBackgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [SUtil setCustomCellBGView:self];
        
        self.category = nil;
        
        UILabel *_ttl = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft, 5, ceilf((self.contentView.bounds.size.width-kMarginLeft*2)), self.contentView.bounds.size.height-10)];
        _ttl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _ttl.backgroundColor = kCustomCellBGFillColor;
        _ttl.textColor = [UIColor blackColor];
        _ttl.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:_ttl];
        self.categoryTitle = _ttl;
        [_ttl release];
    }
    return self;
}
- (void)dealloc {
    self.category = nil;
    [super dealloc];
}
- (TCustomCellBGView *)customBackgroundView {
    return [self.backgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.backgroundView : nil;
}
- (TCustomCellBGView *)customSelectedBackgroundView {
    return [self.selectedBackgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.selectedBackgroundView : nil;
}
+ (CGFloat)cellHeight {
    return 56.0f;
}
- (void)refreshWithCategory:(id)ctgy {
    self.category = ctgy;
    self.categoryTitle.text = [ctgy objectForKey:k_category_title];
}

@end
