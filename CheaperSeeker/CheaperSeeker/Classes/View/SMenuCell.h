//
//  SMenuCell.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sconfiger.h"
#import "TCustomBGCell.h"

typedef enum {
    MenuHome,
    MenuStore,
    MenuCategory,
    MenuAbout,
    MenuCount,
}MenuItem;
@interface SMenuCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)refreshMenuItem:(MenuItem)menuItem;

@end
