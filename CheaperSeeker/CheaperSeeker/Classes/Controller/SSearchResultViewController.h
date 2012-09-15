//
//  SSearchResultViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"
#import "SCouponsTableView.h"

@interface SSearchCouponsViewController : SViewController <SCouponsTableViewDelegate>
@property (nonatomic, retain) NSString *keyword;

- (id)initWithKeyword:(NSString *)keyword;

@end
