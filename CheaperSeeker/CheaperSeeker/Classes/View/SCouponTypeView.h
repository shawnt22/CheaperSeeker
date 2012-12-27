//
//  SCouponTypeView.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-27.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCouponTypeView : UIView
@property (nonatomic, retain) NSString *text;
- (void)refreshWithText:(NSString *)text;
@end
