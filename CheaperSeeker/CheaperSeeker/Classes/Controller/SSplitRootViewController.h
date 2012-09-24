//
//  SSplitViewController.h
//  SSplitControllerDemo
//
//  Created by 滕 松 on 12-8-17.
//  Copyright (c) 2012年 滕 松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSplitContentDelegate.h"

@class SSplitContentBoard;
@interface SSplitRootViewController : UIView <UITableViewDataSource, UITableViewDelegate, SSplitContentViewDelegate> {
@private
    NSArray *_splitContentViewControllers;
}
@property (nonatomic, retain) NSArray *splitContentViewControllers;         // must confirm <SSplitViewControllerProtocol>
@property (nonatomic, assign) UIViewController<SSplitControllerProtocol> *currentContentViewController;
@property (nonatomic, assign) SSplitContentBoard *contentBoard;

@property (nonatomic, readonly) BOOL contentSplitEnable;

- (void)splitContentViewController:(UIViewController<SSplitControllerProtocol> *)contentViewController Animated:(BOOL)animated;     //  content move from left to right : ->
- (void)coverContentViewController:(UIViewController<SSplitControllerProtocol> *)contentViewController Animated:(BOOL)animated;     //  content move from right to left : <-

@end


#pragma mark - Split Content Board
@interface SSplitContentBoard : UIView <SSplitContentViewProtocol, UIGestureRecognizerDelegate>
@property (nonatomic, assign) SSplitRootViewController *splitRootViewController;
- (void)addSplitContentView:(UIView *)content;

@end
