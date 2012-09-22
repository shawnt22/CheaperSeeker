//
//  SMerchantCell.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-22.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
#import "SUtil.h"
#import "Sconfiger.h"
#import "SDefine.h"
#import "SLayout.h"
#import "SStyle.h"
#import "SDWebImageManager.h"

@interface SMerchantCell : UITableViewCell<SDWebImageManagerDelegate>
@property (nonatomic, retain) id merchant;
+ (CGFloat)cellHeight;
- (void)refreshWithMerchant:(id)merchant Layout:(SMerchantLayout *)layout Style:(SMerchantStyle *)style;

@end
