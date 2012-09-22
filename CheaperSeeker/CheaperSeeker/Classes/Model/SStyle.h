//
//  SStyle.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SStyle : NSObject
@property (nonatomic, assign) UILineBreakMode lineBreakMode;

@end

@interface SCouponStyle : SStyle
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIFont *contentFont;
@property (nonatomic, retain) UIColor *contentColor;
@property (nonatomic, retain) UIFont *expireFont;
@property (nonatomic, retain) UIColor *expireColor;

@end

@interface SMerchantStyle : SStyle
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@end

