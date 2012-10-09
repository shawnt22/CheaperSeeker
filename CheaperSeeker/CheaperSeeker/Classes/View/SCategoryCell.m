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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.category = nil;
        
        UILabel *_ttl = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft, 0, ceilf((self.contentView.bounds.size.width-kMarginLeft*2)), self.contentView.bounds.size.height)];
        _ttl.backgroundColor = [UIColor clearColor];
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
+ (CGFloat)cellHeight {
    return 45.0f;
}
- (void)refreshWithCategory:(id)ctgy {
    self.category = ctgy;
    self.categoryTitle.text = [ctgy objectForKey:k_category_title];
}

@end
