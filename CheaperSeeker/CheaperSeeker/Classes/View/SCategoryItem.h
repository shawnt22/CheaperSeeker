//
//  SCategoryItem.h
//  SCategoryControlDemo
//
//  Created by 滕 松 on 12-10-25.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    NSInteger column;
}SCategoryIndexPath;

NS_INLINE SCategoryIndexPath SCategoryIndexPathMake(NSInteger _column) {
    SCategoryIndexPath indexPath;
    indexPath.column = _column;
    return indexPath;
}
NS_INLINE BOOL SCategoryIndexPathEqual(SCategoryIndexPath indexPath, SCategoryIndexPath annother) {
    return indexPath.column == annother.column ? YES : NO;
}
NS_INLINE NSString *NSStringFromSCategoryIndexPath(SCategoryIndexPath indexPath) {
    return [NSString stringWithFormat:@"%d", indexPath.column];
}
NS_INLINE SCategoryIndexPath SCategoryIndexPathFromNSString(NSString *string) {
    SCategoryIndexPath indexPath;
    indexPath.column = [string integerValue];
    return indexPath;
}

@protocol SCategoryItemDelegate;
@protocol SCategoryItemProtocol <NSObject>
@property (nonatomic, retain) NSString *reusableIdentifier;
@property (nonatomic, assign) UIControlState itemState;
@optional
@property (nonatomic, assign) SCategoryIndexPath itemIndexPath;
@property (nonatomic, assign) id<SCategoryItemDelegate> itemDelegate;
@end

@protocol SCategoryItemDelegate <NSObject>
@optional
- (void)categoryItem:(UIView<SCategoryItemProtocol> *)item responseTapGesture:(UITapGestureRecognizer *)tapGesture;
@end

#define k_category_item_height_default 30.0
#define k_category_item_content_constrained_size CGSizeMake(250, k_category_item_height_default - 4)
#define k_category_item_content_font [UIFont systemFontOfSize:12]
#define k_category_item_bgcolor_normal_default [UIColor colorWithRed:(50/255.0) green:(51/255.0) blue:(56/255.0) alpha:1.0]
#define k_category_item_bgcolor_selected_default [UIColor colorWithRed:(255/255.0) green:(72/255.0) blue:(0/255.0) alpha:1.0]
#define k_category_item_bgcolor_hightlighted_default [UIColor colorWithRed:(255/255.0) green:(72/255.0) blue:(0/255.0) alpha:1.0]

@interface SCategoryItem : UIView<SCategoryItemProtocol>
@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *bgSelectedColor;
@property (nonatomic, retain) UIColor *innerShadowColor;
@property (nonatomic, assign) CGFloat innerShadowHeight;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, retain) UIColor *contentColor;
@property (nonatomic, retain) UIFont *contentFont;
@property (nonatomic, assign) CGSize contentConstrainedToSize;
@property (nonatomic, retain) NSString *content;

- (SCategoryItem *)defaultItemWithReusableIdentifier:(NSString *)reusableIdentifier;
- (id)initWithFrame:(CGRect)frame ReusableIdentifier:(NSString *)reusableIdentifier;

- (void)refreshItemWithContent:(NSString *)content Frame:(CGRect)frame;
+ (CGSize)itemSizeWithContent:(NSString *)content Font:(UIFont *)font ConstrainedToSize:(CGSize)size;

@end
