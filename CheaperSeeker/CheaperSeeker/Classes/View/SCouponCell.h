//
//  SCouponCell.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCustomBGCell.h"
#import "Util.h"
#import "SUtil.h"
#import "Sconfiger.h"
#import "SDefine.h"
#import "SLayout.h"
#import "SStyle.h"
#import "SDWebImageManager.h"

#define k_coupon_cell_tool_bar_height 44.0

@class SCouponsTableView;
@interface SCouponCell : UITableViewCell<SDWebImageManagerDelegate, TCustomCellBGViewProtocol>
@property (nonatomic, retain) id coupon;
@property (nonatomic, assign) SCouponsTableView *couponsTableView;
+ (CGFloat)cellHeight;
- (void)refreshWithCoupon:(id)coupon Layout:(SCouponLayout *)layout Style:(SCouponStyle *)style;
@end

@interface SCouponCell (OpenClose)
- (void)openWithAnimated:(BOOL)animated;
- (void)closeWithAnimated:(BOOL)animated;
- (void)finishOpenAnimation:(BOOL)animated;
- (void)finishCloseAnimation:(BOOL)animated;
- (void)startOpenAnimation:(BOOL)animated;
- (void)startCloseAnimation:(BOOL)animated;
@end
