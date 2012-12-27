//
//  SCouponsTableView.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
#import "SUtil.h"
#import "Sconfiger.h"
#import "TSPullTableView.h"
#import "CSListDataStore.h"

@class SCouponsTableView;
@protocol SCouponsTableViewDelegate <NSObject>
@optional
- (void)couponsTableView:(SCouponsTableView *)couponsTableView didSelectCoupon:(id)coupon atIndexPath:(NSIndexPath *)indexPath;
- (void)couponsTableView:(SCouponsTableView *)couponsTableView EmailMeLater:(id)coupon;
@end

@interface SCouponsTableView : CSPullTableView <TSPullTableViewDelegate, TSViewGestureDelegate, UITableViewDataSource, SDataLoaderDelegate>
@property (nonatomic, retain) PListDataStore<PListRefreshLoadmoreProtocol> *couponsDataStore;
@property (nonatomic, assign) id<SCouponsTableViewDelegate> couponsTableViewDelegate;

- (void)resetCellOpenState;

@end
