//
//  Level_four_itemThreeViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_four_itemThreeViewController.h"

@interface Level_four_itemThreeViewController ()

@end

@implementation Level_four_itemThreeViewController

#pragma mark - 生命周期
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    [self sendNetWorking];
    
    [self initUI];
    
    [self dispatch_barrier_async];
}

#pragma mark - 系统代理

#pragma mark - 点击事件

#pragma mark - 网络请求
- (void)sendNetWorking {
    
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"dispatch_barrier_async";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {
    
    
}

- (void)dispatch_barrier_async {

    dispatch_queue_t queue = dispatch_queue_create("customIdenrifier", NULL);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async1");
    });
    
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_async2");
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"dispatch_barrier_async");
        [NSThread sleepForTimeInterval:4];
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");
    });
    
}

#pragma mark - setter & getter

@end
