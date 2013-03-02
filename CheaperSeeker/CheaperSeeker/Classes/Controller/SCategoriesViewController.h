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
#import "SCategoryControl.h"

@interface SCategoriesViewController : SViewController <UITableViewDelegate, UITableViewDataSource, SDataLoaderDelegate, SCategoryControlDataSource, SCategoryControlDelegate>

@end


@interface SCategoriesViewController (DataManager)
@property (nonatomic, readonly) NSString *currentCategoryTitle;
+ (NSArray *)subcategoriesWith:(id)category;
- (NSArray *)currentSelectedCategoryItemSubcategories;
@end


@interface SCategoryItemLayout : NSObject
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, readonly) CGRect frame;
@end

