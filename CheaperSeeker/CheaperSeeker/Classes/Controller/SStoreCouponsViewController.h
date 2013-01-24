//
//  SStoreCouponsViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-10-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"
#import "SCouponsTableView.h"
#import "SEmailMeLaterViewController.h"

@interface SStoreCouponsViewController : SViewController<SCouponsTableViewDelegate, SEmailMeLaterViewControllerDelegate>
@property (nonatomic, retain) id store;

- (id)initWithStore:(id)store;

@end
