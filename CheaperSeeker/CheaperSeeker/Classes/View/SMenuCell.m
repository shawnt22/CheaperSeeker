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
        UIImageView *_in = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, ceilf(([SMenuCell cellHeight]-40)/2), 40, 40)];
        _in.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_in];
        self.icon = _in;
        [_in release];
        
        UILabel *_desc = [[UILabel alloc] initWithFrame:CGRectMake(_in.frame.size.width+_in.frame.origin.x+5, 0, 100, [SMenuCell cellHeight])];
        _desc.backgroundColor = [UIColor yellowColor];
        _desc.font = [UIFont systemFontOfSize:16];
        _desc.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_desc];
        self.description = _desc;
        [_desc release];
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}
+ (CGFloat)cellHeight {
    return 44.0;
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
