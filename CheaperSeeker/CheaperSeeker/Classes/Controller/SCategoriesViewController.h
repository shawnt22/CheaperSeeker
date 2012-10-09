//
//  SCategoriesViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"
#import "TSPullTableView.h"
#import "CSListDataStore.h"

@interface SCategoriesViewController : SViewController <TSPullTableViewDelegate, TSViewGestureDelegate, UITableViewDataSource, SDataLoaderDelegate>

@end
