//
//  UIImage_Additions.h
//  SohuZhuake
//
//  Created by Teng Song on 12-3-23.
//  Copyright (c) 2012年 Sohu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(SimageView_Draw)

/*
 * Resizes an image. Optionally rotates the image based on imageOrientation.
 */
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate;;

/**
 * Returns a CGRect positioned within rect given the contentMode.
 */
- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

/**
 * Draws the image using content mode rules.
 */
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;

/**
 * Draws the image as a rounded rectangle.
 */
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius;
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;

/**
 * Create image
 */
+ (UIImage *)imageWithName:(NSString *)imgname;
+ (UIImage *)imageWithName:(NSString *)imgname ofType:(NSString *)imgtype;

/**
* scal and clip center image
*/
+(UIImage *)scalAndClipCenterImage:(UIImage *)image targetSize:(CGSize)targetSize;
@end
