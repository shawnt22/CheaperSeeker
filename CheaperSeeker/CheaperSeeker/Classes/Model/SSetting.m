//
//  SSetting.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SSetting.h"
#import "Util.h"
#import "SUtil.h"

#pragma mark - Base
@implementation SSetting

+ (id)shareSetting {
    return nil;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        [Util createDirectoryIfNecessaryAtPath:[SUtil commonDocFilePath]];
    }
    return self;
}
+ (NSString *)filePath {
	return nil;
}
+ (id)resume {
    Class _class = [self class];
    NSData *_data = [NSData dataWithContentsOfFile:[_class filePath]];
    id _setting = nil;
    if (_data) {
        _setting = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    } else {
        _setting = [[[_class alloc] init] autorelease];
    }
	return _setting;
}
- (BOOL)save {
    BOOL _result = NO;
    NSData *_data = [NSKeyedArchiver archivedDataWithRootObject:self];
    _result = [_data writeToFile:[[self class] filePath] atomically:YES];
	return _result;
}
- (BOOL)clear {
    return [Util removePathAt:[[self class] filePath]];
}
- (void)reset {
}

@end


static SGSetting *gsetting = nil;
@implementation SGSetting
@synthesize email;

+ (id)shareSetting {
    if (!gsetting) {
        gsetting = [[SGSetting resume] retain];
    }
    return gsetting;
}
- (id)init {
    self = [super init];
    if (self) {
        self.email = nil;
    }
    return self;
}
- (void)dealloc {
    self.email = nil;
    [super dealloc];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        id _v = [aDecoder decodeObjectForKey:k_usetting_email];
        if (_v) {
            self.email = _v;
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.email forKey:k_usetting_email];
}
+ (NSString *)filePath {
    return [[SUtil commonDocFilePath] stringByAppendingString:[@"gsetting" lastPathComponent]];
}

@end