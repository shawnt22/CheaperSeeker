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
@property (nonatomic, assign) UILabel *descriptionField;
@property (nonatomic, assign) UITextField *emailField;
- (void)saveEmail;
@end

@implementation SEmailMeLaterViewController
@synthesize coupon;
@synthesize descriptionField, emailField;

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
    
    CGFloat _margin_left = 10.0;
    CGFloat _margin_top = 10.0;
    
    UITextField *_txt = [[UITextField alloc] initWithFrame:CGRectMake(_margin_left, _margin_top, self.view.bounds.size.width-_margin_left*2, 36.0)];
    _txt.font = [UIFont systemFontOfSize:20];
    _txt.returnKeyType = UIReturnKeyDone;
    _txt.borderStyle = UITextBorderStyleBezel;
    _txt.backgroundColor = self.view.backgroundColor;
    _txt.delegate = self;
    _txt.placeholder = k_text_email_me_later_txtfield_placeholder;
    _txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txt.text = ((SGSetting *)[SGSetting shareSetting]).email;
    [self.view addSubview:_txt];
    self.emailField = _txt;
    [_txt release];
    
    [_txt becomeFirstResponder];
    
    UILabel *_lbl = [[UILabel alloc] initWithFrame:CGRectMake(_margin_left, _txt.frame.origin.y+_txt.frame.size.height+10, _txt.frame.size.width, 130.0)];
    _lbl.backgroundColor = [UIColor greenColor];
    _lbl.text = @"这得说点介绍什么的";
    [self.view addSubview:_lbl];
    [_lbl release];
}
- (void)emailAction:(id)sender {
    [self saveEmail];
    //  todo : post to server
    
    //  todo : 成功post后返回
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveEmail];
    return YES;
}
- (void)saveEmail {
    SGSetting *setting = [SGSetting shareSetting];
    setting.email = self.emailField.text;
    [setting save];
}

@end
