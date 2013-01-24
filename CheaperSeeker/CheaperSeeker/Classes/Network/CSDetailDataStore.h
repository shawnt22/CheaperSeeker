//
//  CSDetailDataStore.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-11-20.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SDataLoader.h"

@interface CSAboutInfoDataStore : SDataLoader
- (void)getAboutInfo:(ASICachePolicy)cachePolicy;
@end

@interface CSEmailMeLaterDataStore : SDataLoader
- (void)postEmail:(NSString *)email CouponID:(NSString *)couponID;
@end