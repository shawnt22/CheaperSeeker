//
//  SCouponWebViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-11-9.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponWebViewController.h"

@interface SCouponWebViewController ()
@property (nonatomic, assign) BOOL isCodeContentViewShowing;
@property (nonatomic, assign) SCouponCodeContentView *codeContentView;
- (BOOL)hasCouponCode;
- (void)refreshCodeButton;
- (void)createCodeContentView;
- (void)showCodeContentViewWithAnimated:(BOOL)animated;
- (void)hideCodeContentViewWithAnimated:(BOOL)animated;
- (void)finishShowCodeContentViewWithAnimation;
- (void)finishHideCodeContentViewWithAnimation;
- (NSString *)couponCode;
@end

@implementation SCouponWebViewController
@synthesize isCodeContentViewShowing, codeContentView;
@synthesize coupon;

- (void)dealloc {
    self.coupon = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self hasCouponCode]) {
        [self refreshCodeButton];
        [self createCodeContentView];
    }
}
- (NSString *)couponCode {
    return [self.coupon objectForKey:k_coupon_code];
}

#pragma mark actions
- (BOOL)hasCouponCode {
    return [self couponCode] ? YES : NO;
}
- (void)refreshCodeButton {
    NSString *_ttl = self.isCodeContentViewShowing ? k_coupon_web_viewcontroller_bar_buttion_copy_code : k_coupon_web_viewcontroller_bar_buttion_show_code;
    SEL _action = self.isCodeContentViewShowing ? @selector(copyCodeAction:) : @selector(showCodeContentViewAction:);
    
    UIBarButtonItem *_btn = [[UIBarButtonItem alloc] initWithTitle:_ttl style:UIBarButtonItemStyleDone target:self action:_action];
    self.navigationItem.rightBarButtonItem = _btn;
    [_btn release];
}
- (void)showCodeContentViewAction:(id)sender {
    [self showCodeContentViewWithAnimated:YES];
}
- (void)copyCodeAction:(id)sender {
    [self hideCodeContentViewWithAnimated:YES];
    UIPasteboard *_pasteboard = [UIPasteboard generalPasteboard];
    _pasteboard.string = [self couponCode];
}

#pragma mark code content
#define k_coupon_code_content_view_height   30.0
#define k_coupon_code_content_view_origin_y_hide    -k_coupon_code_content_view_height
#define k_coupon_code_content_view_origin_y_show    0.0
#define k_coupon_code_content_view_animation_duration   0.3
- (void)createCodeContentView {
    SCouponCodeContentView *_contentView = [[SCouponCodeContentView alloc] initWithFrame:CGRectMake(0, k_coupon_code_content_view_origin_y_hide, self.view.bounds.size.width, k_coupon_code_content_view_height)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_contentView];
    self.codeContentView = _contentView;
    [_contentView release];
    
    [self.codeContentView refreshContentViewWithCoupon:self.coupon];
}
- (void)showCodeContentViewWithAnimated:(BOOL)animated {
    CGRect _f = self.codeContentView.frame;
    _f.origin.y = k_coupon_code_content_view_origin_y_show;
    if (animated) {
        [UIView beginAnimations:@"showCode" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:k_coupon_code_content_view_animation_duration];
        [UIView setAnimationDidStopSelector:@selector(finishShowCodeContentViewWithAnimation)];
        self.codeContentView.frame = _f;
        [UIView commitAnimations];
    } else {
        self.codeContentView.frame = _f;
        [self finishShowCodeContentViewWithAnimation];
    }
}
- (void)hideCodeContentViewWithAnimated:(BOOL)animated {
    CGRect _f = self.codeContentView.frame;
    _f.origin.y = k_coupon_code_content_view_origin_y_hide;
    if (animated) {
        [UIView beginAnimations:@"hideCode" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:k_coupon_code_content_view_animation_duration];
        [UIView setAnimationDidStopSelector:@selector(finishHideCodeContentViewWithAnimation)];
        self.codeContentView.frame = _f;
        [UIView commitAnimations];
    } else {
        self.codeContentView.frame = _f;
        [self finishHideCodeContentViewWithAnimation];
    }
}
- (void)finishShowCodeContentViewWithAnimation {
    self.isCodeContentViewShowing = YES;
    [self refreshCodeButton];
}
- (void)finishHideCodeContentViewWithAnimation {
    self.isCodeContentViewShowing = NO;
    [self refreshCodeButton];
}

@end
