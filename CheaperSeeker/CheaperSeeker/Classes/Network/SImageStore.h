//
//  SImageStore.h
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-5.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SImageLoader.h"

@class PImageStore;
@protocol PImageStoreDelegate <NSObject>
@optional
- (void)imageStore:(PImageStore *)imageStore didFinishLoadImage:(UIImage *)image forURL:(NSString *)url;

- (void)imageStore:(PImageStore *)imageStore didStartLoadImageForURL:(NSString *)url;
- (void)imageStore:(PImageStore *)imageStore didFailLoadImageForURL:(NSString *)url Error:(NSError *)error;
- (void)imageStore:(PImageStore *)imageStore didCancelLoadImageForURL:(NSString *)url;
@end

@interface PImageStore : NSObject<SImageLoaderDelegate> {
@private
}
@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, assign) NSInteger storedImageMaxNumber;   //  0为不做限定

- (UIImage *)resumeImageWithURL:(NSString *)url Observer:(id<PImageStoreDelegate>)observer;
- (void)receiveMemoryWarning;
- (void)removeObserver:(id<PImageStoreDelegate>)observer;

@end
