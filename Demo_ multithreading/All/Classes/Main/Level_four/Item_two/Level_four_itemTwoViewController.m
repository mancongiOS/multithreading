//
//  Level_four_itemTwoViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_four_itemTwoViewController.h"

@interface Level_four_itemTwoViewController ()

@end

@implementation Level_four_itemTwoViewController

#pragma mark - 生命周期
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    [self sendNetWorking];
    
    [self initUI];
    
    [self dispatch_group_async];
}

#pragma mark - 系统代理

#pragma mark - 点击事件

#pragma mark - 网络请求
- (void)sendNetWorking {
    
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"dispatch_group_async";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {
    
    
}

- (void)dispatch_group_async {

    /**
     dispatch_group_async可以实现监听一组任务是否完成，完成后得到通知执行其他的操作。这个方法很有用，比如你执行三个下载任务，当三个任务都下载完成后你才通知界面说完成的了。下面是一段例子代码
     */
    
    //1. 获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2. 创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
       
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group1");
        
        // 你的网络请求代码
    });
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
        
        [NSThread sleepForTimeInterval:5];
        NSLog(@"group2");
        
        // 你的网络请求代码
    });
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
        
        [NSThread sleepForTimeInterval:3];
        NSLog(@"group3");
        
        // 你的网络请求代码
    });
    
    
    // 回到主队列中,刷新UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"更新UI页面");
    });

    /** 非ARC下销毁group对象
     dispatch_release(group);
     */
}


#pragma mark - setter & getter

@end
