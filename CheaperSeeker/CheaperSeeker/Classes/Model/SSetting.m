//
//  SSetting.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SSetting.h"

#pragma mark - Base
@implementation SSetting

- (void)encodeWithCoder:(NSCoder *)aCoder {
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        [self initSubobjects];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        [self initSubobjects];
    }
    return self;
}
- (void)initSubobjects {
}
+ (NSString *)settingFilePath {
	return nil;
}
+ (id)resumeSetting {
    NSData *data = [NSData dataWithContentsOfFile:[SSetting settingFilePath]];
    SSetting *setting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	return setting;
}
- (BOOL)saveSetting {
    BOOL result = NO;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    result = [data writeToFile:[[self class] settingFilePath] atomically:YES];
	return result;
}
- (BOOL)clearSetting {
	return NO;
}
- (void)resetSetting {
}

@end
