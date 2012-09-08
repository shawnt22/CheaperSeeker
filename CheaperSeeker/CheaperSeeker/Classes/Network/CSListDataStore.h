//
//  CSListDataStore.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SListDataStore.h"

#pragma mark - Home
@interface CSHomeDataStore : PListDataStore <PListRefreshLoadmoreProtocol>

@end

#pragma mark - Search
@interface CSSearchDataStore : PListDataStore <PListRefreshLoadmoreProtocol>
@property (nonatomic, retain) NSString *key;
@end

#pragma mark - Merchant
@interface CSMerchantsDataStore : PListDataStore <PListRefreshLoadmoreProtocol>

@end

@interface CSMerchantCouponsDataStore : PListDataStore <PListRefreshLoadmoreProtocol>
@property (nonatomic, retain) id merchant;
@end

#pragma mark - Category
@interface CSCategoriesDataStore : PListDataStore <PListRefreshLoadmoreProtocol>

@end

@interface CSCategoryCouponsDataStore : PListDataStore <PListRefreshLoadmoreProtocol>
@property (nonatomic, retain) id category;
@end