//
//  Level_four_itemEightViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_four_itemEightViewController.h"

#import "Masonry.h"
#import "Header.h"

#define ItemWH                   (ScreenW - MARGIN*4) / 3
#define MARGIN                   20

#define MYQUEUE                  "myThreadQueue1"
#define ImageCount               8

@interface Level_four_itemEightViewController ()
{
    NSMutableArray *_imagesArrayM;
}
@property (nonatomic, strong) UIButton * createButton;
@property (nonatomic, strong) UIButton * loadButton;
@property (nonatomic, strong) NSMutableArray * imageViewsArrayM;
@property (nonatomic, strong) NSMutableArray * imageNamesArrayM;

#pragma mark 当前加载的图片索引（图片链接地址连续）
@property (atomic,assign) int currentIndex;

@property (nonatomic, strong) NSCondition * condition;

@end

@implementation Level_four_itemEightViewController

/**
 线程的调度是透明的,程序有时候很难对它进行有效的控制.iOS提供了NSCondition来控制线程通信.NSCondition也遵守NSLocking协议,
 所以它本身就有lock和unlock方法.NSCondation可以解决线程同步的问题,但是更重要的是能解决线程之间的调度问题,当然这个过程也需要先加锁和解锁.
 wait方法控制某个线程处于等待状态.
 signal方法唤起一个线程,如果有多个线程,则任意唤起一个.
 broadcast方法唤起所有等待的线程.
 */

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

#pragma mark 产生图片
- (void)createButtonClickd {
    
    // 异步创建一张图片
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 创建图片链接
    dispatch_async(globalQueue, ^{
       
        [self createImageName];
    });
}

- (void)createImageName {
    

    [self.condition lock];
    
    // 如果当前有图片则不创建,线程处于等待状态
    if (self.imageNamesArrayM.count > 0) {
        NSLog(@"createImageName wait, current:%i",_currentIndex);
        [self.condition wait];
    } else {
        NSLog(@"createImageName work, current:%i",_currentIndex);

        //生产者，每次生产1张图片
        NSString * str = [_imagesArrayM objectAtIndex:_currentIndex];
        [self.imageNamesArrayM addObject:str];
        _currentIndex ++;
        
        //创建完图片则发出信号唤醒其他等待线程
        [self.condition signal];
    }
    
    [self.condition unlock];
}


#pragma mark 加载图片
- (void)loadButtonClickd {

    if (_currentIndex > 8) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片张数超过8张,返回重试!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
    
        // 多线程下载图片
        
        //创建一个串行队列
        dispatch_queue_t serialQueue = dispatch_queue_create(MYQUEUE, DISPATCH_QUEUE_SERIAL);
        
        //创建多个线程用于填充图片
            //异步执行队列任务
        dispatch_async(serialQueue, ^{
            [self loadImage:_currentIndex - 1];
        });
    }
}


#pragma mark 加载图片
-(void)loadImage:(NSUInteger)index{
    
    // 加锁
    [self.condition lock];
    
    // 如果当前有图片资源则加载,否则等待
    if (self.imageNamesArrayM.count > 0) {
        NSLog(@"loadImage work,index is %lu",(unsigned long)index);
        [self loadAnUpdateImageWithIndex:index];
        [_condition broadcast];
    }else{
        NSLog(@"loadImage wait,index is %lu",(unsigned long)index);
        //线程等待
        [_condition wait];
        NSLog(@"loadImage resore,index is %lu",(unsigned long)index);
        //一旦创建完图片立即加载
        [self loadAnUpdateImageWithIndex:index];
    }
    [self.condition unlock];
    
}

-(void)loadAnUpdateImageWithIndex:(NSUInteger)index{
    //请求数据
    NSData *data= [self requestData:index];
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue= dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        UIImage *image=[UIImage imageWithData:data];
        UIImageView *imageView= self.imageViewsArrayM[index];
        imageView.image=image;
    });
}

-(NSData *)requestData:(NSUInteger)index{
    NSData *data;
    NSString *name;
    name = [self.imageNamesArrayM lastObject];
    [self.imageNamesArrayM removeObject:name];
    if(name){
        NSURL *url=[NSURL URLWithString:name];
        data=[NSData dataWithContentsOfURL:url];
    }
    return data;
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
    _imagesArrayM = [NSMutableArray arrayWithArray:array];
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"串行队列";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _currentIndex = 0;
}

#pragma mark - UI布局
- (void)initUI {
    
    
    NSInteger total = 8;
    
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
    
    
    [self.view addSubview:self.createButton];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenW / 2);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.loadButton];
    [self.loadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenW / 2);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - setter & getter

- (UIButton *)createButton {
    if (_createButton == nil) {
        self.createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.createButton.backgroundColor = [UIColor orangeColor];
        [self.createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.createButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.createButton setTitle:@"产生图片" forState:UIControlStateNormal];
        [self.createButton addTarget:self action:@selector(createButtonClickd) forControlEvents:UIControlEventTouchUpInside];
    } return _createButton;
}

- (UIButton *)loadButton {
    if (_loadButton == nil) {
        self.loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loadButton.backgroundColor = [UIColor greenColor];
        [self.loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loadButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.loadButton setTitle:@"加载图片" forState:UIControlStateNormal];
        [self.loadButton addTarget:self action:@selector(loadButtonClickd) forControlEvents:UIControlEventTouchUpInside];
    } return _loadButton;
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

- (NSCondition *)condition {
    if (_condition == nil) {
        self.condition = [[NSCondition alloc] init];
    } return _condition;
}

@end
