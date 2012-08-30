//
//  SSplitContentDelegate.h
//  SSplitControllerDemo
//
//  Created by 滕 松 on 12-8-17.
//  Copyright (c) 2012年 滕 松. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
/*
 SplitContentView Delegate
 */
@protocol SSplitContentViewProtocol;
@protocol SSplitContentViewDelegate <NSObject>
@optional
- (BOOL)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView shouldGesture:(UIGestureRecognizer *)gesture;
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView beginedGesture:(UIGestureRecognizer *)gesture;
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView endedGesture:(UIGestureRecognizer *)gesture;
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView changedGesture:(UIGestureRecognizer *)gesture;
- (void)splitContentView:(UIView<SSplitContentViewProtocol> *)splitContentView canceledGesture:(UIGestureRecognizer *)gesture;

@end

#pragma mark -
/*
 SplitContentView Protocol
 */
typedef enum {
    SSplitContentViewStatusCover,
    SSplitContentViewStatusSplit,
}SSplitContentViewStatus;

@protocol SSplitContentViewProtocol <NSObject>
@required
@property (nonatomic, assign) id<SSplitContentViewDelegate> splitDelegate;

@optional
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) SSplitContentViewStatus status;
- (void)addGestures;
- (void)responseGesture:(UIGestureRecognizer *)gesture;

@end

/*
 SplitController Protocol
 */
@protocol SSplitControllerProtocol <NSObject>
@optional
@property (nonatomic, readonly) UINavigationController<SSplitControllerProtocol> *splitNavigationController;    //  ViewController 实现该属性    可直接调用[SSplitContentUtil splitNavigationControllerWithSplitViewController:]
@property (nonatomic, readonly) UIViewController<SSplitControllerProtocol> *splitViewController;                //  NavigationController 实现该属性  可直接调用[SSplitContentUtil splitViewControllerWithSplitNavigationController:]

@end

#pragma mark -
/*
 SplitContentView Util
 */
@interface SSplitContentUtil : NSObject

+ (UIViewController<SSplitControllerProtocol> *)splitViewControllerWithSplitNavigationController:(UINavigationController<SSplitControllerProtocol> *)nctr;
+ (UINavigationController<SSplitControllerProtocol> *)splitNavigationControllerWithSplitViewController:(UIViewController<SSplitControllerProtocol> *)vctr;

@end
