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
#import "SImageStore.h"

@interface SCouponsTableView : TSPullTableView <TSPullTableViewDelegate, UITableViewDataSource, SDataLoaderDelegate>
@property (nonatomic, retain)PImageStore *imageStore;
@property (nonatomic, retain) PListDataStore<PListRefreshLoadmoreProtocol> *dataStore;

@end
