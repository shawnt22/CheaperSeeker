//
//  SCouponCardView.h
//  CheaperSeeker
//
//  Created by 滕 松 on 13-3-2.
//  Copyright (c) 2013年 shawnt22@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SStyle.h"

typedef struct {
    CGRect title;
    CGRect view;
}CouponCardLayout;

NS_INLINE CouponCardLayout CouponCardLayoutMake(CGRect title, CGRect view) {
    CouponCardLayout layout;
    layout.title = title;
    layout.view = view;
    return layout;
}

@interface SCouponCardView : UIView
- (void)restyle:(SCouponCardStyle *)style;  //  step 1
- (void)relayout:(CouponCardLayout)layout;  //  step 2
- (void)recontent:(NSString *)title;        //  step 3
@end
