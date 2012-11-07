//
//  SWebViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SWebViewController.h"

@interface SWebViewController()
@property (nonatomic, assign) UIButton *goBack;
@property (nonatomic, assign) UIButton *goForward;
@property (nonatomic, assign) UIButton *reloadWeb;
@property (nonatomic, assign) UIButton *stopLoad;
@property (nonatomic, assign) UIButton *openSafari;
@property (nonatomic, assign) UIView *actionBar;
- (void)refreshActionBar;
@end
@implementation SWebViewController
@synthesize urlPath, webView;
@synthesize goBack, goForward, reloadWeb, stopLoad, openSafari, actionBar;

#pragma mark init & dealloc
- (id)initWithURLPath:(NSString *)url {
    self = [super init];
    if (self) {
        self.urlPath = url;
        
    }
    return self;
}
- (void)dealloc {
    self.urlPath = nil;
    [super dealloc];
}

#pragma mark controller delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *_abar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-49.0, self.view.bounds.size.width, 49.0)];
    _abar.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    [self.view addSubview:_abar];
    self.actionBar = _abar;
    [_abar release];
    
    UIWebView *_web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-self.actionBar.bounds.size.height)];
    _web.backgroundColor = self.view.backgroundColor;
    _web.scalesPageToFit = YES;
    _web.delegate = self;
    [self.view addSubview:_web];
    [self.view sendSubviewToBack:_web];
    self.webView = _web;
    [_web release];
    
    UIButton *_goback = [[UIButton alloc] initWithFrame:CGRectMake(16, self.actionBar.bounds.size.height-49, 31, 49)];
    [_goback setBackgroundImage:[Util imageWithName:@"btn_backward_normal"] forState:UIControlStateDisabled];
    [_goback setBackgroundImage:[Util imageWithName:@"btn_backward_highlighted"] forState:UIControlStateHighlighted];
    [_goback setBackgroundImage:[Util imageWithName:@"btn_backward_disable"] forState:UIControlStateNormal];
    [_goback addTarget:self action:@selector(backwordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionBar addSubview:_goback];
    self.goBack = _goback;
    [_goback release];
    
    UIButton *_goForward = [[UIButton alloc] initWithFrame:CGRectMake(_goback.frame.size.width+_goback.frame.origin.x+55, _goback.frame.origin.y, 31, 49)];
    [_goForward setBackgroundImage:[Util imageWithName:@"btn_forward_normal"] forState:UIControlStateDisabled];
    [_goForward setBackgroundImage:[Util imageWithName:@"btn_forward_highlighted"] forState:UIControlStateHighlighted];
    [_goForward setBackgroundImage:[Util imageWithName:@"btn_forward_disable"] forState:UIControlStateNormal];
    [_goForward addTarget:self action:@selector(forwardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionBar addSubview:_goForward];
    self.goForward = _goForward;
    [_goForward release];
    
    UIButton *_reload = [[UIButton alloc] initWithFrame:CGRectMake(_goForward.frame.size.width+_goForward.frame.origin.x+55, _goForward.frame.origin.y, 31, 49)];
    [_reload setBackgroundImage:[Util imageWithName:@"btn_refresh_web_normal"] forState:UIControlStateNormal];
    [_reload setBackgroundImage:[Util imageWithName:@"btn_refresh_web_highlighted"] forState:UIControlStateHighlighted];
    [_reload addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionBar addSubview:_reload];
    self.reloadWeb = _reload;
    [_reload release];
    
    UIButton *_stop = [[UIButton alloc] initWithFrame:_reload.frame];
    [_stop setBackgroundImage:[Util imageWithName:@"btn_cancel_normal"] forState:UIControlStateNormal];
    [_stop setBackgroundImage:[Util imageWithName:@"btn_cancel_highlighted"] forState:UIControlStateHighlighted];
    [_stop addTarget:self action:@selector(stopLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionBar addSubview:_stop];
    self.stopLoad = _stop;
    [_stop release];
    
    UIButton *_safari = [[UIButton alloc] initWithFrame:CGRectMake(self.actionBar.bounds.size.width-31-16, _goback.frame.origin.y, 31, 49)];
    [_safari setBackgroundImage:[Util imageWithName:@"btn_safari_normal"] forState:UIControlStateNormal];
    [_safari setBackgroundImage:[Util imageWithName:@"btn_safari_highlighted"] forState:UIControlStateHighlighted];
    [_safari addTarget:self action:@selector(openInSafariAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionBar addSubview:_safari];
    self.openSafari = _safari;
    [_safari release];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlPath]];
    [self.webView loadRequest:request];
    
    [self refreshActionBar];
}

#pragma mark actions
- (void)refreshActionBar {
    self.goBack.enabled = self.webView.canGoBack ? YES : NO;
    self.goForward.enabled = self.webView.canGoForward ? YES : NO;
    if (self.webView.loading) {
        self.stopLoad.hidden = NO;
        self.reloadWeb.hidden = YES;
    } else {
        self.stopLoad.hidden = YES;
        self.reloadWeb.hidden = NO;
    }
}
- (void)stopLoadAction:(id)sender {
    [self.webView stopLoading];
}
- (void)refreshAction:(id)sender {
    [self.webView reload];
}
- (void)forwardAction:(id)sender {
    [self.webView goForward];
}
- (void)backwordAction:(id)sender {
    [self.webView goBack];
}
- (void)openInSafariAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Open Safari",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0: 
			[[UIApplication sharedApplication] openURL:[self.webView.request URL]];
			break;
		default:
			break;
	}
}

#pragma mark webview manager
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    return YES;
//}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.title = @"Loading";
    [self refreshActionBar];
}
- (void)webViewDidFinishLoad:(UIWebView *)awebView {
    self.title = [awebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self refreshActionBar];
}
- (void)webView:(UIWebView *)awebView didFailLoadWithError:(NSError *)error {
    [self refreshActionBar];
}

@end
