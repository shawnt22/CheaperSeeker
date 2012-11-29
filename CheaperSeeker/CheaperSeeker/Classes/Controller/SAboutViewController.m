//
//  SAboutViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SAboutViewController.h"
#import "SAboutCell.h"
#import "SUtil.h"
#import "Util.h"
#import "Sconfiger.h"
#import "SWebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SAboutViewController()
@property (nonatomic, retain) id aboutInfo;
@property (nonatomic, retain) CSAboutInfoDataStore *aboutInfoDataStore;
@property (nonatomic, assign) UITableView *theTableView;
- (void)showWebSite;
- (void)postAdvice;
- (void)appraiseApp;
- (void)createLogoView;
- (void)createPrivacyView;
- (NSURL *)emailURL;
@end

@implementation SAboutViewController
@synthesize theTableView;
@synthesize aboutInfoDataStore;
@synthesize aboutInfo;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        CSAboutInfoDataStore *_ds = [[CSAboutInfoDataStore alloc] initWithDelegate:self];
        self.aboutInfoDataStore = _ds;
        [_ds release];
    }
    return self;
}
- (void)dealloc {
    [self.aboutInfoDataStore cancelAllRequests];
    self.aboutInfoDataStore.delegate = nil;
    self.aboutInfoDataStore = nil;
    
    self.aboutInfo = nil;
    
    [super dealloc];
}
- (NSURL *)emailURL {
    NSString *_path = [NSString stringWithFormat:@"mailto:%@", [self.aboutInfo objectForKey:k_about_email]];
    return [NSURL URLWithString:_path];
}
- (void)createLogoView {
    UIView *_bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.theTableView.bounds.size.width, 180.0)];
    _bgview.backgroundColor = [UIColor clearColor];
    self.theTableView.tableHeaderView = _bgview;
    [_bgview release];
    
    CGFloat _width = 100.0;
    UIImageView *_logo = [[UIImageView alloc] initWithFrame:CGRectMake((_bgview.bounds.size.width-_width)/2, 35.0, _width, _width)];
    _logo.backgroundColor = [UIColor clearColor];
    _logo.image = [Util imageWithName:@"Icon@2x"];
    [_bgview addSubview:_logo];
    [_logo release];
    
    _width = 120.0;
    UILabel *_version = [[UILabel alloc]initWithFrame:CGRectMake(ceilf((_bgview.bounds.size.width-_width)/2), _logo.frame.size.height+_logo.frame.origin.y+20, _width, 20)];
    _version.backgroundColor = [UIColor clearColor];
    _version.font = [UIFont boldSystemFontOfSize:14];
    _version.textColor = SRGBCOLOR(107, 107, 107);
    _version.textAlignment = UITextAlignmentCenter;
    _version.text = [NSString stringWithFormat:@"%@%@", k_text_about_desc_version, [SUtil bundleVersion]];
    [_bgview addSubview:_version];
    [_version release];
}
- (void)createPrivacyView {
    UIView *_bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.theTableView.bounds.size.width, 70.0)];
    _bgview.backgroundColor = [UIColor clearColor];
    self.theTableView.tableFooterView = _bgview;
    [_bgview release];
    
    UIButton *_privacy = [[UIButton alloc] initWithFrame:CGRectMake(60.0, 0, 100, 44.0)];
    _privacy.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _privacy.backgroundColor = [UIColor clearColor];
    _privacy.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_privacy setTitle:k_text_about_privacy forState:UIControlStateNormal];
    [_privacy setTitleColor:SRGBCOLOR(107, 107, 107) forState:UIControlStateNormal];
    [_privacy addTarget:self action:@selector(showPrivacyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:_privacy];
    [_privacy release];
    
    UIButton *_terms = [[UIButton alloc] initWithFrame:CGRectMake(_privacy.frame.origin.x+_privacy.frame.size.width, _privacy.frame.origin.y, 100, _privacy.frame.size.height)];
    _terms.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _terms.backgroundColor = [UIColor clearColor];
    _terms.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_terms setTitle:k_text_about_terms forState:UIControlStateNormal];
    [_terms setTitleColor:SRGBCOLOR(107, 107, 107) forState:UIControlStateNormal];
    [_terms addTarget:self action:@selector(showTermsAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:_terms];
    [_terms release];
    
    UILabel *_and = [[UILabel alloc] initWithFrame:CGRectMake(0, _privacy.frame.origin.y, _bgview.frame.size.width, _privacy.frame.size.height)];
    _and.backgroundColor = [UIColor clearColor];
    _and.textAlignment = UITextAlignmentCenter;
    _and.font = [UIFont systemFontOfSize:14.0];
    _and.textColor = SRGBCOLOR(107, 107, 107);
    _and.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _and.text = @"&";
    [_bgview addSubview:_and];
    [_bgview sendSubviewToBack:_and];
    [_and release];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = kViewControllerAboutTitle;
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    UITableView *_tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStyleGrouped];
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tb.backgroundColor = self.view.backgroundColor;
    _tb.delegate = self;
    _tb.dataSource = self;
    [self.view addSubview:_tb];
    self.theTableView = _tb;
    [_tb release];
    
    [self createLogoView];
    [self createPrivacyView];
    
    [self.aboutInfoDataStore getAboutInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"about";
    SAboutCell *_cell = (SAboutCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SAboutCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:_identifier] autorelease];
    }
    
    _cell.selectionStyle = indexPath.row == AboutTableRowEmail || indexPath.row == AboutTableRowSite ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
//    _cell.accessoryType = indexPath.row == AboutTableRowEmail || indexPath.row == AboutTableRowSite ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    [_cell refreshWithTitle:[SAboutViewController titleWithIndexPath:indexPath About:self.aboutInfo] Content:[SAboutViewController contentWithIndexPath:indexPath About:self.aboutInfo]];
    
    _cell.customBackgroundView.bgStyle = [TCustomCellBGView groupStyleWithIndex:indexPath.row Count:AboutTableRowCount];
    _cell.customSelectedBackgroundView.bgStyle = [TCustomCellBGView groupStyleWithIndex:indexPath.row Count:AboutTableRowCount];
    return _cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AboutTableRowCount;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SAboutCell cellHeightWithAbout:self.aboutInfo IndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case AboutTableRowSite:
            [self showWebSite];
            break;
        case AboutTableRowEmail:
            [self postAdvice];
            break;
        default:
            break;
    }
}

#pragma mark loader delegate
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    self.aboutInfo = request.formatedResponse;
    [self.theTableView reloadData];
}
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    
}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}
- (void)showWebSite {
    SWebViewController *_web = [[SWebViewController alloc] initWithURLPath:[self.aboutInfo objectForKey:k_about_site_url]];
    [self.navigationController pushViewController:_web animated:YES];
    [_web release];
}
- (void)postAdvice {
    [[UIApplication sharedApplication] openURL:[self emailURL]];
}
- (void)appraiseApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=543480206"]];
}
- (void)showPrivacyAction:(id)sender {
    SWebViewController *_web = [[SWebViewController alloc] initWithURLPath:[self.aboutInfo objectForKey:k_about_privacy_url]];
    [self.navigationController pushViewController:_web animated:YES];
    [_web release];
}
- (void)showTermsAction:(id)sender {
    SWebViewController *_web = [[SWebViewController alloc] initWithURLPath:[self.aboutInfo objectForKey:k_about_terms_url]];
    [self.navigationController pushViewController:_web animated:YES];
    [_web release];
}

@end


@implementation SAboutViewController (DataManager)

+ (NSString *)contentWithIndexPath:(NSIndexPath *)indexPath About:(id)about {
    NSString *_key = nil;
    switch (indexPath.row) {
        case AboutTableRowDescription:
            _key = k_about_description;
            break;
        case AboutTableRowEmail:
            _key = k_about_email;
            break;
        case AboutTableRowSite:
            _key = k_about_site_title;
            break;
        case AboutTableRowAddress:
            _key = k_about_address;
            break;
        default:
            break;
    }
    return [about objectForKey:_key];
}
+ (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath About:(id)about {
    NSString *_ttl = nil;
    switch (indexPath.row) {
        case AboutTableRowDescription:
            _ttl = k_text_about_row_description;
            break;
        case AboutTableRowEmail:
            _ttl = k_text_about_row_email;
            break;
        case AboutTableRowSite:
            _ttl = k_text_about_row_site;
            break;
        case AboutTableRowAddress:
            _ttl = k_text_about_row_address;
            break;
        default:
            break;
    }
    return _ttl;
}

@end


