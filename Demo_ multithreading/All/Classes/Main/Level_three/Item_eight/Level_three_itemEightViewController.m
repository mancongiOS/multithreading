//
//  Level_three_itemEightViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_three_itemEightViewController.h"

@interface Level_three_itemEightViewController ()

@end

@implementation Level_three_itemEightViewController

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
    self.title = @"8";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {
    
    
}


#pragma mark - setter & getter

@end
