//
//  Util.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "Util.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#import <objc/runtime.h>

@implementation Util

#pragma mark File Manager
+ (NSString *)filePathWith:(NSString *)name isDirectory:(BOOL)isDirectory {
	NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
	if ([paths count] > 0) {	
		name = isDirectory ? name : [name lastPathComponent];
		path = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
	}
	return path;
}
+ (BOOL)createDirectoryIfNecessaryAtPath:(NSString *)path {
	BOOL succeeded = YES;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSError *err = [[NSError alloc] init];
		succeeded = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
		if (!succeeded) {
            NSLog(@"Create Path Error : %@", err);
		}
		[err release];
	}
	return succeeded;
}
+ (BOOL)removePathAt:(NSString *)path {
	BOOL succeeded = YES;
    
    //File Not Exist return Yes
    if (![Util fileIfExist:path]) {
        return YES;
    }
    
	NSError *err = [[NSError alloc] init];
	succeeded = [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
	if (!succeeded) {
        NSLog(@"Remove Path Error : %@", err);
	}
	[err release];
	return succeeded;
}
+ (NSString *)pathShare {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
	if ([paths count] > 0) {
		NSString *dPath = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
        return dPath;
	}	
	return nil; 
}
+ (BOOL)fileIfExist:(NSString *)filePath {
    BOOL rtn = YES;
    //EmptyPath return file Not Exist
    if([Util isEmptyString:filePath])  return NO;
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    rtn =  [file_manager fileExistsAtPath:filePath];
    return rtn;
}
+ (float)fileSize:(NSString *)filePath {
    float rtn = 0.0;
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if ([file_manager fileExistsAtPath:filePath]) {
        NSDictionary * attributes = [file_manager attributesOfItemAtPath:filePath error:nil];
        // file size
        NSNumber *theFileSize;
        theFileSize = [attributes objectForKey:NSFileSize];
        if (theFileSize) {
            rtn = [theFileSize floatValue];
        }
    }
    return rtn;
}
+ (NSString *)fileModifyDate:(NSString *)filePath {
    NSString * rtn = nil;
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if ([file_manager fileExistsAtPath:filePath]) {
        NSDictionary * attributes = [file_manager attributesOfItemAtPath:filePath error:nil];
        NSDate * date = [attributes objectForKey:NSFileModificationDate];
        
        rtn = [Util format:date style:@"M月d日"];
    }
    return rtn;
}
+ (NSString*)randomFileNameWithExt:(NSString *)ext {
    NSMutableString * rtn = [[NSMutableString alloc] init];
    NSString * dictionary = @"abcdefghijklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //srandom(time(NULL));
    for (int i=0 ; i< 20; i++) {
        int r = arc4random() % [dictionary length];
        [rtn appendString:[dictionary substringWithRange:NSMakeRange(r, 1)]];
    }
    if (![Util isEmptyString:ext]) {
        [rtn appendFormat:@".%@",ext];
    }
    return rtn;
}
+ (NSString*)DataFileNameWithExt:(NSString *)ext {
    NSMutableString * rtn = [[NSMutableString alloc] init];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"ddMMMyyyyHHmmss"];
    [rtn appendFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    if (![Util isEmptyString:ext]) {
        [rtn appendFormat:@".%@",ext];
    }
    // fix
    return [rtn autorelease];
}

#pragma mark Date Formate
+ (NSString*)formatRefreshTime:(NSDate *)date {
    NSTimeInterval elapsed = abs([date timeIntervalSinceNow]);
	if (elapsed < S_MINUTE) {
		return [NSString stringWithString:@"刚刚"];
	}
	if (elapsed < S_HOUR) {
		int mins = (int)floor(elapsed/S_MINUTE);
		return [NSString stringWithFormat:@"%d分钟前",mins];
	}
	if (elapsed < S_DAY) {
        NSString *time = [Util format:date style:@"h:mm a"];
		return [NSString stringWithFormat:@"今天%@", time];
	} else {
        return [Util format:date style:@"M-d H:mm"];
    }
}
+ (NSString*)formatRelativeTime:(NSDate *)date {	
	NSTimeInterval elapsed = abs([date timeIntervalSinceNow]);
	if (elapsed < S_MINUTE) {
		int secds = (int)floor(elapsed);
		return secds < 2 ? @"刚刚" : [NSString stringWithFormat:@"%d秒前",secds];
	}
	if (elapsed < S_HOUR) {
		int mins = (int)floor(elapsed/S_MINUTE);
		return [NSString stringWithFormat:@"%d分钟前",mins];
	}
	if (elapsed < S_DAY) {
		int hours = (int)floor(elapsed/S_HOUR);
		return [NSString stringWithFormat:@"%d小时前",hours];
	}
	int days = (int)floor((elapsed+S_DAY/2)/S_DAY);
	if (days < 2) {
		return @"昨天";
	}
	if (days < 3) {
		return @"前天";
	}
	return [Util formatDateTime:date];
}
+ (NSString*)formatDateTime:(NSDate *)date {
	NSTimeInterval diff = abs([date timeIntervalSinceNow]);
	return diff < S_DAY ? [Util format:date style:@"h:mm a"] : [Util format:date style:@"M月d日 H:mm"];
}
+ (NSString*)formatTime:(NSDate *)date {
	return [Util format:date style:@"h:mm a"];
}
+ (NSString*)format:(NSDate *)date style:(NSString*)strFmt {
	NSString *result = nil;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:strFmt];
	result = [formatter stringFromDate:date];
	[formatter release];	
	return result;
}
+ (NSString*)formatTimeWithSecond:(float)formatSecond {
    NSString * rtn = nil;
    NSString * secondString = nil;
    NSString * miniteString = nil;
    
    NSInteger second = ceilf(formatSecond);
    
    if (second < S_MINUTE) 
    {
        secondString = [NSString stringWithFormat:@"%02d", second];
        miniteString = [NSString stringWithString:@"00"];
	}
	else if (second < S_HOUR) 
    {
        NSInteger tmpMinite =  second / S_HOUR;
        miniteString = [NSString stringWithFormat:@"%02d", tmpMinite];
        NSInteger tmpSecond = (int)(second-tmpMinite*S_MINUTE) % S_MINUTE;
        secondString = [NSString stringWithFormat:@"%02d", tmpSecond];
	}
    
    rtn = [NSString stringWithFormat:@"%@:%@",miniteString,secondString];
    
    return rtn;
}
+ (NSString *)formatVideoRecordTimeWith:(NSTimeInterval)interval {
    NSString *result = [NSString stringWithString:@"00:00:00"];
    
    if (interval < 0) return result;
    
    NSInteger hour = (NSInteger)floor(interval/S_HOUR);
    interval -= hour * S_HOUR;
    NSInteger minute = (NSInteger)floor(interval/S_MINUTE);
    interval -= minute * S_MINUTE;
    NSInteger second = (NSInteger)floor(interval);
    result = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    return result;
}
+ (NSDate *)parseSWTimeFormat:(NSString *)strTime {
	if ([Util isEmptyString:strTime]) {
		return nil;
	}		
	return [NSDate dateWithTimeIntervalSince1970:[strTime doubleValue]/1000];
}

#pragma marc Empty String
+ (BOOL)isEmptyString:(NSString *)string {
    BOOL result = NO;
    if (string == nil || [string length] == 0 || [string isEqualToString:@""]) {
        result = YES;
    }
    return result;
}

#pragma marc URL Encode
+ (NSString *)base64URLEncodeWith:(NSString *)urlstring {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)urlstring,
                                                                           NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                           kCFStringEncodingUTF8 );
    [result autorelease];
    return result;
}
+ (NSString *)urlDecode:(NSString *)originalString {
    NSString* strResult = [originalString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    strResult = [strResult stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return strResult;
}
+ (NSString *)urlEncode:(NSString *)originalString stringEncoding:(NSStringEncoding)stringEncoding {
    if ([Util isEmptyString:originalString]) {
		return nil;
	}	
	//!  @  $  &  (  )  =  +  ~  `  ;  '  :  ,  /  ?
	//%21%40%24%26%28%29%3D%2B%7E%60%3B%27%3A%2C%2F%3F
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,	@"$" , @"," ,
							@"!", @"'", @"(", @")", @"*", nil];	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" , @"%3A" , 
							 @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
							 @"%21", @"%27", @"%28", @"%29", @"%2A", nil];	
    int len = [escapeChars count];	
	NSString *temp = [originalString stringByAddingPercentEscapesUsingEncoding:stringEncoding];	
    for(int i = 0; i < len; i++) {
        temp = [temp stringByReplacingOccurrencesOfString:[escapeChars objectAtIndex:i]
											   withString:[replaceChars objectAtIndex:i]
												  options:NSLiteralSearch
													range:NSMakeRange(0, [temp length])];
    }	
    NSString *outString = [NSString stringWithString:temp];	
    return outString;
}
+ (NSString *)md5Hash:(NSString *)content {
	const char* str = [content UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

#pragma mark Image Manager
+ (UIImage *)imageWithName:(NSString *)imgname {
	return [Util imageWithName:imgname ofType:@"png"];
}
+ (UIImage *)imageWithName:(NSString *)imgname ofType:(NSString *)imgtype {
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgname ofType:imgtype]];
}
+ (UIImage *)scaleImageWithName:(NSString*)imgname {
    return [[UIImage alloc] initWithCGImage:
            [Util imageWithName:imgname].CGImage scale:1.0 orientation:UIImageOrientationDown];                
}
+ (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations
								 count:(int)count {
	CGFloat* components = malloc(sizeof(CGFloat)*4*count);
	for (int i = 0; i < count; ++i) {
		UIColor* color = colors[i];
		size_t n = CGColorGetNumberOfComponents(color.CGColor);
		const CGFloat* rgba = CGColorGetComponents(color.CGColor);
		if (n == 2) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[0];
			components[i*4+2] = rgba[0];
			components[i*4+3] = rgba[1];
		} else if (n == 4) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[1];
			components[i*4+2] = rgba[2];
			components[i*4+3] = rgba[3];
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
	free(components);
	return gradient;
}

#pragma mark Rotate
+ (void)rotateView:(UIView *)view From:(UIInterfaceOrientation)currentOrientation To:(UIInterfaceOrientation)targetOrientation With:(BOOL)animated Delegate:(id)delegate {
	UIInterfaceOrientation current = currentOrientation;
	UIInterfaceOrientation orientation = targetOrientation;    
    
    if ( current == orientation )
        return;
    
    // direction and angle
    CGFloat angle = 0.0;
    switch ( current )
    {
        case UIInterfaceOrientationPortrait:
        {
            switch ( orientation )
            {
                case UIInterfaceOrientationPortraitUpsideDown:
                    angle = (CGFloat)M_PI;  // 180.0*M_PI/180.0 == M_PI
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    angle = (CGFloat)(M_PI*-90.0)/180.0;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    angle = (CGFloat)(M_PI*90.0)/180.0;
                    break;
                default:
                    return;
            }
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            switch ( orientation )
            {
                case UIInterfaceOrientationPortrait:
                    angle = (CGFloat)M_PI;  // 180.0*M_PI/180.0 == M_PI
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    angle = (CGFloat)(M_PI*90.0)/180.0;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    angle = (CGFloat)(M_PI*-90.0)/180.0;
                    break;
                default:
                    return;
            }
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            switch ( orientation )
            {
                case UIInterfaceOrientationLandscapeRight:
                    angle = (CGFloat)M_PI;  // 180.0*M_PI/180.0 == M_PI
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    angle = (CGFloat)(M_PI*-90.0)/180.0;
                    break;
                case UIInterfaceOrientationPortrait:
                    angle = (CGFloat)(M_PI*90.0)/180.0;
                    break;
                default:
                    return;
            }
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            switch ( orientation )
            {
                case UIInterfaceOrientationLandscapeLeft:
                    angle = (CGFloat)M_PI;  // 180.0*M_PI/180.0 == M_PI
                    break;
                case UIInterfaceOrientationPortrait:
                    angle = (CGFloat)(M_PI*-90.0)/180.0;
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    angle = (CGFloat)(M_PI*90.0)/180.0;
                    break;
                default:
                    return;
            }
            break;
        }
    }
	
	UIView *v = view;
	if (animated) {	
		[UIView beginAnimations:@"RotateAnimation" context:NULL];
		[UIView setAnimationDuration:0.3];
		//v.transform = CGAffineTransformRotate(v.transform, angle);
        v.layer.transform = CATransform3DRotate(v.layer.transform, angle, 0.0, 0.0, 1.0);
		[UIView commitAnimations];
	}else {
		//v.transform = CGAffineTransformRotate(v.transform, angle);
        v.layer.transform = CATransform3DRotate(v.layer.transform, angle, 0.0, 0.0, 1.0);
	}
}

+ (void)replaceDictionaryValue:(NSMutableDictionary*)dict value:(id)value forKey:(id)key {
	[dict removeObjectForKey:key];
	[dict setObject:value forKey:key];
}

#pragma mark Sysctlbyname Utils
+ (NSString *)getSysInfoByName:(char *)typeSpecifier {
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}
+ (NSString *)platform {
	return [Util getSysInfoByName:"hw.machine"];
}
+ (UIDevicePlatform)platformType {
	NSString *platform = [Util platform];
    if ([platform hasPrefix:@"iPhone3"])			return UIDevice4iPhone;
	if ([platform hasPrefix:@"iPhone4"])			return UIDevice5iPhone;
    if ([platform hasPrefix:@"iPhone2"])	        return UIDevice3GSiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])	return UIDevice3GiPhone;
    
    if ([platform isEqualToString:@"iPad1,1"])      return UIDevice1GiPad;
	if ([platform isEqualToString:@"iPad2,1"])      return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
	
    if ([platform isEqualToString:@"iPod3,1"])      return UIDevice3GiPod;
	if ([platform isEqualToString:@"iPod4,1"])      return UIDevice4GiPod;
    if ([platform isEqualToString:@"iPod1,1"])      return UIDevice1GiPod;
	if ([platform isEqualToString:@"iPod2,1"])      return UIDevice2GiPod;
	if ([platform isEqualToString:@"iPhone1,1"])	return UIDevice1GiPhone;
	return UIDeviceUnknown;
}
+ (BOOL)isCurrentVersionLowerThanRequiredVersion:(NSString *)sysVersion {
	NSString *curVersion = [[UIDevice currentDevice] systemVersion];
	if ([curVersion compare:sysVersion options:NSNumericSearch] == NSOrderedAscending) {
		return YES;
	}
	return NO;
}
+ (void)removeAndReleaseViewSafefly:(UIView *)aview {
	if (aview.superview) {
		[aview removeFromSuperview];
	}
	[aview release];
	aview = nil;
}
+ (NSLocale*) currentLocale {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
	if (languages.count > 0) {
		NSString* currentLanguage = [languages objectAtIndex:0];
		return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
	} else {
		return [NSLocale currentLocale];
	}
}

#pragma mark UUID
+ (NSString *)currentUUIDString {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:kSohuMTCUUID];
    if ([Util isEmptyString:uuid]) {
        CFUUIDRef _UUIDRef = CFUUIDCreate(NULL);
        CFStringRef _StringRef = CFUUIDCreateString(NULL, _UUIDRef);
        CFRelease(_UUIDRef);
        uuid = [(NSString *)_StringRef autorelease];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:kSohuMTCUUID];
    }
    return uuid;
}

@end


#pragma mark - Base64Encode/Decode
#include <math.h>

const UInt8 kBase64EncodeTable[64] = {
	/*  0 */ 'A',	/*  1 */ 'B',	/*  2 */ 'C',	/*  3 */ 'D', 
	/*  4 */ 'E',	/*  5 */ 'F',	/*  6 */ 'G',	/*  7 */ 'H', 
	/*  8 */ 'I',	/*  9 */ 'J',	/* 10 */ 'K',	/* 11 */ 'L', 
	/* 12 */ 'M',	/* 13 */ 'N',	/* 14 */ 'O',	/* 15 */ 'P', 
	/* 16 */ 'Q',	/* 17 */ 'R',	/* 18 */ 'S',	/* 19 */ 'T', 
	/* 20 */ 'U',	/* 21 */ 'V',	/* 22 */ 'W',	/* 23 */ 'X', 
	/* 24 */ 'Y',	/* 25 */ 'Z',	/* 26 */ 'a',	/* 27 */ 'b', 
	/* 28 */ 'c',	/* 29 */ 'd',	/* 30 */ 'e',	/* 31 */ 'f', 
	/* 32 */ 'g',	/* 33 */ 'h',	/* 34 */ 'i',	/* 35 */ 'j', 
	/* 36 */ 'k',	/* 37 */ 'l',	/* 38 */ 'm',	/* 39 */ 'n', 
	/* 40 */ 'o',	/* 41 */ 'p',	/* 42 */ 'q',	/* 43 */ 'r', 
	/* 44 */ 's',	/* 45 */ 't',	/* 46 */ 'u',	/* 47 */ 'v', 
	/* 48 */ 'w',	/* 49 */ 'x',	/* 50 */ 'y',	/* 51 */ 'z', 
	/* 52 */ '0',	/* 53 */ '1',	/* 54 */ '2',	/* 55 */ '3', 
	/* 56 */ '4',	/* 57 */ '5',	/* 58 */ '6',	/* 59 */ '7', 
	/* 60 */ '8',	/* 61 */ '9',	/* 62 */ '+',	/* 63 */ '/'
};

// '/' is replaced with '_'
const UInt8 kBase64EncodeTableForJSON[64] = {
    /*  0 */ 'A',	/*  1 */ 'B',	/*  2 */ 'C',	/*  3 */ 'D', 
    /*  4 */ 'E',	/*  5 */ 'F',	/*  6 */ 'G',	/*  7 */ 'H', 
    /*  8 */ 'I',	/*  9 */ 'J',	/* 10 */ 'K',	/* 11 */ 'L', 
    /* 12 */ 'M',	/* 13 */ 'N',	/* 14 */ 'O',	/* 15 */ 'P', 
    /* 16 */ 'Q',	/* 17 */ 'R',	/* 18 */ 'S',	/* 19 */ 'T', 
    /* 20 */ 'U',	/* 21 */ 'V',	/* 22 */ 'W',	/* 23 */ 'X', 
    /* 24 */ 'Y',	/* 25 */ 'Z',	/* 26 */ 'a',	/* 27 */ 'b', 
    /* 28 */ 'c',	/* 29 */ 'd',	/* 30 */ 'e',	/* 31 */ 'f', 
    /* 32 */ 'g',	/* 33 */ 'h',	/* 34 */ 'i',	/* 35 */ 'j', 
    /* 36 */ 'k',	/* 37 */ 'l',	/* 38 */ 'm',	/* 39 */ 'n', 
    /* 40 */ 'o',	/* 41 */ 'p',	/* 42 */ 'q',	/* 43 */ 'r', 
    /* 44 */ 's',	/* 45 */ 't',	/* 46 */ 'u',	/* 47 */ 'v', 
    /* 48 */ 'w',	/* 49 */ 'x',	/* 50 */ 'y',	/* 51 */ 'z', 
    /* 52 */ '0',	/* 53 */ '1',	/* 54 */ '2',	/* 55 */ '3', 
    /* 56 */ '4',	/* 57 */ '5',	/* 58 */ '6',	/* 59 */ '7', 
    /* 60 */ '8',	/* 61 */ '9',	/* 62 */ '+',	/* 63 */ '_'
};


/*
 -1 = Base64 end of data marker.
 -2 = White space (tabs, cr, lf, space)
 -3 = Noise (all non whitespace, non-base64 characters) 
 -4 = Dangerous noise
 -5 = Illegal noise (null byte)
 */

const SInt8 kBase64DecodeTable[128] = {
	/* 0x00 */ -5, 	/* 0x01 */ -3, 	/* 0x02 */ -3, 	/* 0x03 */ -3,
	/* 0x04 */ -3, 	/* 0x05 */ -3, 	/* 0x06 */ -3, 	/* 0x07 */ -3,
	/* 0x08 */ -3, 	/* 0x09 */ -2, 	/* 0x0a */ -2, 	/* 0x0b */ -2,
	/* 0x0c */ -2, 	/* 0x0d */ -2, 	/* 0x0e */ -3, 	/* 0x0f */ -3,
	/* 0x10 */ -3, 	/* 0x11 */ -3, 	/* 0x12 */ -3, 	/* 0x13 */ -3,
	/* 0x14 */ -3, 	/* 0x15 */ -3, 	/* 0x16 */ -3, 	/* 0x17 */ -3,
	/* 0x18 */ -3, 	/* 0x19 */ -3, 	/* 0x1a */ -3, 	/* 0x1b */ -3,
	/* 0x1c */ -3, 	/* 0x1d */ -3, 	/* 0x1e */ -3, 	/* 0x1f */ -3,
	/* ' ' */ -2,	/* '!' */ -3,	/* '"' */ -3,	/* '#' */ -3,
	/* '$' */ -3,	/* '%' */ -3,	/* '&' */ -3,	/* ''' */ -3,
	/* '(' */ -3,	/* ')' */ -3,	/* '*' */ -3,	/* '+' */ 62,
	/* ',' */ -3,	/* '-' */ -3,	/* '.' */ -3,	/* '/' */ 63,
	/* '0' */ 52,	/* '1' */ 53,	/* '2' */ 54,	/* '3' */ 55,
	/* '4' */ 56,	/* '5' */ 57,	/* '6' */ 58,	/* '7' */ 59,
	/* '8' */ 60,	/* '9' */ 61,	/* ':' */ -3,	/* ';' */ -3,
	/* '<' */ -3,	/* '=' */ -1,	/* '>' */ -3,	/* '?' */ -3,
	/* '@' */ -3,	/* 'A' */ 0,	/* 'B' */  1,	/* 'C' */  2,
	/* 'D' */  3,	/* 'E' */  4,	/* 'F' */  5,	/* 'G' */  6,
	/* 'H' */  7,	/* 'I' */  8,	/* 'J' */  9,	/* 'K' */ 10,
	/* 'L' */ 11,	/* 'M' */ 12,	/* 'N' */ 13,	/* 'O' */ 14,
	/* 'P' */ 15,	/* 'Q' */ 16,	/* 'R' */ 17,	/* 'S' */ 18,
	/* 'T' */ 19,	/* 'U' */ 20,	/* 'V' */ 21,	/* 'W' */ 22,
	/* 'X' */ 23,	/* 'Y' */ 24,	/* 'Z' */ 25,	/* '[' */ -3,
	/* '\' */ -3,	/* ']' */ -3,	/* '^' */ -3,	/* '_' */ -3,
	/* '`' */ -3,	/* 'a' */ 26,	/* 'b' */ 27,	/* 'c' */ 28,
	/* 'd' */ 29,	/* 'e' */ 30,	/* 'f' */ 31,	/* 'g' */ 32,
	/* 'h' */ 33,	/* 'i' */ 34,	/* 'j' */ 35,	/* 'k' */ 36,
	/* 'l' */ 37,	/* 'm' */ 38,	/* 'n' */ 39,	/* 'o' */ 40,
	/* 'p' */ 41,	/* 'q' */ 42,	/* 'r' */ 43,	/* 's' */ 44,
	/* 't' */ 45,	/* 'u' */ 46,	/* 'v' */ 47,	/* 'w' */ 48,
	/* 'x' */ 49,	/* 'y' */ 50,	/* 'z' */ 51,	/* '{' */ -3,
	/* '|' */ -3,	/* '}' */ -3,	/* '~' */ -3,	/* 0x7f */ -3
};

const SInt8 kBase64DecodeTableForJSON[128] = {
    /* 0x00 */ -5, 	/* 0x01 */ -3, 	/* 0x02 */ -3, 	/* 0x03 */ -3,
    /* 0x04 */ -3, 	/* 0x05 */ -3, 	/* 0x06 */ -3, 	/* 0x07 */ -3,
    /* 0x08 */ -3, 	/* 0x09 */ -2, 	/* 0x0a */ -2, 	/* 0x0b */ -2,
    /* 0x0c */ -2, 	/* 0x0d */ -2, 	/* 0x0e */ -3, 	/* 0x0f */ -3,
    /* 0x10 */ -3, 	/* 0x11 */ -3, 	/* 0x12 */ -3, 	/* 0x13 */ -3,
    /* 0x14 */ -3, 	/* 0x15 */ -3, 	/* 0x16 */ -3, 	/* 0x17 */ -3,
    /* 0x18 */ -3, 	/* 0x19 */ -3, 	/* 0x1a */ -3, 	/* 0x1b */ -3,
    /* 0x1c */ -3, 	/* 0x1d */ -3, 	/* 0x1e */ -3, 	/* 0x1f */ -3,
    /* ' ' */ -2,	/* '!' */ -3,	/* '"' */ -3,	/* '#' */ -3,
    /* '$' */ -3,	/* '%' */ -3,	/* '&' */ -3,	/* ''' */ -3,
    /* '(' */ -3,	/* ')' */ -3,	/* '*' */ -3,	/* '+' */ 62,
    /* ',' */ -3,	/* '-' */ -3,	/* '.' */ -3,	/* '/' */ -3,
    /* '0' */ 52,	/* '1' */ 53,	/* '2' */ 54,	/* '3' */ 55,
    /* '4' */ 56,	/* '5' */ 57,	/* '6' */ 58,	/* '7' */ 59,
    /* '8' */ 60,	/* '9' */ 61,	/* ':' */ -3,	/* ';' */ -3,
    /* '<' */ -3,	/* '=' */ -1,	/* '>' */ -3,	/* '?' */ -3,
    /* '@' */ -3,	/* 'A' */ 0,	/* 'B' */  1,	/* 'C' */  2,
    /* 'D' */  3,	/* 'E' */  4,	/* 'F' */  5,	/* 'G' */  6,
    /* 'H' */  7,	/* 'I' */  8,	/* 'J' */  9,	/* 'K' */ 10,
    /* 'L' */ 11,	/* 'M' */ 12,	/* 'N' */ 13,	/* 'O' */ 14,
    /* 'P' */ 15,	/* 'Q' */ 16,	/* 'R' */ 17,	/* 'S' */ 18,
    /* 'T' */ 19,	/* 'U' */ 20,	/* 'V' */ 21,	/* 'W' */ 22,
    /* 'X' */ 23,	/* 'Y' */ 24,	/* 'Z' */ 25,	/* '[' */ -3,
    /* '\' */ -3,	/* ']' */ -3,	/* '^' */ -3,	/* '_' */ 63,
    /* '`' */ -3,	/* 'a' */ 26,	/* 'b' */ 27,	/* 'c' */ 28,
    /* 'd' */ 29,	/* 'e' */ 30,	/* 'f' */ 31,	/* 'g' */ 32,
    /* 'h' */ 33,	/* 'i' */ 34,	/* 'j' */ 35,	/* 'k' */ 36,
    /* 'l' */ 37,	/* 'm' */ 38,	/* 'n' */ 39,	/* 'o' */ 40,
    /* 'p' */ 41,	/* 'q' */ 42,	/* 'r' */ 43,	/* 's' */ 44,
    /* 't' */ 45,	/* 'u' */ 46,	/* 'v' */ 47,	/* 'w' */ 48,
    /* 'x' */ 49,	/* 'y' */ 50,	/* 'z' */ 51,	/* '{' */ -3,
    /* '|' */ -3,	/* '}' */ -3,	/* '~' */ -3,	/* 0x7f */ -3
};

const UInt8 kBits_00000011 = 0x03;
const UInt8 kBits_00001111 = 0x0F;
const UInt8 kBits_00110000 = 0x30;
const UInt8 kBits_00111100 = 0x3C;
const UInt8 kBits_00111111 = 0x3F;
const UInt8 kBits_11000000 = 0xC0;
const UInt8 kBits_11110000 = 0xF0;
const UInt8 kBits_11111100 = 0xFC;

size_t EstimateBase64EncodedDataSize(size_t inDataSize)
{
    size_t theEncodedDataSize = (int)ceil(inDataSize / 3.0) * 4;
    theEncodedDataSize = theEncodedDataSize / 72 * 74 + theEncodedDataSize % 72;
    return(theEncodedDataSize);
}

size_t EstimateBase64DecodedDataSize(size_t inDataSize)
{
    size_t theDecodedDataSize = (int)ceil(inDataSize / 4.0) * 3;
    //theDecodedDataSize = theDecodedDataSize / 72 * 74 + theDecodedDataSize % 72;
    return(theDecodedDataSize);
}

bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped)
{
    size_t theEncodedDataSize = EstimateBase64EncodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theEncodedDataSize)
        return(false);
    
    // TODO: make sure this doesn't regress email!
    //*ioOutputDataSize = theEncodedDataSize;
    
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt32 theInIndex = 0, theOutIndex = 0;
    for (; theInIndex < (inInputDataSize / 3) * 3; theInIndex += 3)
	{
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (theInPtr[theInIndex + 2] & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 2] & kBits_00111111) >> 0];
        if (wrapped && (theOutIndex % 74 == 72))
		{
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
		}
	}
    const size_t theRemainingBytes = inInputDataSize - theInIndex;
    if (theRemainingBytes == 1)
	{
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (0 & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = '=';
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
		{
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
		}
	}
    else if (theRemainingBytes == 2)
	{
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (0 & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
		{
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
		}
	}
    
    *ioOutputDataSize = theOutIndex;
    
    return(true);
}

bool Base64EncodeDataForJSON(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize)
{
    size_t theEncodedDataSize = EstimateBase64EncodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theEncodedDataSize)
        return(false);
    
    // This is pretty worthless
    // *ioOutputDataSize = theEncodedDataSize;
    
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt32 theInIndex = 0, theOutIndex = 0;
    for (; theInIndex < (inInputDataSize / 3) * 3; theInIndex += 3)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (theInPtr[theInIndex + 2] & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex + 2] & kBits_00111111) >> 0];
    }
    const size_t theRemainingBytes = inInputDataSize - theInIndex;
    if (theRemainingBytes == 1)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex] & kBits_00000011) << 4 | (0 & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = '=';
        outOutputData[theOutIndex++] = '=';
    }
    else if (theRemainingBytes == 2)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTableForJSON[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (0 & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = '=';
    }
    
    *ioOutputDataSize = theOutIndex;
    
    return(true);    
}

bool Base64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize)
{
    memset(ioOutputData, '.', *ioOutputDataSize);
    
    size_t theDecodedDataSize = EstimateBase64DecodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theDecodedDataSize)
        return(false);
    *ioOutputDataSize = 0;
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt8 *theOutPtr = (UInt8 *)ioOutputData;
    size_t theInIndex = 0, theOutIndex = 0;
    UInt8 theOutputOctet;
    size_t theSequence = 0;
    for (; theInIndex < inInputDataSize; )
	{
        SInt8 theSextet = 0;
        
        SInt8 theCurrentInputOctet = theInPtr[theInIndex];
        theSextet = kBase64DecodeTable[theCurrentInputOctet];
        if (theSextet == -1)
            break;
        while (theSextet == -2)
		{
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = kBase64DecodeTable[theCurrentInputOctet];
		}
        while (theSextet == -3)
		{
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = kBase64DecodeTable[theCurrentInputOctet];
		}
        if (theSequence == 0)
		{
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 2 & kBits_11111100;
		}
        else if (theSequence == 1)
		{
            theOutputOctet |= (theSextet >- 0 ? theSextet : 0) >> 4 & kBits_00000011;
            theOutPtr[theOutIndex++] = theOutputOctet;
		}
        else if (theSequence == 2)
		{
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 4 & kBits_11110000;
		}
        else if (theSequence == 3)
		{
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 2 & kBits_00001111;
            theOutPtr[theOutIndex++] = theOutputOctet;
		}
        else if (theSequence == 4)
		{
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 6 & kBits_11000000;
		}
        else if (theSequence == 5)
		{
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 0 & kBits_00111111;
            theOutPtr[theOutIndex++] = theOutputOctet;
		}
        theSequence = (theSequence + 1) % 6;
        if (theSequence != 2 && theSequence != 4)
            theInIndex++;
	}
    *ioOutputDataSize = theOutIndex;
    return(true);
}

bool Base64DecodeDataForJSON(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize)
{
    memset(ioOutputData, '.', *ioOutputDataSize);
    
    size_t theDecodedDataSize = EstimateBase64DecodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theDecodedDataSize)
        return(false);
    *ioOutputDataSize = 0;
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt8 *theOutPtr = (UInt8 *)ioOutputData;
    size_t theInIndex = 0, theOutIndex = 0;
    UInt8 theOutputOctet;
    size_t theSequence = 0;
    for (; theInIndex < inInputDataSize; )
	{
        SInt8 theSextet = 0;
        
        SInt8 theCurrentInputOctet = theInPtr[theInIndex];
        theSextet = kBase64DecodeTableForJSON[theCurrentInputOctet];
        if (theSextet == -1)
            break;
        while (theSextet == -2)
		{
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = kBase64DecodeTableForJSON[theCurrentInputOctet];
		}
        while (theSextet == -3)
		{
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = kBase64DecodeTableForJSON[theCurrentInputOctet];
		}
        if (theSequence == 0)
		{
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 2 & kBits_11111100;
		}
        else if (theSequence == 1)
		{
            theOutputOctet |= (theSextet >- 0 ? theSextet : 0) >> 4 & kBits_00000011;
            theOutPtr[theOutIndex++] = theOutputOctet;
		}
        else if (theSequence == 2)
		{
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 4 & kBits_11110000;
		}
        else if (theSequence == 3)
		{
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 2 & kBits_00001111;
            theOutPtr[theOutIndex++] = theOutputOctet;
		}
        else if (theSequence == 4)
		{
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 6 & kBits_11000000;
		}
        else if (theSequence == 5)
		{
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 0 & kBits_00111111;
            theOutPtr[theOutIndex++] = theOutputOctet;
		}
        theSequence = (theSequence + 1) % 6;
        if (theSequence != 2 && theSequence != 4)
            theInIndex++;
	}
    *ioOutputDataSize = theOutIndex;
    return(true);
}

@implementation NSData (Base64Additions)

+(id)decodeBase64ForString:(NSString *)decodeString
{
    NSData *decodeBuffer = nil;
    // Must be 7-bit clean!
    NSData *tmpData = [decodeString dataUsingEncoding:NSASCIIStringEncoding];
    
    size_t estSize = EstimateBase64DecodedDataSize([tmpData length]);
    uint8_t* outBuffer = calloc(estSize, sizeof(uint8_t));
    
    size_t outBufferLength = estSize;
    if (Base64DecodeData([tmpData bytes], [tmpData length], outBuffer, &outBufferLength))
    {
        decodeBuffer = [NSData dataWithBytesNoCopy:outBuffer length:outBufferLength freeWhenDone:YES];
    }
    else
    {
        free(outBuffer);
        [NSException raise:@"NSData+Base64AdditionsException" format:@"Unable to decode data!"];
    }
    
    return decodeBuffer;
}

+(id)decodeWebSafeBase64ForString:(NSString *)decodeString
{
    return [NSData decodeBase64ForString:[[decodeString stringByReplacingOccurrencesOfString:@"-" withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
}

-(NSString *)encodeBase64ForData
{
    NSString *encodedString = nil;
    
    // Make sure this is nul-terminated.
    size_t outBufferEstLength = EstimateBase64EncodedDataSize([self length]) + 1;
    char *outBuffer = calloc(outBufferEstLength, sizeof(char));
    
    size_t outBufferLength = outBufferEstLength;
    if (Base64EncodeData([self bytes], [self length], outBuffer, &outBufferLength, FALSE))
    {
        encodedString = [NSString stringWithCString:outBuffer encoding:NSASCIIStringEncoding];
    }
    else
    {
        [NSException raise:@"NSData+Base64AdditionsException" format:@"Unable to encode data!"];
    }
    
    free(outBuffer);
    
    return encodedString;
}

-(NSString *)encodeWebSafeBase64ForData
{
    return [[[self encodeBase64ForData] stringByReplacingOccurrencesOfString:@"+" withString:@"-"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

-(NSString *)encodeWrappedBase64ForData
{
    NSString *encodedString = nil;
    
    // Make sure this is nul-terminated.
    size_t outBufferEstLength = EstimateBase64EncodedDataSize([self length]) + 1;
    char *outBuffer = calloc(outBufferEstLength, sizeof(char));
    
    size_t outBufferLength = outBufferEstLength;
    if (Base64EncodeData([self bytes], [self length], outBuffer, &outBufferLength, TRUE))
    {
        encodedString = [NSString stringWithCString:outBuffer encoding:NSASCIIStringEncoding];
    }
    else
    {
        [NSException raise:@"NSData+Base64AdditionsException" format:@"Unable to encode data!"];
    }
    
    free(outBuffer);
    
    return encodedString;
}

@end

#pragma mark - AES Encrypt/Decrypt
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AESAdditions)
- (NSData*)AES256EncryptWithKey:(NSString*)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)AES256DecryptWithKey:(NSString*)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}
@end

@implementation NSString (AESAdditions)
- (NSString *)AES256EncryptWithKey:(NSString *)key {
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES256EncryptWithKey:key];
    
    NSString *encryptedString = [encryptedData encodeBase64ForData];
    
    return encryptedString;
}
- (NSString *)AES256DecryptWithKey:(NSString *)key {
    NSData *encryptedData = [NSData decodeBase64ForString:self];
    NSData *plainData = [encryptedData AES256DecryptWithKey:key];
    
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    
    return [plainString autorelease];
}
@end
