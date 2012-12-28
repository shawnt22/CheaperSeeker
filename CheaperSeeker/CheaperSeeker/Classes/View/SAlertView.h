//
//  SAlertView.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-12-28.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAlertView;
@protocol SAlertViewDelegate <NSObject>
@optional

@end

typedef enum {
    SAlertViewTextOnly,
    SAlertViewIndicatorOnly,
}SAlertViewStyle;

@interface SAlertView : UIView

@end
