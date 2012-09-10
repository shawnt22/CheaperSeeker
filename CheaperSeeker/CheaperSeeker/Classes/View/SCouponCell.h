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
#import "SImageStore.h"
#import "SLayout.h"
#import "SStyle.h"

@interface SCouponCell : UITableViewCell<PImageStoreDelegate>
@property (nonatomic, retain) id coupon;
@property (nonatomic, assign) PImageStore *imageStore;
+ (CGFloat)cellHeight;
- (void)refreshWithCoupon:(id)coupon Layout:(SCouponLayout *)layout Style:(SCouponStyle *)style;

@end
