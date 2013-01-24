//
//  SSearchResultViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"
#import "SCouponsTableView.h"
#import "SEmailMeLaterViewController.h"

@interface SSearchCouponsViewController : SViewController <SCouponsTableViewDelegate, SEmailMeLaterViewControllerDelegate>
@property (nonatomic, retain) NSString *keyword;

- (id)initWithKeyword:(NSString *)keyword;

@end
