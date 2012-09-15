//
//  SWebViewController.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SViewController.h"

@interface SWebViewController : SViewController <UIWebViewDelegate, UIActionSheetDelegate>
@property (nonatomic, retain) NSString *urlPath;
@property (nonatomic, assign) UIWebView *webView;
- (id)initWithURLPath:(NSString *)urlPath;

@end
