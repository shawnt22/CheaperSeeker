//
//  SDragTableView.m
//
//
//  Created by Teng TengSong on 12-1-3.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "TSPullTableView.h"

#import "Sconfiger.h"

@interface TSPullTableView()
@property (nonatomic, assign) TSPullTableHeaderView *pullHeaderView;
@property (nonatomic, assign) TSPullTableFooterView *pullFooterView;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadingmore;

- (void)didFinishStartPullToRefreshAnimation;
- (void)didFinishStartPullToLoadmoreAnimation;
- (BOOL)checkPullToRefresh:(UIScrollView *)scrollView;
- (BOOL)checkPullToLoadmore:(UIScrollView *)scrollView;
@end

#pragma mark - TableView Notify
@interface TSPullTableView(Notify)
- (void)notifyTableViewPullToRefresh:(TSPullTableView *)tableView;
- (void)notifyTableViewPullToLoadmore:(TSPullTableView *)tableView;
- (void)notifyTableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)notifyTableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
@implementation TSPullTableView(Notify)
- (void)notifyTableViewPullToRefresh:(TSPullTableView *)tableView {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableViewPullToRefresh:)]) {
        [self.pullDelegate tableViewPullToRefresh:tableView];
    }
}
- (void)notifyTableViewPullToLoadmore:(TSPullTableView *)tableView {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableViewPullToLoadmore:)]) {
        [self.pullDelegate tableViewPullToLoadmore:tableView];
    }
}
- (void)notifyTableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.pullDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (CGFloat)notifyTableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.pullDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}

@end

#pragma mark - TableView SwipeGesture
@interface TSPullTableView(SwipeGesture)
- (void)registerSwipeGesture;
@end
@implementation TSPullTableView(SwipeGesture)
- (void)registerSwipeGesture {
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:upSwipe];
    [upSwipe release];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:downSwipe];
    [downSwipe release];
}
- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionDown:{
            if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(recognizeDownSwipeGesture:)]) {
                [self.pullDelegate recognizeDownSwipeGesture:self];
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionUp:{
            if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(recognizeUpSwipeGesture:)]) {
                [self.pullDelegate recognizeUpSwipeGesture:self];
            }
        }
            break;
        default:
            break;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}
@end


#pragma mark - TableView
@implementation TSPullTableView
@synthesize pullDelegate = _pullDelegate;
@synthesize pullHeaderView, pullFooterView, isRefreshing, isLoadingmore;

#pragma mark init & dealloc
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initSubobjects];
        self.delegate = self;
        
        UIView *_fv = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableFooterView = _fv;
        [_fv release];
        
        float _height = PullTableHeaderOffsetY + 100;
        TSPullTableHeaderView *_header = [[TSPullTableHeaderView alloc] initWithFrame:CGRectMake(0, -_height, self.bounds.size.width, _height)];
        [self addSubview:_header];
        [_header release];
        self.pullHeaderView = _header;
        [self.pullHeaderView updateStatus:PullTableFloatViewPullToLoad];
        
        TSPullTableFooterView *_footer = [[TSPullTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 50.0f)];
        [self addSubview:_footer];
        [_footer release];
        self.pullFooterView = _footer;
        [self.pullFooterView updateStatus:PullTableFloatViewPullToLoad];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [self addObserver:self forKeyPath:@"tableFooterView" options:NSKeyValueObservingOptionNew context:NULL];
        [self.pullHeaderView addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [self.pullFooterView addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        
        //[self registerSwipeGesture];
        
        [self setPullToLoadmoreEnable:NO];
    }
    return self;
}
- (void)initSubobjects {
    self.isRefreshing = NO;
    self.isLoadingmore = NO;
    _tableBottomSpace = 0;
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentSize"];
    [self removeObserver:self forKeyPath:@"tableFooterView"];
    [self.pullHeaderView removeObserver:self forKeyPath:@"status"];
    [self.pullFooterView removeObserver:self forKeyPath:@"status"];
    [super dealloc];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect _f = self.pullFooterView.frame;
        _f.origin.y = self.frame.size.height > self.contentSize.height ? self.frame.size.height : self.contentSize.height;
        self.pullFooterView.frame = _f;
    }
    if ([keyPath isEqualToString:@"status"]) {
        if (object == self.pullHeaderView) {
            self.isRefreshing = self.pullHeaderView.status == PullTableFloatViewLoading ? YES : NO;
            return;
        }
        if (object == self.pullFooterView) {
            self.isLoadingmore = self.pullFooterView.status == PullTableFloatViewLoading ? YES : NO;
            return;
        }
    }
    if ([keyPath isEqualToString:@"tableFooterView"]) {
        return;
        if (!self.tableFooterView) {
            return;
        }
        UIView *_fv = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableFooterView = _fv;
        [_fv release];
        return;
    }
}
- (void)setPullToRefreshEnable:(BOOL)enable {
    self.pullHeaderView.hidden = !enable;
}
- (void)setPullToLoadmoreEnable:(BOOL)enable {
    self.pullFooterView.hidden = !enable;
}

#pragma mark Scroll Manager
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (scrollView.dragging && !self.isRefreshing) {
        if (scrollView.contentOffset.y < 0) {
            if (self.pullHeaderView.hidden) {
                return;
            }
            if (scrollView.contentOffset.y > -PullTableHeaderOffsetY) {
                //  下拉刷新
                if (self.pullHeaderView.status == PullTableFloatViewLoading) {
                    //  正在刷新时，回推操作不更新status
                    return;
                }
                [self.pullHeaderView updateStatus:PullTableFloatViewPullToLoad];
            }else {
                //  松开刷新
                [self.pullHeaderView updateStatus:PullTableFloatViewReleaseToLoad];
            }
        } else {
            if (self.isRefreshing) {
                //  正在刷新时，不更新status
                return;
            }
            if (self.pullFooterView.hidden) {
                return;
            }
            float _delta = scrollView.bounds.size.height > scrollView.contentSize.height ? scrollView.contentOffset.y : scrollView.contentOffset.y+scrollView.bounds.size.height-scrollView.contentSize.height;
            if (_delta > 0) {
                if (_delta < PullTableFooterOffsetY) {
                    //  上拉加载更多
                    if (self.pullFooterView.status == PullTableFloatViewLoading) {
                        //  正在加载更多时，回推操作不更新status
                        return;
                    }
                    [self.pullFooterView updateStatus:PullTableFloatViewPullToLoad];
                }else {
                    //  松开加载更多
                    [self.pullFooterView updateStatus:PullTableFloatViewReleaseToLoad];
                }
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![self checkPullToRefresh:scrollView]) {
        if (self.isRefreshing) {
            //  正在刷新时，不进行加载更多逻辑
            return;
        }
        [self checkPullToLoadmore:scrollView];
    }
}
- (BOOL)checkPullToRefresh:(UIScrollView *)scrollView {
    if (self.pullHeaderView.hidden) {
        return NO;
    }
    if (!(scrollView.contentOffset.y > -PullTableHeaderOffsetY)) {
        [self.pullHeaderView updateStatus:PullTableFloatViewLoading];
        
        [UIView beginAnimations:@"PullToRefresh" context:NULL];
        [UIView setAnimationDuration:0.2f];
        self.contentInset = UIEdgeInsetsMake(PullTableHeaderOffsetY, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
        [UIView commitAnimations];
        
        [self notifyTableViewPullToRefresh:self];
        
        return YES;
    }
    return NO;
}
- (BOOL)checkPullToLoadmore:(UIScrollView *)scrollView {
    if (self.pullFooterView.hidden) {
        return NO;
    }
    float _delta = scrollView.bounds.size.height > scrollView.contentSize.height ? scrollView.contentOffset.y : scrollView.contentOffset.y+scrollView.bounds.size.height-scrollView.contentSize.height;
    if (_delta > 0) {
        if (_delta > PullTableFooterOffsetY) {
            [self.pullFooterView updateStatus:PullTableFloatViewLoading];
            
            _tableBottomSpace = self.bounds.size.height - scrollView.contentSize.height;
            _tableBottomSpace = _tableBottomSpace > 0 ? _tableBottomSpace : 0;
            
            [UIView beginAnimations:@"PullToLoadmore" context:NULL];
            [UIView setAnimationDuration:0.2f];
            self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, PullTableFooterOffsetY+_tableBottomSpace, self.contentInset.right);
            [UIView commitAnimations];
            
            [self notifyTableViewPullToLoadmore:self];
            
            return YES;
        }
    }
    return NO;
}
- (void)startPullToRefreshWithAnimated:(BOOL)animated {
    if (self.pullHeaderView.hidden) {
        return;
    }
    if (animated) {
        [UIView beginAnimations:@"PullToRefresh" context:NULL];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didFinishStartPullToRefreshAnimation)];
        self.contentOffset = CGPointMake(0, -PullTableHeaderOffsetY);
        [UIView commitAnimations];
    } else {
        self.contentOffset = CGPointMake(0, -PullTableHeaderOffsetY);
        [self didFinishStartPullToRefreshAnimation];
    }
}
- (void)didFinishStartPullToRefreshAnimation {
    [self checkPullToRefresh:self];
}
- (void)finishPullToRefreshWithAnimated:(BOOL)animated {
    [self.pullHeaderView updateStatus:PullTableFloatViewPullToLoad];
    if (animated) {
        [UIView beginAnimations:@"PullToRefresh" context:NULL];
        [UIView setAnimationDuration:0.2f];
        self.contentInset = UIEdgeInsetsMake(0.0f, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
        [UIView commitAnimations];
    } else {
        self.contentInset = UIEdgeInsetsMake(0.0f, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
    }
}
- (void)startPullToLoadmoreWithAnimated:(BOOL)animated {
    if (self.pullFooterView.hidden) {
        return;
    }
    if (animated) {
        [UIView beginAnimations:@"PullToLoadmore" context:NULL];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didFinishStartPullToLoadmoreAnimation)];
        self.contentOffset = CGPointMake(0, PullTableHeaderOffsetY);
        [UIView commitAnimations];
    } else {
        self.contentOffset = CGPointMake(0, PullTableFooterOffsetY);
        [self didFinishStartPullToLoadmoreAnimation];
    }
}
- (void)didFinishStartPullToLoadmoreAnimation {
    [self checkPullToLoadmore:self];
}
- (void)finishPullToLoadmoreWithAnimated:(BOOL)animated {
    [self.pullFooterView updateStatus:PullTableFloatViewPullToLoad];
    if (animated) {
        [UIView beginAnimations:@"PullToLoadmore" context:NULL];
        [UIView setAnimationDuration:0.2f];
        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.pullFooterView.bounds.size.height, self.contentInset.right);
        [UIView commitAnimations];
    } else {
        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.pullFooterView.bounds.size.height, self.contentInset.right);
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self notifyTableView:self didSelectRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self notifyTableView:self heightForRowAtIndexPath:indexPath];
}

@end


#pragma mark - HeaderView
#import <QuartzCore/QuartzCore.h>
@interface TSPullTableHeaderView()
@property (nonatomic, assign) UILabel *content;
@property (nonatomic, assign) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) UIImageView *arrowImage;
- (void)flipArrowImageWithAnimated:(BOOL)animated Flip:(BOOL)flip;
@end
@implementation TSPullTableHeaderView
@synthesize status = _status;
@synthesize content;
@synthesize indicator;
@synthesize arrowImage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        UILabel *_content = [[UILabel alloc] initWithFrame:CGRectMake(ceilf((frame.size.width-150)/2), frame.size.height-20-20, 150, 20)];
        _content.backgroundColor = [UIColor clearColor];
        _content.textAlignment = UITextAlignmentCenter;
        _content.font = [UIFont systemFontOfSize:14];
        _content.textColor = [UIColor whiteColor];
        //_content.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_content];
        [_content release];
        self.content = _content;
        
        UIActivityIndicatorView *_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.hidesWhenStopped = YES;
        _indicator.center = CGPointMake(self.content.frame.origin.x - 40, self.content.center.y);
        [self addSubview:_indicator];
        [_indicator release];
        self.indicator = _indicator;
        
        UIImageView *_arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(_indicator.frame.origin.x, frame.size.height - 52.0f, 21.0f, 37.0f)];
        _arrowImg.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImg.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_dragArrow" ofType:@"png"]];
        _arrowImg.layer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
        _arrowImg.hidden = YES;
        [self addSubview:_arrowImg];
        self.arrowImage = _arrowImg;
        [_arrowImg release];
    }
    return self;
}
- (void)updateStatus:(PullTableFloatViewStatus)status {
    self.status = status;
    [self.indicator stopAnimating];
    self.arrowImage.hidden = YES;
    switch (status) {
        case PullTableFloatViewLoading: {
            self.content.text = kPullTableLoading;
            [self.indicator startAnimating];
        }
            break;
        case PullTableFloatViewPullToLoad: {
            self.content.text = kPullTablePullDown2Refresh;
            self.arrowImage.hidden = NO;
            [self flipArrowImageWithAnimated:YES Flip:NO];
        }
            break;
        case PullTableFloatViewReleaseToLoad: {
            self.content.text = kPullTableRelease2Refresh;
            self.arrowImage.hidden = NO;
            [self flipArrowImageWithAnimated:YES Flip:YES];
        }
            break;
        default:
            break;
    }
}
- (void)flipArrowImageWithAnimated:(BOOL)animated Flip:(BOOL)flip {
    CGFloat _angle = flip ? M_PI : M_PI*2;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [self.arrowImage layer].transform = CATransform3DMakeRotation(_angle, 0, 0, 1);
        [UIView commitAnimations];
    } else {
        [self.arrowImage layer].transform = CATransform3DMakeRotation(_angle, 0, 0, 1);
    }
}

@end


#pragma mark - FooterView
@interface TSPullTableFooterView()
@property (nonatomic, assign) UILabel *content;
@property (nonatomic, assign) UIActivityIndicatorView *indicator;
@end
@implementation TSPullTableFooterView
@synthesize status = _status;
@synthesize content;
@synthesize indicator;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *_content = [[UILabel alloc] initWithFrame:CGRectMake(ceilf((frame.size.width-160)/2), frame.size.height-20-16, 160, 20)];
        _content.backgroundColor = [UIColor clearColor];
        _content.textAlignment = UITextAlignmentCenter;
        _content.font = [UIFont systemFontOfSize:14];
        _content.textColor = [UIColor darkTextColor];
        //_content.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_content];
        [_content release];
        self.content = _content;
        
        UIActivityIndicatorView *_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.hidesWhenStopped = YES;
        _indicator.center = CGPointMake(self.content.frame.origin.x - 10, self.content.center.y);
        [self addSubview:_indicator];
        [_indicator release];
        self.indicator = _indicator;
    }
    return self;
}
- (void)updateStatus:(PullTableFloatViewStatus)status {
    self.status = status;
    [self.indicator stopAnimating];
    switch (status) {
        case PullTableFloatViewLoading: {
            self.content.text = kPullTableLoading;
            [self.indicator startAnimating];
        }
            break;
        case PullTableFloatViewPullToLoad: {
            self.content.text = kPullTablePullUp2Loadmore;
        }
            break;
        case PullTableFloatViewReleaseToLoad: {
            self.content.text = kPullTableRelease2Loadmore;
        }
            break;
        default:
            break;
    }
}

@end

@implementation TSPullTableView(DataFull)

- (void)reloadDataWithDataFull:(BOOL)full {
    [self reloadData];
    [self setTableDataFull:full];
}
- (void)setTableDataFull:(BOOL)full {
    if (full) {
        [self setPullToLoadmoreEnable:NO];
        UILabel *_fullFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        _fullFooter.backgroundColor = self.backgroundColor;
        _fullFooter.font = [UIFont systemFontOfSize:14];
        _fullFooter.textColor = [UIColor colorWithRed:(133/255.0) green:(133/255.0) blue:(133/255.0) alpha:1];
        _fullFooter.textAlignment = UITextAlignmentCenter;
        _fullFooter.text = kPullTableNoMoreData;
        self.tableFooterView = _fullFooter;
        [_fullFooter release];
    } else {
        [self setPullToLoadmoreEnable:YES];
        UIView *_fv = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableFooterView = _fv;
        [_fv release];
    }
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.pullFooterView.bounds.size.height, self.contentInset.right);
}

@end