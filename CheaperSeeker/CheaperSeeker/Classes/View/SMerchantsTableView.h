//
//  SMerchantsTableView.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-11-29.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
#import "SUtil.h"
#import "Sconfiger.h"
#import "TSPullTableView.h"
#import "CSListDataStore.h"

@class SMerchantsTableView;
@protocol SMerchantsTableViewDelegate <NSObject>
@optional
- (void)merchantsTableView:(SMerchantsTableView *)merchantsTableView didSelectMerchant:(id)merchant atIndexPath:(NSIndexPath *)indexPath;
@end

@interface SMerchantsTableView : CSPullTableView <TSPullTableViewDelegate, TSViewGestureDelegate, UITableViewDataSource, SDataLoaderDelegate>
@property (nonatomic, retain) PListDataStore<PListRefreshLoadmoreProtocol> *merchantsDataStore;
@property (nonatomic, assign) id<SMerchantsTableViewDelegate> merchantsTableViewDelegate;
@end
