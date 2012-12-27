//
//  SAboutCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SAboutCell.h"
#import "SAboutViewController.h"

@interface SAboutCell()
@property (nonatomic, assign) UILabel *aboutTitle;
@property (nonatomic, assign) UILabel *aboutContent;
@end

@implementation SAboutCell
@synthesize aboutTitle, aboutContent;
@synthesize customSelectedBackgroundView, customBackgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [SUtil setCustomCellBGView:self];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 1;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.numberOfLines = 1000;
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
- (void)refreshWithTitle:(NSString *)title Content:(NSString *)content {
    self.textLabel.text = title;
    self.detailTextLabel.text = content;
}

@end


@implementation SAboutCell (Layout)

+ (CGFloat)titleWidth {
    return 60.0;
}
+ (CGFloat)contentWidth {
    return [SUtil cellWidth] - [SAboutCell titleWidth] - 3;
}
+ (CGFloat)cellHeightWithAbout:(id)about IndexPath:(NSIndexPath *)indexPath {
    NSString *_content = [SAboutViewController contentWithIndexPath:indexPath About:about];
    CGSize _size = [_content sizeWithFont:[SAboutCell contentFont] constrainedToSize:CGSizeMake([SAboutCell contentWidth], 960) lineBreakMode:[SAboutCell lineBreakMode]];
    _size.height += [SAboutCell marginTop]*2;
    return _size.height > 44.0f ? _size.height : 44.0f;
}
+ (UIFont *)titleFont {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIFont *)contentFont {
    return [UIFont systemFontOfSize:18.0];
}
+ (NSInteger)lineBreakMode {
    return [Util lineBreakMode:SLineBreakByWordWrapping];
}
+ (CGFloat)marginTop {
    return 10.0;
}

@end
