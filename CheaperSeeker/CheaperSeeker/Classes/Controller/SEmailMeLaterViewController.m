//
//  SEmailMeLaterViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-27.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SEmailMeLaterViewController.h"
#import "SSetting.h"

@implementation SEmailMeLaterViewController
@synthesize coupon;

- (id)initWithCoupon:(id)cpn {
    self = [super init];
    if (self) {
        self.coupon = cpn;
    }
    return self;
}
- (void)dealloc {
    self.coupon = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = k_text_email_me_later_controller_title;
}

@end
