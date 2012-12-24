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

@property (nonatomic, assign) UIButton *goBack;
@property (nonatomic, assign) UIButton *goForward;
@property (nonatomic, assign) UIButton *reloadWeb;
@property (nonatomic, assign) UIButton *stopLoad;
@property (nonatomic, assign) UIButton *openSafari;
@property (nonatomic, assign) UIView *actionBar;

- (id)initWithURLPath:(NSString *)urlPath;

@end
