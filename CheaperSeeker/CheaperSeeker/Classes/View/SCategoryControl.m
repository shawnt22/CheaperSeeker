//
//  SCategoryControl.m
//  SCategoryControlDemo
//
//  Created by 滕 松 on 12-10-25.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCategoryControl.h"

@interface SCategoryControl()
@property (nonatomic, assign) UIScrollView *controlScrollView;
@property (nonatomic, retain) NSMutableDictionary *reusableStorage;
@property (nonatomic, retain) NSMutableArray *activingItems;
@property (nonatomic, assign) SCategoryIndexPath lastSelectedCategoryItemIndexPath;
@property (nonatomic, assign) SCategoryIndexPath currentSelectedCategoryItemIndexPath;

- (void)removeItem:(UIView<SCategoryItemProtocol> *)item withIdentifier:(NSString *)identifier fromStorage:(NSMutableDictionary *)storage;
- (void)addItem:(UIView<SCategoryItemProtocol> *)item withIdentifier:(NSString *)identifier toStorage:(NSMutableDictionary *)storage;
- (UIView<SCategoryItemProtocol> *)dequeueItemWithIdentifier:(NSString *)identifier inStorage:(NSMutableDictionary *)storage;
- (void)clearControl;
- (void)check;
- (CGRect)itemFrameAtIndexPath:(SCategoryIndexPath)indexPath;
- (CGSize)controlContentSize;
- (void)fillFreeFieldWithLeftItem:(UIView<SCategoryItemProtocol> *)leftItem RightItem:(UIView<SCategoryItemProtocol> *)rightItem visiableItems:(NSMutableArray *)items visiableRect:(CGRect)visiableRect;
- (void)appearItem:(UIView<SCategoryItemProtocol> *)item indexPath:(SCategoryIndexPath)indexPath;
- (void)disappearItem:(UIView<SCategoryItemProtocol> *)item;

- (void)performSelectItemAtIndexPath:(SCategoryIndexPath)indexPath;

- (BOOL)isAvalidIndexPath:(SCategoryIndexPath)indexPath;
- (UIView<SCategoryItemProtocol> *)activingItemWithIndexPath:(SCategoryIndexPath)indexPath;

@end

#pragma mark - Notify
@interface SCategoryControl(Notify)
- (UIView<SCategoryItemProtocol> *)notifyCategoryControl:(SCategoryControl *)categoryControl itemAtIndexPath:(SCategoryIndexPath)indexPath;
- (NSInteger)notifyItemNumberOfCategoryControl:(SCategoryControl *)categoryControl;
- (CGFloat)notifyCategoryControl:(SCategoryControl *)categoryControl widthAtIndexPath:(SCategoryIndexPath)indexPath;
- (CGFloat)notifyCategoryControl:(SCategoryControl *)categoryControl heightAtIndexPath:(SCategoryIndexPath)indexPath;
- (CGFloat)notifyCategoryControl:(SCategoryControl *)categoryControl marginLeftAtIndexPath:(SCategoryIndexPath)indexPath;
- (void)notifyCategoryControl:(SCategoryControl *)categoryControl didSelectItem:(UIView<SCategoryItemProtocol> *)item;
@end

#pragma mark SelectItem
@interface SCategoryControl(ItemSelected)
- (void)resetItemState:(UIView<SCategoryItemProtocol> *)item indexPath:(SCategoryIndexPath)indexPath;
- (void)resetStateAndNotifySelectWithItem:(UIView<SCategoryItemProtocol> *)item;
@end
@implementation SCategoryControl(ItemSelected)
- (void)resetItemState:(UIView<SCategoryItemProtocol> *)item indexPath:(SCategoryIndexPath)indexPath {
    item.itemState = SCategoryIndexPathEqual(self.currentSelectedCategoryItemIndexPath, indexPath) ? UIControlStateSelected : UIControlStateNormal;
}
- (void)resetStateAndNotifySelectWithItem:(UIView<SCategoryItemProtocol> *)item {
    self.lastSelectedCategoryItemIndexPath = self.currentSelectedCategoryItemIndexPath;
    self.currentSelectedCategoryItemIndexPath = item.itemIndexPath;
    
    [self activingItemWithIndexPath:self.lastSelectedCategoryItemIndexPath].itemState = UIControlStateNormal;
    item.itemState = UIControlStateSelected;
    [self notifyCategoryControl:self didSelectItem:item];
}
- (void)categoryItem:(UIView<SCategoryItemProtocol> *)item responseTapGesture:(UITapGestureRecognizer *)tapGesture {
    switch (tapGesture.state) {
        case UIGestureRecognizerStateRecognized:
        {
            [self resetStateAndNotifySelectWithItem:item];
        }
            break;
        default:
            break;
    }
}
@end

@implementation SCategoryControl(Notify)
- (NSInteger)notifyItemNumberOfCategoryControl:(SCategoryControl *)categoryControl {
    if (self.controlDataSource && [self.controlDataSource respondsToSelector:@selector(itemNumberOfCategoryControl:)]) {
        return [self.controlDataSource itemNumberOfCategoryControl:categoryControl];
    }
    return 0;
}
- (CGFloat)notifyCategoryControl:(SCategoryControl *)categoryControl widthAtIndexPath:(SCategoryIndexPath)indexPath {
    if (self.controlDataSource && [self isAvalidIndexPath:indexPath] && [self.controlDataSource respondsToSelector:@selector(categoryControl:widthAtIndexPath:)]) {
        return [self.controlDataSource categoryControl:categoryControl widthAtIndexPath:indexPath];
    }
    return 0.0f;
}
- (CGFloat)notifyCategoryControl:(SCategoryControl *)categoryControl heightAtIndexPath:(SCategoryIndexPath)indexPath {
    if (self.controlDataSource && [self isAvalidIndexPath:indexPath] && [self.controlDataSource respondsToSelector:@selector(categoryControl:heightAtIndexPath:)]) {
        return [self.controlDataSource categoryControl:categoryControl heightAtIndexPath:indexPath];
    }
    return 0.0f;
}
- (CGFloat)notifyCategoryControl:(SCategoryControl *)categoryControl marginLeftAtIndexPath:(SCategoryIndexPath)indexPath {
    if (self.controlDataSource && [self isAvalidIndexPath:indexPath] && [self.controlDataSource respondsToSelector:@selector(categoryControl:marginLeftAtIndexPath:)]) {
        return [self.controlDataSource categoryControl:categoryControl marginLeftAtIndexPath:indexPath];
    }
    return k_categorycontrol_item_margin_left;
}
- (UIView<SCategoryItemProtocol> *)notifyCategoryControl:(SCategoryControl *)categoryControl itemAtIndexPath:(SCategoryIndexPath)indexPath {
    if (self.controlDataSource && [self isAvalidIndexPath:indexPath] && [self.controlDataSource respondsToSelector:@selector(categoryControl:itemAtIndexPath:)]) {
        UIView<SCategoryItemProtocol> *_result = [self.controlDataSource categoryControl:categoryControl itemAtIndexPath:indexPath];
        _result.itemIndexPath = indexPath;
        _result.itemDelegate = self;
        [self resetItemState:_result indexPath:indexPath];
        return _result;
    }
    return nil;
}
- (void)notifyCategoryControl:(SCategoryControl *)categoryControl didSelectItem:(UIView<SCategoryItemProtocol> *)item {
    if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(categoryControl:didSelectItem:)]) {
        [self.controlDelegate categoryControl:categoryControl didSelectItem:item];
    }
}
@end


#pragma mark - Control
@implementation SCategoryControl
@synthesize controlScrollView;
@synthesize controlDataSource, controlDelegate;
@synthesize reusableStorage, activingItems;
@synthesize lastSelectedCategoryItemIndexPath, currentSelectedCategoryItemIndexPath;

#pragma mark init dealloc
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.reusableStorage = [NSMutableDictionary dictionary];
        self.activingItems = [NSMutableArray array];
        
        self.lastSelectedCategoryItemIndexPath = SCategoryIndexPathMake(-1);
        self.currentSelectedCategoryItemIndexPath = SCategoryIndexPathMake(-1);
        
        UIScrollView *_scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scroll.backgroundColor = self.backgroundColor;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.delegate = self;
        [self addSubview:_scroll];
        self.controlScrollView = _scroll;
        [_scroll release];
    }
    return self;
}
- (void)dealloc {
    self.reusableStorage = nil;
    self.activingItems = nil;
    
    [super dealloc];
}

#pragma mark item manager
- (UIView<SCategoryItemProtocol> *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    return [self dequeueItemWithIdentifier:identifier inStorage:self.reusableStorage];
}
- (void)addItem:(UIView<SCategoryItemProtocol> *)item withIdentifier:(NSString *)identifier toStorage:(NSMutableDictionary *)storage {
    if (!item) {
        return;
    }
    NSMutableArray *_items = [storage objectForKey:identifier];
    if (!_items) {
        _items = [NSMutableArray array];
        [storage setObject:_items forKey:identifier];
    }
    [_items addObject:item];
}
- (void)removeItem:(UIView<SCategoryItemProtocol> *)item withIdentifier:(NSString *)identifier fromStorage:(NSMutableDictionary *)storage {
    if (!item) {
        return;
    }
    NSMutableArray *_items = [storage objectForKey:identifier];
    [_items removeObject:item];
}
- (UIView<SCategoryItemProtocol> *)dequeueItemWithIdentifier:(NSString *)identifier inStorage:(NSMutableDictionary *)storage {
    NSMutableArray *_items = [storage objectForKey:identifier];
    if (!_items) {
        _items = [NSMutableArray array];
        [storage setObject:_items forKey:identifier];
    }
    return [_items lastObject];
}
- (void)reloadControl {
    [self clearControl];
    self.controlScrollView.contentSize = [self controlContentSize];
    [self check];
}
- (void)clearControl {
    for (UIView *_item in self.activingItems) {
        [_item removeFromSuperview];
    }
    self.reusableStorage = [NSMutableDictionary dictionary];
    self.activingItems = [NSMutableArray array];
}
- (void)appearItem:(UIView<SCategoryItemProtocol> *)item indexPath:(SCategoryIndexPath)indexPath {
    item.frame = [self itemFrameAtIndexPath:indexPath];
    
    [self.controlScrollView addSubview:item];
    [self.controlScrollView sendSubviewToBack:item];
    [self.activingItems addObject:item];
    [self removeItem:item withIdentifier:item.reusableIdentifier fromStorage:self.reusableStorage];
}
- (void)disappearItem:(UIView<SCategoryItemProtocol> *)item {
    [self addItem:item withIdentifier:item.reusableIdentifier toStorage:self.reusableStorage];
    if (item.superview) {
        [item removeFromSuperview];
    }
    [self.activingItems removeObject:item];
}
- (BOOL)isAvalidIndexPath:(SCategoryIndexPath)indexPath {
    return indexPath.column > -1 && indexPath.column < [self notifyItemNumberOfCategoryControl:self] ? YES : NO;
}
- (UIView<SCategoryItemProtocol> *)activingItemWithIndexPath:(SCategoryIndexPath)indexPath {
    UIView<SCategoryItemProtocol> *_result = nil;
    for (UIView<SCategoryItemProtocol> *_item in self.activingItems) {
        if (SCategoryIndexPathEqual(indexPath, _item.itemIndexPath)) {
            _result = _item;
            break;
        }
    }
    return _result;
}
- (void)selectItemAtIndexPath:(SCategoryIndexPath)indexPath Animated:(BOOL)animated {
    CGRect _itemFrame = [self itemFrameAtIndexPath:indexPath];
    [self.controlScrollView scrollRectToVisible:_itemFrame animated:animated];
    
    if (animated) {
        [self performSelector:@selector(delayPerformSelectItemAtIndexPathValue:) withObject:NSStringFromSCategoryIndexPath(indexPath) afterDelay:0.5];
    } else {
        [self performSelectItemAtIndexPath:indexPath];
    }
}
- (void)delayPerformSelectItemAtIndexPathValue:(NSString *)indexPathValue {
    [self performSelectItemAtIndexPath:SCategoryIndexPathFromNSString(indexPathValue)];
}
- (void)performSelectItemAtIndexPath:(SCategoryIndexPath)indexPath {
    UIView<SCategoryItemProtocol> *_item = [self activingItemWithIndexPath:indexPath];
    if (_item) {
        [self resetStateAndNotifySelectWithItem:_item];
    }
}

#pragma mark scroll delegae
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self check];
}
- (void)check {
    //  可视区为两屏
    CGFloat _x = self.controlScrollView.contentOffset.x - self.controlScrollView.bounds.size.width/2;
    _x = _x < 0.0 ? 0.0 : _x;
    CGRect _visiableRect = CGRectMake(_x, self.controlScrollView.contentOffset.y, self.controlScrollView.bounds.size.width*2, self.controlScrollView.bounds.size.height);
    UIView<SCategoryItemProtocol> *_leftItem = nil;
    UIView<SCategoryItemProtocol> *_rightItem = nil;
    for (NSInteger _index = 0; _index < [self.activingItems count]; _index++) {
        UIView<SCategoryItemProtocol> *_item = [self.activingItems objectAtIndex:_index];
        CGRect _intersection = CGRectIntersection(_visiableRect, _item.frame);
        //  移除不在当前屏内的item
        if (CGRectIsEmpty(_intersection)) {
            [self disappearItem:_item];
            _index--;
            continue;
        }
        //  找到最左侧item
        if (_leftItem == nil) {
            _leftItem = _item;
        } else {
            _leftItem = _leftItem.frame.origin.x < _item.frame.origin.x ? _leftItem : _item;
        }
        //  找到最右侧item
        if (_rightItem == nil) {
            _rightItem = _item;
        } else {
            _rightItem = _rightItem.frame.origin.x+_rightItem.frame.size.width > _item.frame.size.width+_item.frame.origin.x ? _rightItem : _item;
        }
    }
    [self fillFreeFieldWithLeftItem:_leftItem RightItem:_rightItem visiableItems:self.activingItems visiableRect:_visiableRect];
}
//  每列递归填充空白区域
- (void)fillFreeFieldWithLeftItem:(UIView<SCategoryItemProtocol> *)leftItem RightItem:(UIView<SCategoryItemProtocol> *)rightItem visiableItems:(NSMutableArray *)items visiableRect:(CGRect)visiableRect {
    BOOL _needRecall = NO;
    //  区域尚无item，直接添加第一个
    if (!leftItem && !rightItem) {
        SCategoryIndexPath _indexPath = SCategoryIndexPathMake(0);
        UIView<SCategoryItemProtocol> *_item = [self notifyCategoryControl:self itemAtIndexPath:_indexPath];
        if (_item) {
            [self appearItem:_item indexPath:_indexPath];
            leftItem = _item;
            rightItem = _item;
            _needRecall = YES;
        }
    }
    //  若左方未填满，则在左方添加一个item
    if (leftItem && leftItem.frame.origin.x > visiableRect.origin.x) {
        SCategoryIndexPath _indexPath = SCategoryIndexPathMake(leftItem.itemIndexPath.column - 1);
        UIView<SCategoryItemProtocol> *_item = [self notifyCategoryControl:self itemAtIndexPath:_indexPath];
        if (_item) {
            [self appearItem:_item indexPath:_indexPath];
            leftItem = _item;
            _needRecall = YES;
        }
    }
    //  若右方未填满，则在右方添加一个item
    if (rightItem && rightItem.frame.origin.x+rightItem.frame.size.width < visiableRect.origin.x+visiableRect.size.width) {
        SCategoryIndexPath _indexPath = SCategoryIndexPathMake(rightItem.itemIndexPath.column + 1);
        UIView<SCategoryItemProtocol> *_item = [self notifyCategoryControl:self itemAtIndexPath:_indexPath];
        if (_item) {
            [self appearItem:_item indexPath:_indexPath];
            rightItem = _item;
            _needRecall = YES;
        }
    }
    if (_needRecall) {
        [self fillFreeFieldWithLeftItem:leftItem RightItem:rightItem visiableItems:items visiableRect:visiableRect];
    }
}
- (CGSize)controlContentSize {
    CGSize _contentSize = CGSizeZero;
    for (NSInteger index = 0; index < [self notifyItemNumberOfCategoryControl:self]; index++) {
        SCategoryIndexPath _indexPath = SCategoryIndexPathMake(index);
        CGFloat _marginLeft = [self notifyCategoryControl:self marginLeftAtIndexPath:_indexPath];
        _contentSize.width += (index == 0 ? 0 : _marginLeft) + [self notifyCategoryControl:self widthAtIndexPath:_indexPath];
    }
    _contentSize.width = _contentSize.width > self.controlScrollView.bounds.size.width ? _contentSize.width : self.controlScrollView.bounds.size.width + 1;
    _contentSize.height = self.controlScrollView.bounds.size.height;
    return _contentSize;
}
- (CGRect)itemFrameAtIndexPath:(SCategoryIndexPath)indexPath {
    CGFloat _width = [self notifyCategoryControl:self widthAtIndexPath:indexPath];
    CGFloat _height = [self notifyCategoryControl:self heightAtIndexPath:indexPath];
    CGFloat _y = ceilf((self.controlScrollView.bounds.size.height - _height)/2);
    
    CGFloat _x = 0.0;
    for (NSInteger index = 0; index < indexPath.column; index++) {
        SCategoryIndexPath _indexPath = SCategoryIndexPathMake(index);
        CGFloat _mleft = [self notifyCategoryControl:self marginLeftAtIndexPath:_indexPath];
        _x += _mleft + [self notifyCategoryControl:self widthAtIndexPath:_indexPath];
    }
    _x = _x > 0.0 ? _x : 0.0;
    
    return CGRectMake(_x, _y, _width, _height);
}

@end



