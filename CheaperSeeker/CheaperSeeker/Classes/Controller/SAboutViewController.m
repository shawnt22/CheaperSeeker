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
@property (nonatomic, assign) UITableView *theTableView;
- (void)showWebSite;
- (void)postAdvice;
- (void)appraiseApp;
- (void)createLogoView;
@end

#define kAboutSectionNumber 1
#define kAboutRowNumber     3
#define kAboutAdviceRow     1
#define kAboutStarRow       0
#define kAboutSiteRow       2

@implementation SAboutViewController
@synthesize theTableView;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
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
    _logo.layer.shadowOpacity = 0.7;
    [_bgview addSubview:_logo];
    [_logo release];
    
    _width = 120.0;
    UILabel *_version = [[UILabel alloc]initWithFrame:CGRectMake(ceilf((_bgview.bounds.size.width-_width)/2), _logo.frame.size.height+_logo.frame.origin.y+20, _width, 20)];
    _version.backgroundColor = [UIColor clearColor];
    _version.font = [UIFont systemFontOfSize:14];
    _version.textColor = SRGBCOLOR(107, 107, 107);
    _version.textAlignment = UITextAlignmentCenter;
    _version.text = [NSString stringWithFormat:@"%@%@", k_text_about_desc_version, [SUtil bundleVersion]];
    [_bgview addSubview:_version];
    [_version release];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"about";
    SAboutCell *_cell = (SAboutCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SAboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
    }
    
    NSString *_cellTitle = nil;
    switch (indexPath.row) {
        case kAboutStarRow:
            _cellTitle = k_text_about_cell_star;
            break;
        case kAboutSiteRow:
            _cellTitle = k_text_about_cell_site;
            break;
        case kAboutAdviceRow:
            _cellTitle = k_text_about_cell_advice;
            break;
        default:
            break;
    }
    [_cell refreshWithTitle:_cellTitle];
    _cell.customBackgroundView.bgStyle = [TCustomCellBGView groupStyleWithIndex:indexPath.row Count:kAboutRowNumber];
    _cell.customSelectedBackgroundView.bgStyle = [TCustomCellBGView groupStyleWithIndex:indexPath.row Count:kAboutRowNumber];
    return _cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kAboutRowNumber;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kAboutSectionNumber;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SAboutCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case kAboutStarRow:
            [self appraiseApp];
            break;
        case kAboutSiteRow:
            [self showWebSite];
            break;
        case kAboutAdviceRow:
            [self postAdvice];
            break;
        default:
            break;
    }
}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}
- (void)showWebSite {
    SWebViewController *_web = [[SWebViewController alloc] initWithURLPath:@"http://www.cheaperseeker.com/page/About-us"];
    [self.navigationController pushViewController:_web animated:YES];
    [_web release];
}
- (void)postAdvice {
    SWebViewController *_web = [[SWebViewController alloc] initWithURLPath:@"http://www.cheaperseeker.com/page/contact-us"];
    [self.navigationController pushViewController:_web animated:YES];
    [_web release];
}
- (void)appraiseApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=543480206"]];
}

@end
