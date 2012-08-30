//
//  Util.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark Marcos
//  log control
#ifdef TARGET_IPHONE_DEBUG
#define SDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
//#define SDPRINT(xx, ...)  ((void)0)
#endif
//  assert control
#ifdef TARGET_IPHONE_DEBUG
#define SDASSERT(xx) { if(!(xx)) { SDPRINT(@"SDASSERT failed: %s", #xx); } } ((void)0)
#else
#define SDASSERT(xx) ((void)0)
#endif
//  time manager
#define S_MINUTE    60
#define S_HOUR      (60 * S_MINUTE)
#define S_DAY       (24 * S_HOUR)
#define S_WORKDAY   (5 * S_DAY)
#define S_WEEK      (7 * S_DAY)
#define S_MONTH     (30.5 * S_DAY)
#define S_YEAR      (365 * S_DAY)
//  color manager
#define SRGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define SRGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]
//  prints the current method's name.
#define SDPRINTMETHODNAME() SDPRINT(@"%s", __PRETTY_FUNCTION__)

// Safe releases
#define TT_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define TT_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }


/** 设备类型 **/

typedef enum 
{
	UIDeviceUnknown,
	
    UIDevice1GiPod,
	UIDevice2GiPod,
	UIDevice3GiPod,
    
    UIDevice1GiPad,
    
	UIDevice1GiPhone,
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice4iPhone,
	UIDevice5iPhone,
    
    UIDevice4GiPod,
	UIDevice2GiPad,
    
} UIDevicePlatform;


#pragma mark -
#pragma mark Class Methods
@interface Util : NSObject {
    
}
//  file manager
+ (NSString *)pathShare;
+ (NSString *)filePathWith:(NSString *)name isDirectory:(BOOL)isDirectory;
+ (BOOL)createDirectoryIfNecessaryAtPath:(NSString *)path;
+ (BOOL)removePathAt:(NSString *)path;
+ (BOOL)fileIfExist:(NSString *)filePath;
+ (float)fileSize:(NSString *)filePath;
+ (NSString *)fileModifyDate:(NSString *)filePath;
+ (NSString*)randomFileNameWithExt:(NSString *)ext;
+ (NSString*)DataFileNameWithExt:(NSString *)ext;

//  date formate
+ (NSString*)formatRefreshTime:(NSDate *)date;
+ (NSString*)formatRelativeTime:(NSDate *)date;
+ (NSString*)formatDateTime:(NSDate *)date;
+ (NSString*)formatTime:(NSDate *)date;
+ (NSString*)format:(NSDate *)date style:(NSString*)strFmt;
+ (NSString*)formatTimeWithSecond:(float)second;
+ (NSString *)formatVideoRecordTimeWith:(NSTimeInterval)interval;
+ (NSDate *)parseSWTimeFormat:(NSString *)strTime;

//  isEmptyString
+ (BOOL)isEmptyString:(NSString *)string;

//  url encode
+ (NSString *)base64URLEncodeWith:(NSString *)urlstring;
+ (NSString *)urlEncode:(NSString *)originalString stringEncoding:(NSStringEncoding)stringEncoding;
+ (NSString *)urlDecode:(NSString *)originalString;
+ (NSString *)md5Hash:(NSString *)content;

//  image manager
+ (UIImage *)imageWithName:(NSString *)imgname;
+ (UIImage *)scaleImageWithName:(NSString*)imgname;
+ (UIImage *)imageWithName:(NSString *)imgname ofType:(NSString *)imgtype;
+ (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count;

//  rotate manager
+ (void)rotateView:(UIView *)view From:(UIInterfaceOrientation)currentOrientation To:(UIInterfaceOrientation)targetOrientation With:(BOOL)animated Delegate:(id)delegate;
+ (UIDevicePlatform)platformType;
+ (BOOL)isCurrentVersionLowerThanRequiredVersion:(NSString *)sysVersion;

+ (void)replaceDictionaryValue:(NSMutableDictionary*)dict value:(id)value forKey:(id)key;
+ (void)removeAndReleaseViewSafefly:(UIView *)aview;
+ (NSLocale*) currentLocale;
//  uuid
#define kSohuMTCUUID    @"SOHUMTCUUID"  //  save in nsuserdefalts
+ (NSString *)currentUUIDString;

@end


#pragma mark - Base64Encode/Decode
extern size_t EstimateBase64EncodedDataSize(size_t inDataSize);
extern size_t EstimateBase64DecodedDataSize(size_t inDataSize);

extern bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped);
extern bool Base64EncodeDataForJSON(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize);
extern bool Base64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize);
extern bool Base64DecodeDataForJSON(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize);

@interface NSData (Base64Additions)
+(id)decodeBase64ForString:(NSString *)decodeString;
+(id)decodeWebSafeBase64ForString:(NSString *)decodeString;
-(NSString *)encodeBase64ForData;
-(NSString *)encodeWebSafeBase64ForData;
-(NSString *)encodeWrappedBase64ForData;
@end


#pragma mark - AES Encrypt/Decrypt
@interface NSData (AESAdditions)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
@end

@interface NSString (AESAdditions)
- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;
@end

