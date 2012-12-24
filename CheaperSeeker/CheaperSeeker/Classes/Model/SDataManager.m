//
//  SDataManager.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SDataManager.h"

static SDataManager *_dataManager = nil;
@implementation SDataManager
@synthesize currentUser;

#pragma mark init & dealloc
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}
+ (SDataManager *)shareDataManager {
    if (!_dataManager) {
        _dataManager = [[SDataManager alloc] init];
    }
    return _dataManager;
}

#pragma mark login manager
- (void)prepareBeforeLogin {
    [Util createDirectoryIfNecessaryAtPath:[SUtil commonDocFilePath]];
}
- (void)prepareAfterLogin {}
- (BOOL)isLogin {
    return self.currentUser ? YES : NO;
}

@end
