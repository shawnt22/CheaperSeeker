//
//  SCategoriesViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCategoriesViewController.h"
#import "SCategoryCell.h"
#import "SCategoryCouponsViewController.h"

@interface SCategoriesViewController()
@property (nonatomic, assign) UITableView *categoriesTableView;
@property (nonatomic, retain) CSCategoriesDataStore *categoriesDataStore;
@property (nonatomic, assign) SCategoryControl *categoriesControl;
@property (nonatomic, retain) NSMutableArray *categoryItemLayouts;
- (void)refreshAction:(id)sender;
@end
@implementation SCategoriesViewController
@synthesize categoriesDataStore, categoriesTableView, categoriesControl;
@synthesize categoryItemLayouts;

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        CSCategoriesDataStore *_ds = [[CSCategoriesDataStore alloc] initWithDelegate:self];
        self.categoriesDataStore = _ds;
        [_ds release];
        
        self.categoryItemLayouts = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc {
    [self.categoriesDataStore cancelAllRequests];
    self.categoriesDataStore.delegate = nil;
    self.categoriesDataStore = nil;
    
    self.categoryItemLayouts = nil;
    [super dealloc];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = kViewControllerCategoryTitle;
    [SUtil setNavigationBarSplitButtonItemWith:self];
    
    SCategoryControl *_ctr = [[SCategoryControl alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, k_categorycontrol_height)];
    _ctr.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    _ctr.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _ctr.controlDataSource = self;
    _ctr.controlDelegate = self;
    [self.view addSubview:_ctr];
    self.categoriesControl = _ctr;
    [_ctr release];
    
    CGFloat _y = _ctr.frame.origin.y + _ctr.frame.size.height;
    UITableView *_tb = [[UITableView alloc] initWithFrame:CGRectMake(0, _y, self.view.bounds.size.width, self.view.bounds.size.height-_y-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
    _tb.backgroundColor = self.view.backgroundColor;
    _tb.dataSource = self;
    _tb.delegate = self;
    [self.view addSubview:_tb];
    [self.view sendSubviewToBack:_tb];
    self.categoriesTableView = _tb;
    [_tb release];
    
    UIBarButtonItem *_refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    self.navigationItem.rightBarButtonItem = _refresh;
    [_refresh release];
    
    [self refreshAction:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark category control
- (UIView<SCategoryItemProtocol> *)categoryControl:(SCategoryControl *)categoryControl itemAtIndexPath:(SCategoryIndexPath)indexPath {
    NSString *_identifier = @"item";
    SCategoryItem *_item = (SCategoryItem *)[categoryControl dequeueReusableItemWithIdentifier:_identifier];
    if (!_item) {
        _item = [[[SCategoryItem alloc] defaultItemWithReusableIdentifier:_identifier] autorelease];
        _item.bgSelectedColor = SRGBCOLOR(255, 195, 24);
    }
    id _category = [self.categoriesDataStore.items objectAtIndex:indexPath.column];
    SCategoryItemLayout *_layout = [self.categoryItemLayouts objectAtIndex:indexPath.column];
    [_item refreshItemWithContent:[_category objectForKey:k_category_title] Frame:_layout.frame];
    return _item;
}
- (NSInteger)itemNumberOfCategoryControl:(SCategoryControl *)categoryControl {
    return [self.categoriesDataStore.items count];
}
- (CGFloat)categoryControl:(SCategoryControl *)categoryControl widthAtIndexPath:(SCategoryIndexPath)indexPath {
    SCategoryItemLayout *_layout = [self.categoryItemLayouts objectAtIndex:indexPath.column];
    return _layout.width;
}
- (CGFloat)categoryControl:(SCategoryControl *)categoryControl heightAtIndexPath:(SCategoryIndexPath)indexPath {
    SCategoryItemLayout *_layout = [self.categoryItemLayouts objectAtIndex:indexPath.column];
    return _layout.height;
}
- (void)categoryControl:(SCategoryControl *)categoryControl didSelectItem:(UIView<SCategoryItemProtocol> *)item {
    [self.categoriesTableView scrollRectToVisible:CGRectMake(0, 0, self.categoriesTableView.bounds.size.width, 1) animated:NO];
    [self.categoriesTableView reloadData];
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id _category = [[self currentSelectedCategoryItemSubcategories] objectAtIndex:indexPath.row];
    SCategoryCouponsViewController *_ccvctr = [[SCategoryCouponsViewController alloc] initWithCategory:_category];
    [self.navigationController pushViewController:_ccvctr animated:YES];
    [_ccvctr release];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SCategoryCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self currentSelectedCategoryItemSubcategories] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"category";
    SCategoryCell *_cell = (SCategoryCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    id _category = [[self currentSelectedCategoryItemSubcategories] objectAtIndex:indexPath.row];
    [_cell refreshWithCategory:_category];
    return _cell;
}

#pragma mark dataloader delegate
- (void)dataloader:(SDataLoader *)dataloader didStartRequest:(SURLRequest *)request {}
- (void)dataloader:(SDataLoader *)dataloader didFinishRequest:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.categoriesControl reloadControl];
        [self.categoriesControl selectItemAtIndexPath:SCategoryIndexPathMake(0) Animated:NO];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader submitResponse:(id)response Request:(SURLRequest *)request {
    if (request.tag == SURLRequestItemsRefresh) {
        self.categoryItemLayouts = [NSMutableArray array];
        NSArray *_categories = [request.formatedResponse objectForKey:kListDataStoreResponseItems];
        for (id _category in _categories) {
            SCategoryItemLayout *_layout = [[SCategoryItemLayout alloc] init];
            CGSize _size = [SCategoryItem itemSizeWithContent:[_category objectForKey:k_category_title] Font:k_category_item_content_font ConstrainedToSize:k_category_item_content_constrained_size];
            _layout.width = _size.width;
            _layout.height = _size.height;
            [self.categoryItemLayouts addObject:_layout];
            [_layout release];
        }
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader didFailRequest:(SURLRequest *)request Error:(NSError *)error {
    if (request.tag == SURLRequestItemsRefresh) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
}
- (void)dataloader:(SDataLoader *)dataloader didCancelRequest:(SURLRequest *)request {}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}
- (void)refreshAction:(id)sender {
    [self.categoriesDataStore refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

@end


@implementation SCategoriesViewController (DataManager)

+ (NSArray *)subcategoriesWith:(id)category {
    return [category objectForKey:k_category_subitems];
}
- (NSArray *)currentSelectedCategoryItemSubcategories {
    SCategoryIndexPath _currentIndexPath = self.categoriesControl.currentSelectedCategoryItemIndexPath;
    if (!SCategoryIndexPathIsInvalid(_currentIndexPath)) {
        return [SCategoriesViewController subcategoriesWith:[self.categoriesDataStore.items objectAtIndex:_currentIndexPath.column]];
    }
    return nil;
}

@end


@implementation SCategoryItemLayout
@synthesize width, height, frame;
- (CGRect)frame {
    return CGRectMake(0, 0, self.width, self.height);
}
@end

