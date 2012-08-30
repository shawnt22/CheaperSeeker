//
//  SViewController.m
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//

#import "SViewController.h"

@implementation SViewController

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
        [self initSubobjects];
    }
    return self;
}
- (void)initSubobjects {
}
- (void)dealloc {
    [super dealloc];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
