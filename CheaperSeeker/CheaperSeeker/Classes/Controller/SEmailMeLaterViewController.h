//
//  SEmailMeLaterViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-27.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"
#import "CSDetailDataStore.h"

@class SEmailMeLaterViewController;
@protocol SEmailMeLaterViewControllerDelegate <NSObject>
@optional
- (void)didFinishPostEmailAddress:(SEmailMeLaterViewController *)emailMeLaterViewController;
@end

@interface SEmailMeLaterViewController : SViewController <SDataLoaderDelegate>
@property (nonatomic, retain) id coupon;
@property (nonatomic, assign) id<SEmailMeLaterViewControllerDelegate> controllerDelegate;

- (id)initWithCoupon:(id)coupon;

@end
