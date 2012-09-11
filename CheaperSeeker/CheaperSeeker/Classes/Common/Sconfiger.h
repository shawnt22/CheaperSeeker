//
//  SConfiger.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//
#pragma mark - Import
#import "SUtil.h"
#import "Util.h"
#import "SDefine.h"

#pragma mark - Error
typedef enum {
    SErrorInvalide = 0,         //  无效的
}SErrorCode;

#pragma mark - Layout
#define kMarginLeft 10.0

#define kCustomCellBGLineColor          SRGBCOLOR(211, 211, 211)
#define kCustomCellBGFillColor          SRGBCOLOR(239, 239, 239)
#define kCustomCellBGInnerShadowColor   SRGBCOLOR(250, 250, 250)
#define kCustomCellSelectedBGLineColor  kCustomCellBGLineColor
#define kCustomCellSelectedBGFillColor  SRGBCOLOR(255, 72, 0)
#define kCustomCellBGLineColor2         SRGBCOLOR(25, 25, 27)
#define kCustomCellBGFillColor2         SRGBCOLOR(38, 40, 42)
#define kCustomCellBGInnerShadowColor2  SRGBCOLOR(49, 50, 52)
#define kCustomCellBGFillColor3         SRGBCOLOR(33, 34, 36)

#define kSiderCellBGLineColor           SRGBCOLOR(52, 53, 57)
#define kSiderCellBGFillColor           SRGBCOLOR(84, 84, 84)
#define kSiderCellSelectedBGFillColor   SRGBCOLOR(54, 54, 54)

#define kTextColor                      SRGBCOLOR(255, 255, 255)
#define kTextShadowColor                SRGBCOLOR(6, 6, 6)
#define kTextShadowOffset               CGSizeMake(0.0, -1.0)

#pragma mark - Notification