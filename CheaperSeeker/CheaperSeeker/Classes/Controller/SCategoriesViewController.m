//
//  SCategoriesViewController.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCategoriesViewController.h"

@implementation SCategoriesViewController

#pragma mark init
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)initSubobjects {
    [super initSubobjects];
}
- (void)dealloc {
    [super dealloc];
}

#pragma mark ViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Category";
    [SUtil setNavigationBarSplitButtonItemWith:self];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark Actions
- (void)splitAction:(id)sender {
    [SUtil splitActionWith:self];
}

@end
