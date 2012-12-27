//
//  SEmailMeLaterViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-27.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"

@interface SEmailMeLaterViewController : SViewController <UITextFieldDelegate>
@property (nonatomic, retain) id coupon;

- (id)initWithCoupon:(id)coupon;

@end
