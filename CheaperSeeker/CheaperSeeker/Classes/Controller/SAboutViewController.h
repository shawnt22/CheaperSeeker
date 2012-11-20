//
//  SAboutViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"
#import "CSDetailDataStore.h"

typedef enum {
    AboutTableRowDescription,
    AboutTableRowEmail,
    AboutTableRowSite,
    AboutTableRowAddress,
    AboutTableRowCount,
}AboutControllerTableRow;

@interface SAboutViewController : SViewController <UITableViewDataSource, UITableViewDelegate, SDataLoaderDelegate>

@end

@interface SAboutViewController (DataManager)

+ (NSString *)contentWithIndexPath:(NSIndexPath *)indexPath About:(id)about;
+ (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath About:(id)about;

@end
