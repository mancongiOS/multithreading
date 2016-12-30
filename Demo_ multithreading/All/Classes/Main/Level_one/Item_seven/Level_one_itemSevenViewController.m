//
//  Level_one_itemSevenViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_one_itemSevenViewController.h"

@interface Level_one_itemSevenViewController ()

@end

@implementation Level_one_itemSevenViewController

#pragma mark - 生命周期
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    [self sendNetWorking];
    
    [self initUI];
}

#pragma mark - 系统代理

#pragma mark - 点击事件

#pragma mark - 网络请求
- (void)sendNetWorking {
    
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"7";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {
    
    
}


#pragma mark - setter & getter

@end
