//
//  SViewController.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SViewController.h"

@implementation SViewController
@synthesize splitNavigationController, splitViewController;
@synthesize messageHUD;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        [self initSubobjects];
        self.wantsFullScreenLayout = YES;
    }
    return self;
}
- (void)initSubobjects {
}
- (void)dealloc {
    self.messageHUD = nil;
    [super dealloc];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCustomCellBGFillColor;
//    self.navigationController.navigationBar.tintColor = SRGBCOLOR(255, 195, 24);
    
    MBProgressHUD *_hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    _hud.userInteractionEnabled = YES;
    _hud.removeFromSuperViewOnHide = YES;
    self.messageHUD = _hud;
    [_hud release];
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMessageHUDAction:)];
    [_hud addGestureRecognizer:_tap];
    [_tap release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark SplitController Protocol
- (UINavigationController<SSplitControllerProtocol> *)splitNavigationController {
    return [SSplitContentUtil splitNavigationControllerWithSplitViewController:self];
}
- (UIViewController<SSplitControllerProtocol> *)splitViewController {
    return self;
}

#pragma mark hud
- (void)showMessageHUD:(NSString *)title Animated:(BOOL)animated {
    [self showMessageHUD:title Message:nil Animated:animated];
}
- (void)showMessageHUD:(NSString *)title Message:(NSString *)message Animated:(BOOL)animated {
    if (!self.messageHUD.superview) {
        [self.view addSubview:self.messageHUD];
    }
    [self.view bringSubviewToFront:self.messageHUD];
    self.messageHUD.labelText = title;
    self.messageHUD.detailsLabelText = message;
    [self.messageHUD show:animated];
}
- (void)hideMessageHUD:(BOOL)animated {
    [self.messageHUD hide:animated];
}
- (void)hideMessageHUDAction:(id)sender {
    [self hideMessageHUD:YES];
}

@end
