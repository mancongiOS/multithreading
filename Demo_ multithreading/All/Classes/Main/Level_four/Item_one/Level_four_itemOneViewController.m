//
//  Level_four_itemOneViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_four_itemOneViewController.h"

#import "Masonry.h"

#import "Header.h"

@interface Level_four_itemOneViewController ()

@property (nonatomic, strong) UIImageView * imageView_one;

@end

@implementation Level_four_itemOneViewController

#pragma mark - 生命周期
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    [self sendNetWorking];
    
    [self initUI];
    
    [self one];
    [self two];
}

#pragma mark - 系统代理

#pragma mark - 点击事件

#pragma mark - 网络请求
- (void)sendNetWorking {
    
    
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {

    [self.view addSubview:self.imageView_one];
    [self.imageView_one mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(10);
        make.top.mas_equalTo(self.view).with.offset(74);
        make.size.mas_equalTo(CGSizeMake(ScreenW - 20, 150));
    }];
}

- (void)one {
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
       // 执行一些耗时间的操作
       dispatch_async(dispatch_get_main_queue(), ^{
           // 回到主线程,刷新UI,或者点击触发UI事件
       });
   });
    
    
    // 实际使用
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL * url = [NSURL URLWithString:@"https://gd2.alicdn.com/imgextra/i1/0/TB1p6QnOFXXXXbFXFXXXXXXXXXX_!!0-item_pic.jpg"];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView_one.image = image;
            });
        }
    });

}

- (void)two {

}


#pragma mark - setter & getter

-(UIImageView *)imageView_one {
    if (_imageView_one == nil) {
        self.imageView_one = [[UIImageView alloc] init];
    } return _imageView_one;
}

@end
