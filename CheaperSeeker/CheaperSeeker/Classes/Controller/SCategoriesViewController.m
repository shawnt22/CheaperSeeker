//
//  SCategoriesViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCategoriesViewController.h"
#import "SCategoryCell.h"

@interface SCategoriesViewController()
@property (nonatomic, assign) TSPullTableView *categoriesTableView;
@property (nonatomic, retain) CSCategoriesDataStore *categoriesDataStore;
@end
@implementation SCategoriesViewController
@synthesize categoriesDataStore, categoriesTableView;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        CSCategoriesDataStore *_ds = [[CSCategoriesDataStore alloc] initWithDelegate:self];
        self.categoriesDataStore = _ds;
        [_ds release];
    }
    return self;
}
- (void)dealloc {
    [self.categoriesDataStore cancelAllRequests];
    self.categoriesDataStore.delegate = nil;
    self.categoriesDataStore = nil;
    [super dealloc];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = kViewControllerCategoryTitle;
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    TSPullTableView *_tb = [[TSPullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _tb.backgroundColor = self.view.backgroundColor;
    _tb.dataSource = self;
    _tb.pullDelegate = self;
    [self.view addSubview:_tb];
    self.categoriesTableView = _tb;
    [_tb release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark table delegate
- (void)tableViewPullToRefresh:(TSPullTableView *)tableView {
    [self.categoriesDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
}
- (void)tableViewPullToLoadmore:(TSPullTableView *)tableView {
    [self.categoriesDataStore loadmoreItems];
}
- (void)tableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SCategoryCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoriesDataStore.items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"category";
    SCategoryCell *_cell = (SCategoryCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    id _category = [self.categoriesDataStore.items objectAtIndex:indexPath.row];
    [_cell refreshWithCategory:_category];
    return _cell;
}

#pragma mark dataloader delegate
- (void)dataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request {}
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        [self.categoriesTableView finishPullToRefreshWithAnimated:YES];
        [self.categoriesTableView reloadDataWithDataFull:![self.categoriesDataStore canLoadMore]];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self.categoriesTableView finishPullToLoadmoreWithAnimated:YES];
        [self.categoriesTableView reloadDataWithDataFull:![self.categoriesDataStore canLoadMore]];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    if (request.tag == SURLRequestItemsRefresh) {
        [self.categoriesTableView finishPullToRefreshWithAnimated:YES];
        return;
    }
    if (request.tag == SURLRequestItemsLoadmore) {
        [self.categoriesTableView finishPullToLoadmoreWithAnimated:YES];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request {}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}

@end
