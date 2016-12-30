
//
//  Level_four_itemFiveViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_four_itemFiveViewController.h"

#import "Masonry.h"
#import "Header.h"

#define ItemWH                   (ScreenW - MARGIN*4) / 3
#define MARGIN                   20

#define MYQUEUE                  "myThreadQueue1"

@interface Level_four_itemFiveViewController ()

@property (nonatomic, strong) UIButton * clickedButton;
@property (nonatomic, strong) NSMutableArray * imageViewsArrayM;
@property (nonatomic, strong) NSMutableArray * imageNamesArrayM;

@end

@implementation Level_four_itemFiveViewController

#pragma mark - 生命周期
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    [self sendNetWorking];
    
    [self initUI];
}

#pragma mark - 点击事件
- (void)clickedButtonClickd {
    
    // 多线程下载图片
    NSInteger count = self.imageNamesArrayM.count;
    
    //创建一个串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create(MYQUEUE, DISPATCH_QUEUE_SERIAL);
    
    //创建多个线程用于填充图片
    for (int i = 0; i < count; ++i) {
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
            [self loadImage:i];
        });
    }
}

#pragma mark 加载图片
-(void)loadImage:(NSUInteger )index{
    
    //请求数据
    NSString * urlStr = [self.imageNamesArrayM objectAtIndex:index];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSData *data=[NSData dataWithContentsOfURL:url];
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue= dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self updateImageWithData:data andIndex:index];
    });
}
#pragma mark 将图片显示到界面
-(void)updateImageWithData:(NSData *)data andIndex:(NSInteger)index{
    UIImage *image=[UIImage imageWithData:data];
    UIImageView *imageView= self.imageViewsArrayM[index];
    imageView.image=image;
}

#pragma mark - 网络请求
- (void)sendNetWorking {
    //创建图片链接

    NSArray * array = @[
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175036054-1229067335.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175046054-1410401557.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175055570-783207556.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175103820-2144487664.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175109523-327441423.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175115961-859836922.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175131195-2009565896.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175136617-306726060.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175036054-1229067335.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175046054-1410401557.png",
                        @"http://images2015.cnblogs.com/blog/844918/201612/844918-20161230175055570-783207556.png",
                        ];
    
    self.imageNamesArrayM = [NSMutableArray arrayWithArray:array];
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"串行队列";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {
    
    NSInteger total = self.imageNamesArrayM.count;
    
    for (int i = 0; i < total; i ++) {
        
        NSInteger column = i % 3;   // 列数
        NSInteger row = i / 3;     // 行数

        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.view).with.offset((MARGIN + ItemWH) * column + MARGIN);
            make.size.mas_equalTo(CGSizeMake(ItemWH, ItemWH));
            make.top.mas_equalTo(self.view).with.offset(74 + (MARGIN + ItemWH) * row);
        }];
        
        [self.imageViewsArrayM addObject:imageView];
    }
    
    [self.view addSubview:self.clickedButton];
    [self.clickedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - setter & getter

- (UIButton *)clickedButton {
    if (_clickedButton == nil) {
        self.clickedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clickedButton.backgroundColor = [UIColor orangeColor];
        [self.clickedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.clickedButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.clickedButton setTitle:@"加载图片" forState:UIControlStateNormal];
        [self.clickedButton addTarget:self action:@selector(clickedButtonClickd) forControlEvents:UIControlEventTouchUpInside];
    } return _clickedButton;
}

- (NSMutableArray *)imageViewsArrayM {
    if (_imageViewsArrayM == nil) {
        self.imageViewsArrayM = [NSMutableArray arrayWithCapacity:0];
    } return _imageViewsArrayM;
}

- (NSMutableArray *)imageNamesArrayM {
    if (_imageNamesArrayM == nil) {
        self.imageNamesArrayM = [NSMutableArray arrayWithCapacity:0];
    } return _imageNamesArrayM;
}

@end
