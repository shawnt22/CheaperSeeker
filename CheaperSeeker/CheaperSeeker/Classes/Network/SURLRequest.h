//
//  SURLRequest.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

@interface SURLRequest : ASIFormDataRequest {
}
@property (nonatomic, retain) id responseResult;

@end
