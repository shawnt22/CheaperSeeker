//
//  SDragTableView.h
//
//
//  Created by Teng TengSong on 12-1-3.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSPullTableView;
@protocol TSPullTableViewDelegate <NSObject>
@optional
- (void)tableViewPullToRefresh:(TSPullTableView *)tableView;
- (void)tableViewPullToLoadmore:(TSPullTableView *)tableView;
- (void)tableView:(TSPullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(TSPullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol TSPullTableViewProtocol <NSObject>
@optional
- (void)startPullToRefreshWithAnimated:(BOOL)animated;
- (void)finishPullToRefreshWithAnimated:(BOOL)animated;
- (void)startPullToLoadmoreWithAnimated:(BOOL)animated;
- (void)finishPullToLoadmoreWithAnimated:(BOOL)animated;
@end

@protocol TSViewGestureDelegate <NSObject>
@optional
- (void)recognizeUpSwipeGesture:(UIView *)view;
- (void)recognizeDownSwipeGesture:(UIView *)view;
@end

#define PullTableHeaderOffsetY  60.0f
#define PullTableFooterOffsetY  60.0f

@interface TSPullTableView : UITableView <UITableViewDelegate, TSPullTableViewProtocol> {
@protected
    id<TSPullTableViewDelegate, TSViewGestureDelegate> _pullDelegate;
    float _tableBottomSpace;
}
@property (nonatomic, assign) id<TSPullTableViewDelegate, TSViewGestureDelegate> pullDelegate;

- (void)initSubobjects;
- (void)setPullToRefreshEnable:(BOOL)enable;
- (void)setPullToLoadmoreEnable:(BOOL)enable;

@end

typedef enum {
    PullTableFloatViewPullToLoad,
    PullTableFloatViewReleaseToLoad,
    PullTableFloatViewLoading,
}PullTableFloatViewStatus;

@protocol TSPullTableFloatViewProtocol <NSObject>
@property (nonatomic, assign) PullTableFloatViewStatus status;
- (void)updateStatus:(PullTableFloatViewStatus)status;
@end

@interface TSPullTableHeaderView : UIView<TSPullTableFloatViewProtocol> {
@private
    PullTableFloatViewStatus _status;
}
@end

@interface TSPullTableFooterView : UIView<TSPullTableFloatViewProtocol> {
@private
    PullTableFloatViewStatus _status;
}
@end


@interface TSPullTableView(DataFull)
- (void)setTableDataFull:(BOOL)full;
- (void)reloadDataWithDataFull:(BOOL)full;
@end