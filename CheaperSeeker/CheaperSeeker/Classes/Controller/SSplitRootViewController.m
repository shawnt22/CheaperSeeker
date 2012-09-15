//
//  SSplitViewController.m
//  SSplitControllerDemo
//
//  Created by 滕 松 on 12-8-17.
//  Copyright (c) 2012年 滕 松. All rights reserved.
//

#import "SSplitRootViewController.h"
#import "SMenuCell.h"

@interface SSplitRootViewController()
@property (nonatomic, assign) UITableView *menuTableView;

- (void)finishedSplitContentAnimation;
- (void)finishedCoverContentAnimation;

- (void)splitContentBoardWithAnimated:(BOOL)animated;
- (void)coverContentBoardWithAnimated:(BOOL)animated;

- (void)regulateContentBoardWithGesture:(UIGestureRecognizer *)gesture Animated:(BOOL)animated;

@end
@implementation SSplitRootViewController
@synthesize splitContentViewControllers = _splitContentViewControllers;
@synthesize menuTableView, contentBoard;
@synthesize currentContentViewController;

#define kSplitContentOriginXSplit       260.0
#define kSplitContentOriginXCover       0.0

#define kMoveContentAnimationDuration   0.3

#pragma mark init & dealloc
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.splitContentViewControllers = nil;
        self.currentContentViewController = nil;
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        UITableView *_menu = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, kSplitContentOriginXSplit, self.bounds.size.height) style:UITableViewStylePlain];
        _menu.backgroundColor = [UIColor clearColor];
        _menu.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menu.scrollsToTop = NO;
        _menu.delegate = self;
        _menu.dataSource = self;
        [self addSubview:_menu];
        self.menuTableView = _menu;
        [_menu release];
        
        UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menu.bounds.size.width, 1)];
        _line.backgroundColor = kSiderCellBGLineColor;
        _menu.tableHeaderView = _line;
        [_line release];
        
        SSplitContentBoard *_cb = [[SSplitContentBoard alloc] defaultSplitContentBoard];
        _cb.splitDelegate = self;
        [self addSubview:_cb];
        self.contentBoard = _cb;
        [_cb release];
    }
    return self;
}
- (void)dealloc {
    self.splitContentViewControllers = nil;
    self.currentContentViewController = nil;
    [super dealloc];
}
- (void)setSplitContentViewControllers:(NSArray *)splitContentViewControllers {
    [_splitContentViewControllers release];
    _splitContentViewControllers = [splitContentViewControllers retain];
    
    for (UIViewController<SSplitControllerProtocol> *content in self.splitContentViewControllers) {
        CGRect _f = content.view.frame;
        _f.origin.y = -20;
        content.view.frame = _f;
    }
    [self.menuTableView reloadData];
}

#pragma mark split delegate
- (BOOL)contentSplitEnable {
    if ([self.currentContentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nctr = (UINavigationController *)self.currentContentViewController;
        if ([nctr.viewControllers count] > 0) {
            return nctr.topViewController == [nctr.viewControllers objectAtIndex:0] ? YES : NO;
        }
    }
    return YES;
}
- (BOOL)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView shouldGesture:(UIGestureRecognizer *)gesture {
    return self.contentSplitEnable;
}
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView beginedGesture:(UIGestureRecognizer *)gesture {}
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView endedGesture:(UIGestureRecognizer *)gesture {
    [self regulateContentBoardWithGesture:gesture Animated:YES];
}
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView changedGesture:(UIGestureRecognizer *)gesture {
    CGPoint _origin = splitContentView.originalPoint;
    CGPoint _current = splitContentView.currentPoint;
    CGFloat _delta = _current.x - _origin.x;
    
    CGRect _f = splitContentView.frame;
    _f.origin.x += _delta;
    _f.origin.x = _f.origin.x < kSplitContentOriginXCover ? kSplitContentOriginXCover : _f.origin.x;
    _f.origin.x = _f.origin.x > kSplitContentOriginXSplit ? kSplitContentOriginXSplit : _f.origin.x;
    splitContentView.frame = _f;
}
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView canceledGesture:(UIGestureRecognizer *)gesture {
    [self regulateContentBoardWithGesture:gesture Animated:YES];
}

#pragma mark menu delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SMenuCell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.splitContentViewControllers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_identifier = @"cell";
    SMenuCell *_cell = (SMenuCell *)[tableView dequeueReusableCellWithIdentifier:_identifier];
    if (!_cell) {
        _cell = [[[SMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [_cell refreshMenuItem:indexPath.row];
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController<SSplitControllerProtocol> *_controller = [self.splitContentViewControllers objectAtIndex:indexPath.row];
    [self coverContentViewController:_controller Animated:YES];
}

#pragma mark content manager
- (UIViewController<SSplitControllerProtocol> *)validContentViewController:(UIViewController<SSplitControllerProtocol> *)contentViewController {
    UIViewController<SSplitControllerProtocol> *result = contentViewController.splitNavigationController;
    result = result ? result : contentViewController;
    for (UIViewController<SSplitControllerProtocol> *sctr in self.splitContentViewControllers) {
        if (sctr == result) {
            return sctr;
        }
    }
    return nil;
}
- (void)splitContentViewController:(UIViewController<SSplitControllerProtocol> *)contentViewController Animated:(BOOL)animated {
    contentViewController = [self validContentViewController:contentViewController];
    if (contentViewController) {
        self.currentContentViewController = contentViewController;
        [self.contentBoard addSplitContentView:contentViewController.view];
        [self splitContentBoardWithAnimated:animated];
    }
}
- (void)coverContentViewController:(UIViewController<SSplitControllerProtocol> *)contentViewController Animated:(BOOL)animated {
    contentViewController = [self validContentViewController:contentViewController];
    if (contentViewController) {
        self.currentContentViewController = contentViewController;
        [self.contentBoard addSplitContentView:contentViewController.view];
        [self coverContentBoardWithAnimated:animated];
    }
}
- (void)splitContentBoardWithAnimated:(BOOL)animated {
    if (self.contentBoard.status == SSplitContentViewStatusSplit) {
        //return;
    }
    
    self.currentContentViewController.splitViewController.view.userInteractionEnabled = NO;
    
    CGRect _f = self.contentBoard.frame;
    _f.origin.x = kSplitContentOriginXSplit;
    if (animated) {
        [UIView beginAnimations:@"split" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kMoveContentAnimationDuration];
        [UIView setAnimationDidStopSelector:@selector(finishedSplitContentAnimation)];
        self.contentBoard.frame = _f;
        [UIView commitAnimations];
    } else {
        self.contentBoard.frame = _f;
        [self finishedSplitContentAnimation];
    }
}
- (void)coverContentBoardWithAnimated:(BOOL)animated {
    if (self.contentBoard.status == SSplitContentViewStatusCover) {
        //return;
    }
    
    self.currentContentViewController.splitViewController.view.userInteractionEnabled = NO;
    
    CGRect _f = self.contentBoard.frame;
    _f.origin.x = kSplitContentOriginXCover;
    if (animated) {
        [UIView beginAnimations:@"cover" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:kMoveContentAnimationDuration];
        [UIView setAnimationDidStopSelector:@selector(finishedCoverContentAnimation)];
        self.contentBoard.frame = _f;
        [UIView commitAnimations];
    } else {
        self.contentBoard.frame = _f;
        [self finishedCoverContentAnimation];
    }
}
- (void)finishedSplitContentAnimation {
    self.contentBoard.status = SSplitContentViewStatusSplit;
}
- (void)finishedCoverContentAnimation {
    self.contentBoard.status = SSplitContentViewStatusCover;
    self.currentContentViewController.splitViewController.view.userInteractionEnabled = YES;
}
- (void)regulateContentBoardWithGesture:(UIGestureRecognizer *)gesture Animated:(BOOL)animated {
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGFloat _velocityX = [(UIPanGestureRecognizer *)gesture velocityInView:self].x;
        //  优先处理swipe手势
        if (_velocityX > 1000.0) {
            //  swipe gesture : from left to right  ->
            [self splitContentBoardWithAnimated:animated];
            return;
        }
        if (_velocityX < -1000.0) {
            //  swipe gesture : from right to left  <-
            [self coverContentBoardWithAnimated:animated];
            return;
        }
        //  处理pan手势
        CGFloat _x = [(UIPanGestureRecognizer *)gesture translationInView:self].x;
        if (_x > self.bounds.size.width/2) {
            [self splitContentBoardWithAnimated:animated];
        } else {
            [self coverContentBoardWithAnimated:animated];
        }
    }
}

@end

@implementation SSplitRootViewController (SSplitContentViewProtocol)

- (void)setSplitDelegate:(id<SSplitContentViewDelegate>)asplitDelegate {
    self.contentBoard.splitDelegate = asplitDelegate;
}
- (id<SSplitContentViewDelegate>)splitDelegate {
    return self.contentBoard.splitDelegate;
}
- (CGPoint)originalPoint {
    return self.contentBoard.originalPoint;
}
- (CGPoint)currentPoint {
    return self.currentPoint;
}

@end



#pragma mark - Split Content Board
@implementation SSplitContentBoard
@synthesize splitDelegate, originalPoint, currentPoint;
@synthesize status;
@synthesize splitRootViewController;

#pragma mark init & dealloc
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.status = SSplitContentViewStatusCover;
        self.originalPoint = self.currentPoint = CGPointZero;
        [self addGestures];
    }
    return self;
}
- (SSplitContentBoard *)defaultSplitContentBoard {
    CGRect _f = CGRectMake(0, 20, 320, 460);
    self = [self initWithFrame:_f];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *_shadow = [[UIImageView alloc] initWithFrame:CGRectMake(-22, 0, 22, self.bounds.size.height)];
        _shadow.tag = -1;
        _shadow.backgroundColor = [UIColor clearColor];
        _shadow.image = [UIImage imageNamed:@"bg_split_shadow.png"];
        [self addSubview:_shadow];
        [_shadow release];
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}

#pragma mark content
#define kSplitContentViewTag 999
- (void)addSplitContentView:(UIView *)content {
    UIView *showingContentView = [self viewWithTag:kSplitContentViewTag];
    if (showingContentView) {
        [showingContentView removeFromSuperview];
    }
    content.tag = kSplitContentViewTag;
    [self addSubview:content];
}

#pragma mark gesture manager
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.splitDelegate && [self.splitDelegate respondsToSelector:@selector(splitContentView:shouldGesture:)]) {
        return [self.splitDelegate splitContentView:self shouldGesture:gestureRecognizer];
    }
    return YES;
}
- (void)addGestures {
    UIPanGestureRecognizer *_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(responseGesture:)];
    _pan.delegate = self;
    [self addGestureRecognizer:_pan];
    [_pan release];
}
- (void)responseGesture:(UIGestureRecognizer *)gesture {
    if (self.splitDelegate) {
        switch (gesture.state) {
            case UIGestureRecognizerStatePossible:
                break;
            case UIGestureRecognizerStateBegan:
            {
                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
                    self.originalPoint = self.currentPoint = [(UIPanGestureRecognizer *)gesture translationInView:self.superview];
                }
                if ([self.splitDelegate respondsToSelector:@selector(splitContentView:beginedGesture:)]) {
                    [self.splitDelegate splitContentView:self beginedGesture:gesture];
                }
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
                    self.currentPoint = [(UIPanGestureRecognizer *)gesture translationInView:self.superview];
                }
                if ([self.splitDelegate respondsToSelector:@selector(splitContentView:changedGesture:)]) {
                    [self.splitDelegate splitContentView:self changedGesture:gesture];
                }
                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
                    self.originalPoint = self.currentPoint;
                }
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                self.originalPoint = self.currentPoint = CGPointZero;
                if ([self.splitDelegate respondsToSelector:@selector(splitContentView:endedGesture:)]) {
                    [self.splitDelegate splitContentView:self endedGesture:gesture];
                }
            }
                break;
            case UIGestureRecognizerStateCancelled:
            {
                self.originalPoint = self.currentPoint = CGPointZero;
                if ([self.splitDelegate respondsToSelector:@selector(splitContentView:canceledGesture:)]) {
                    [self.splitDelegate splitContentView:self canceledGesture:gesture];
                }
            }
                break;
            default:
            {
                self.originalPoint = self.currentPoint = CGPointZero;
                if ([self.splitDelegate respondsToSelector:@selector(splitContentView:canceledGesture:)]) {
                    [self.splitDelegate splitContentView:self canceledGesture:gesture];
                }
            }
                break;
        }
    }
}

@end




