//
//  SCategoryCell.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
#import "SUtil.h"
#import "Sconfiger.h"
#import "SDefine.h"
#import "TCustomBGCell.h"

@interface SCategoryCell : UITableViewCell<TCustomCellBGViewProtocol>
@property (nonatomic, retain) id category;

+ (CGFloat)cellHeight;
- (void)refreshWithCategory:(id)category;

@end
