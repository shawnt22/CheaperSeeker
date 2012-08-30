//
//  SHistory.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SConfiger.h"

#pragma mark - Base
#define kHistoryItemsMaxCountDefault 500
typedef enum {
    SHistoryItemsPopupFirstInFirstOut,
    SHistoryItemsPopupFirstInLastOut,
}SHistoryItemsPopupType;

@protocol SHistoryProtocol <NSObject, NSCoding>
@required
// should overwrite all below 
- (id)didItemExist:(id)item;	//	return item if existed
+ (NSString *)historyFilePath;
+ (id)resumeHistory;
- (BOOL)saveHistory;
- (BOOL)addItem:(id)item needCheck:(BOOL)needCheck;
- (BOOL)insertItem:(id)item needCheck:(BOOL)needCheck At:(NSInteger)index;
- (BOOL)removeItem:(id)item needCheck:(BOOL)needCheck;
- (void)clearHistory;
@optional
- (BOOL)addItem:(id)item;		//  在队尾添加；数目越界Popup Item时使用SHistoryItemsPopupFirstInFirstOut
- (BOOL)addItems:(NSArray *)its;
- (BOOL)removeItem:(id)item;	//	needCheck=YES
- (BOOL)removeItems:(NSArray *)its;
- (BOOL)insertItem:(id)item needCheck:(BOOL)needCheck;  //  在队首添加；数目越界Popup Item时使用SHistoryItemsPopupFirstInLastOut
- (BOOL)insertItems:(NSArray *)its;
@end

#define kHistoryItems @"shistoryItems"
#define kHistoryItemsMaxCount @"shistoryItemsMaxCount"
#define kHistoryItemsPopupType @"shistoryItemsPopupType"
@interface SHistory : NSObject<SHistoryProtocol> {
@private
    NSMutableArray *_items;
    NSInteger _itemsMaxCount;                   //  历史记录最大值，默认为kHistoryItemsMaxCountDefault
    SHistoryItemsPopupType _itemsPopupType;     //  超过默认最大值时item的弹出规则
}
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, assign) NSInteger itemsMaxCount;
@property (nonatomic, assign) SHistoryItemsPopupType itemsPopupType;

- (void)initSubobjects;

@end
