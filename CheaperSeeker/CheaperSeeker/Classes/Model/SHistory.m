//
//  SHistory.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SHistory.h"

@interface SHistory()
- (BOOL)canAddItem;
- (BOOL)prepareItemsBeforeIncrease;
@end

@implementation SHistory
@synthesize items = _items, itemsMaxCount = _itemsMaxCount, itemsPopupType = _itemsPopupType;

#pragma mark init & dealloc
- (void)initSubobjects {
    self.items = [NSMutableArray array];
    self.itemsMaxCount = kHistoryItemsMaxCountDefault;
    self.itemsPopupType = SHistoryItemsPopupFirstInFirstOut;
}
- (void)dealloc {
    self.items = nil;
    [super dealloc];
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.items forKey:kHistoryItems];
    [aCoder encodeInteger:self.itemsMaxCount forKey:kHistoryItemsMaxCount];
    [aCoder encodeInt:self.itemsPopupType forKey:kHistoryItemsPopupType];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.items = [aDecoder decodeObjectForKey:kHistoryItems];
        self.itemsMaxCount = [aDecoder decodeIntegerForKey:kHistoryItemsMaxCount];
        self.itemsPopupType = [aDecoder decodeIntForKey:kHistoryItemsPopupType];
    }
    return self;
}

#pragma mark history manager
- (BOOL)canAddItem {
    BOOL _canAdd = NO;
    if ([self.items count] < self.itemsMaxCount) {
        _canAdd = YES;
    }else {
        _canAdd = [self prepareItemsBeforeIncrease];
    }
    return _canAdd;
}
- (BOOL)prepareItemsBeforeIncrease {
    BOOL _result = YES;
    if ([self.items count] > 0) {
        NSInteger _removeIndex;
        switch (self.itemsPopupType) {
            case SHistoryItemsPopupFirstInLastOut:
                _removeIndex = [self.items count] - 1;
                break;
            default:
                _removeIndex = 0;
                break;
        }
        [self.items removeObjectAtIndex:_removeIndex];
    }else {
        //  数组中没有item时允许执行添加操作
        _result = YES;
    }
    return _result;
}
- (BOOL)addItem:(id)item {
	return [self addItem:item needCheck:YES];
}
- (BOOL)addItem:(id)item needCheck:(BOOL)needCheck {
	if (![self canAddItem]) {
        return NO;
    }
    if (needCheck) {
		id existed = [self didItemExist:item];
		if (existed) {
			[self removeItem:existed needCheck:NO];
		}
	}
    [self.items addObject:item];
	return YES;
}
- (BOOL)addItems:(NSArray *)its {
	for (id it in its) {
		[self addItem:it];
	}
	return YES;
}
- (BOOL)insertItem:(id)item needCheck:(BOOL)needCheck {
	return [self insertItem:item needCheck:needCheck At:0];
}
- (BOOL)insertItem:(id)item needCheck:(BOOL)needCheck At:(NSInteger)index {
    if (![self canAddItem]) {
        return NO;
    }
    index = index > [self.items count] ? [self.items count] : index;
    if (needCheck) {
		id existed = [self didItemExist:item];
		if (existed) {
			[self removeItem:existed needCheck:NO];
		}
	}
    [self.items insertObject:item atIndex:index];
	return YES;
}
- (BOOL)insertItems:(NSArray *)its {
    for (id it in its) {
        [self insertItem:it needCheck:YES];
    }
    return YES;
}
- (BOOL)removeItem:(id)item {
	return [self removeItem:item needCheck:YES];
}
- (BOOL)removeItem:(id)item needCheck:(BOOL)needCheck {
    id exsited = item;
	if (needCheck) {
        exsited = [self didItemExist:item];
		if (!exsited) {
			return NO;
		}
	}
    [self.items removeObject:exsited];
	return YES;
}
- (id)didItemExist:(id)item {
	//	must overwrited by child
	return nil;
}
- (BOOL)removeItems:(NSArray *)its {
	for (id it in its) {
		[self removeItem:it];
	}
	return YES;
}
- (void)clearHistory {
	self.items = [NSMutableArray array];
    [self saveHistory];
}
+ (NSString *)historyFilePath {
	return nil;
}
+ (id)resumeHistory {
	return nil;
}
- (BOOL)saveHistory {
	return NO;
}

@end
