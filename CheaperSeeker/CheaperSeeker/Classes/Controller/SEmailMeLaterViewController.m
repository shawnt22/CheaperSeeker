//
//  SEmailMeLaterViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-27.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SEmailMeLaterViewController.h"
#import "SSetting.h"

@interface SEmailMeLaterViewController ()
@property (nonatomic, assign) UIView *contentBGView;
@property (nonatomic, assign) UITextView *descriptionField;
@property (nonatomic, assign) UITextField *emailField;
- (void)saveEmail;
@end

@implementation SEmailMeLaterViewController
@synthesize coupon;
@synthesize descriptionField, emailField;
@synthesize contentBGView;

- (id)initWithCoupon:(id)cpn {
    self = [super init];
    if (self) {
        self.coupon = cpn;
    }
    return self;
}
- (void)dealloc {
    self.coupon = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = k_text_email_me_later_controller_title;
    
    UIBarButtonItem *_eml = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(emailAction:)];
    self.navigationItem.rightBarButtonItem = _eml;
    [_eml release];
    
    UIView *_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 176.0)];
    _bg.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_bg];
    self.contentBGView = _bg;
    [_bg release];
    
    CGFloat _margin_left = 10.0;
    CGFloat _margin_top = 10.0;
    
    UITextField *_txt = [[UITextField alloc] initWithFrame:CGRectMake(_margin_left, _margin_top, _bg.bounds.size.width-_margin_left*2, 36.0)];
    _txt.font = [UIFont systemFontOfSize:20];
    _txt.returnKeyType = UIReturnKeyDone;
    _txt.borderStyle = UITextBorderStyleBezel;
    _txt.backgroundColor = _bg.backgroundColor;
    _txt.placeholder = k_text_email_me_later_txtfield_placeholder;
    _txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txt.text = ((SGSetting *)[SGSetting shareSetting]).email;
    [_bg addSubview:_txt];
    self.emailField = _txt;
    [_txt release];
    
    [_txt becomeFirstResponder];
    
    UITextView *_desc = [[UITextView alloc] initWithFrame:CGRectMake(_txt.frame.origin.x, _txt.frame.origin.y+_txt.frame.size.height+10, _txt.frame.size.width, 130.0)];
    _desc.backgroundColor = _bg.backgroundColor;
    _desc.editable = NO;
    _desc.font = [UIFont systemFontOfSize:16];
    _desc.textColor = [UIColor grayColor];
    _desc.text = k_text_email_me_later_description;
    [_bg addSubview:_desc];
    [_desc release];
    
    MBProgressHUD *_hud = [[MBProgressHUD alloc] initWithView:_bg];
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.userInteractionEnabled = YES;
    self.messageHUD = _hud;
    [_hud release];
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMessageHUDAction:)];
    [_hud addGestureRecognizer:_tap];
    [_tap release];
}
- (void)emailAction:(id)sender {
    if ([Util isEmptyString:self.emailField.text]) {
        [self showMessageHUD:k_text_error_email_me_empty_email Animated:YES];
        return;
    }
    [self saveEmail];
    //  todo : post to server
    
    //  todo : 成功post后返回
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveEmail {
    SGSetting *setting = [SGSetting shareSetting];
    setting.email = self.emailField.text;
    [setting save];
}
- (void)showMessageHUD:(NSString *)title Animated:(BOOL)animated {
    if (!self.messageHUD.superview) {
        [self.contentBGView addSubview:self.messageHUD];
    }
    [super showMessageHUD:title Animated:animated];
}

@end
