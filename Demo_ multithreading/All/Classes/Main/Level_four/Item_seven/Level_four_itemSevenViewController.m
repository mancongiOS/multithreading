//
//  Level_four_itemSevenViewController.m
//  Demo_ multithreading
//
//  Created by goulela on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_four_itemSevenViewController.h"
#import "Masonry.h"
#import "Header.h"

#define ItemWH                   (ScreenW - MARGIN*4) / 3
#define MARGIN                   20

#define MYQUEUE                  "myThreadQueue1"

@interface Level_four_itemSevenViewController ()
{
    // 使用GCD解决资源抢占问题
    dispatch_semaphore_t _semaphore;//定义一个信号量
}
@property (nonatomic, strong) UIButton * clickedButton;
@property (nonatomic, strong) NSMutableArray * imageViewsArrayM;
@property (nonatomic, strong) NSMutableArray * imageNamesArrayM;
@property (nonatomic, strong) NSLock * lock;

@end

@implementation Level_four_itemSevenViewController

/**  说明
 拿图片加载来举例，假设现在有8张图片，但是有15个线程都准备加载这8张图片，约定不能重复加载同一张图片，这样就形成了一个资源抢夺的情况。在下面的程序中将创建8张图片，每次读取照片链接时首先判断当前链接数是否大于1，用完一个则立即移除，最多只有8个.
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
- (void)clickedButtonClickd {
    
    // 多线程现在图片
    
    NSInteger count = 15;
    
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

    /**  三种方式
     一个线程A已经开始获取图片链接，获取完之后还没有来得及从self.imageNamesArrayM中删除，另一个线程B已经进入相应代码中，由于每次读取的都是self.imageNamesArrayM的最后一个元素，因此后面的线程其实和前面线程取得的是同一个图片链接这样就造成图中看到的情况。要解决这个问题，只要保证线程A进入相应代码之后B无法进入，只有等待A完成相关操作之后B才能进入即可。这样才不会出错.
     */
    
    // 1
    [self ThreadSynchronization_wayOneWithIndex:index];
    
    // 2
    //[self ThreadSynchronization_wayTwoWithIndex:index];
    
    // 3
    //[self ThreadSynchronization_wayThreeWithIndex:index];
}

- (void)ThreadSynchronization_wayOneWithIndex:(NSInteger)index {
   
    NSString * urlStr;
    NSData *data;
    
    /** 线程同步方法1: NSLock
     1.线程使用前加锁,线程使用后解锁
     2.iOS中对于资源抢占的问题可以使用同步锁NSLock来解决，使用时把需要加锁的代码（以后暂时称这段代码为”加锁代码“）放到NSLock的lock和unlock之间，一个线程A进入加锁代码之后由于已经加锁，另一个线程B就无法访问，只有等待前一个线程A执行完加锁代码后解锁，B线程才能访问加锁代码。需要注意的是lock和unlock之间的”加锁代码“应该是抢占资源的读取和修改代码，不要将过多的其他操作代码放到里面，否则一个线程执行的时候另一个线程就一直在等待，就无法发挥多线程的作用了
     */

    
    [self.lock lock];
    if (self.imageNamesArrayM.count > 0) {
        urlStr = [self.imageNamesArrayM lastObject];
        [self.imageNamesArrayM removeObject:urlStr];
    }
    [self.lock unlock];
    
    if (urlStr) {
        NSURL * url = [NSURL URLWithString:urlStr];
        data = [NSData dataWithContentsOfURL:url];
    }
    
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue= dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self updateImageWithData:data andIndex:index];
    });
}

- (void)ThreadSynchronization_wayTwoWithIndex:(NSInteger)index {
    
    /** 线程同步方法2: @synchronized代码块
     使用@synchronized解决线程同步问题相比较NSLock要简单一些，日常开发中也更推荐使用此方法。首先选择一个对象作为同步对象（一般使用self），然后将”加锁代码”（争夺资源的读取、修改代码）放到代码块中。@synchronized中的代码执行时先检查同步对象是否被另一个线程占用，如果占用该线程就会处于等待状态，直到同步对象被释放
     */
    
    NSString * urlStr;
    NSData *data;
    
    @synchronized (self) {
        if (self.imageNamesArrayM.count > 0) {
            urlStr = [self.imageNamesArrayM lastObject];
            [self.imageNamesArrayM removeObject:urlStr];
        }
    }
    
    if (urlStr) {
        NSURL * url = [NSURL URLWithString:urlStr];
        data = [NSData dataWithContentsOfURL:url];
    }
    
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue= dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self updateImageWithData:data andIndex:index];
    });
}

- (void)ThreadSynchronization_wayThreeWithIndex:(NSInteger)index {
    
    /** 线程同步方法三: GCD信号机制
     初始化信号量  参数是信号量初始值
     在GCD中提供了一种信号机制，也可以解决资源抢占问题（和同步锁的机制并不一样）。GCD中信号量是dispatch_semaphore_t类型，支持信号通知和信号等待。每当发送一个信号通知，则信号量+1；每当发送一个等待信号时信号量-1,；如果信号量为0则信号会处于等待状态，直到信号量大于0开始执行。根据这个原理我们可以初始化一个信号量变量，默认信号量设置为1，每当有线程进入“加锁代码”之后就调用信号等待命令（此时信号量为0）开始等待，此时其他线程无法进入，执行完后发送信号通知（此时信号量为1），其他线程开始进入执行，如此一来就达到了线程同步目的。
     */
    
    NSString * urlStr;
    NSData *data;
    
    _semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if (self.imageNamesArrayM.count > 0) {
        urlStr = [self.imageNamesArrayM lastObject];
        [self.imageNamesArrayM removeObject:urlStr];
    }
    // 信号通知
    dispatch_semaphore_signal(_semaphore);
    
    
    if (urlStr) {
        NSURL * url = [NSURL URLWithString:urlStr];
        data = [NSData dataWithContentsOfURL:url];
    }
    
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
                        ];
    
    self.imageNamesArrayM = [NSMutableArray arrayWithArray:array];
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"线程同步(NSLock,@synchronized代码块,GCD信号机制";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {
    
    NSInteger total = 15;
    
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

- (NSLock *)lock {
    if (_lock == nil) {
        self.lock = [[NSLock alloc] init];
    } return _lock;
}

@end
