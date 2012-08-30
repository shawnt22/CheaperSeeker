//
//  SSplitViewController.h
//  SSplitControllerDemo
//
//  Created by 滕 松 on 12-8-17.
//  Copyright (c) 2012年 滕 松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSplitContentDelegate.h"

@interface SSplitRootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SSplitContentViewDelegate> {
@private
    NSArray *_splitContentViewControllers;
}
@property (nonatomic, retain) NSArray *splitContentViewControllers;         // must confirm <SSplitViewControllerProtocol>
@property (nonatomic, assign) UIViewController<SSplitControllerProtocol> *currentContentViewController;

@property (nonatomic, readonly) BOOL contentSplitEnable;

- (void)splitContentViewController:(UIViewController<SSplitControllerProtocol> *)contentViewController Animated:(BOOL)animated;     //  content move from left to right : ->
- (void)coverContentViewController:(UIViewController<SSplitControllerProtocol> *)contentViewController Animated:(BOOL)animated;     //  content move from right to left : <-

@end


#pragma mark - Split Content Board
@interface SSplitContentBoard : UIView <SSplitContentViewProtocol>
@property (nonatomic, assign) SSplitRootViewController *splitRootViewController;
- (SSplitContentBoard *)defaultSplitContentBoard;
- (void)addSplitContentView:(UIView *)content;

@end
