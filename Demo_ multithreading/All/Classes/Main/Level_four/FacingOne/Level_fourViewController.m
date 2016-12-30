//
//  Level_fourViewController.m
//  Demo_Date
//
//  Created by goulela on 16/12/13.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_fourViewController.h"

#import "Masonry.h"

#import "Level_four_itemOneViewController.h"
#import "Level_four_itemTwoViewController.h"
#import "Level_four_itemThreeViewController.h"
#import "Level_four_itemFourViewController.h"
#import "Level_four_itemFiveViewController.h"
#import "Level_four_itemSixViewController.h"
#import "Level_four_itemSevenViewController.h"
#import "Level_four_itemEightViewController.h"


@interface Level_fourViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayM;

@end

@implementation Level_fourViewController

// 不调用
- (void)record {
    
    //1... 异步,全局变量
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    
    /** dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     
     1.系统给每一个应用程序提供了三个concurrent dispatch queues。这三个并发调度队列是全局的，它们只有优先级的不同。因为是全局的，我们不需要去创建。我们只需要通过使用函数dispath_get_global_queue去得到队列
     */
    
    
    
    
    //2... 异步,主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    /** dispatch_queue_t mainQ = dispatch_get_main_queue();
     
     这里也用到了系统默认就有一个串行队列main_queue
     */
    
    /**
     虽然dispatch queue是引用计数的对象，但是以上两个都是全局的队列，不用retain或release。
     */
    
    
    /**3... dispatch_queue_t
     是什么? 
     */
    
    
    /** dispatch_queue_t queue = dispatch_queue_create(const char * _Nullable label, dispatch_queue_attr_t  _Nullable attr);
     
     如何创建一个自己的队列, 串行队列? 并行队列? 
     参数1:用于标志 dispatch_queue 的字符串,例如:"custom",注意不要用@"".
     参数2:保留的dispatch_queue 的保留属性,设置为NULL就可以了.
     
     
     问题: 自定义的线程,跟主线程什么关系? 为什么会用了dispatch_barrier_async 会影响页面push
     */
    
    
    /**4.     dispatch_barrier_sync(queue, ^{ });
     
     barrier 障碍物
     
     dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行
     */
    
    
    /** 5    dispatch_apply(<#size_t iterations#>, <#dispatch_queue_t  _Nonnull queue#>, <#^(size_t)block#>)

     参数1: 执行的次数
     参数2: 在那个队列中执行
     */
  
}

#pragma mark - 生命周期
#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self basicSetting];
    
    [self addTableView];
    
    [self createData];
}


#pragma mark - 系统代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idetifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
    }
    
    cell.textLabel.text = self.dataArrayM[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Level_four_itemOneViewController * one = [[Level_four_itemOneViewController alloc] init];
        [self.navigationController pushViewController:one animated:YES];
    } else if (indexPath.row == 1) {
        Level_four_itemTwoViewController * two = [[Level_four_itemTwoViewController alloc] init];
        [self.navigationController pushViewController:two animated:YES];
    } else if (indexPath.row == 2) {
        Level_four_itemThreeViewController * three = [[Level_four_itemThreeViewController alloc] init];
        [self.navigationController pushViewController:three animated:YES];
    } else if (indexPath.row == 3) {
        Level_four_itemFourViewController * four = [[Level_four_itemFourViewController alloc] init];
        [self.navigationController pushViewController:four animated:YES];
    } else if (indexPath.row == 4) {
        Level_four_itemFiveViewController * five = [[Level_four_itemFiveViewController alloc] init];
        [self.navigationController pushViewController:five animated:YES];
    } else if (indexPath.row == 5) {
        Level_four_itemSixViewController * six = [[Level_four_itemSixViewController alloc] init];
        [self.navigationController pushViewController:six animated:YES];
    } else if (indexPath.row == 6) {
        Level_four_itemSevenViewController * seven = [[Level_four_itemSevenViewController alloc] init];
        [self.navigationController pushViewController:seven animated:YES];
    } else if (indexPath.row == 7) {
        Level_four_itemEightViewController * eight = [[Level_four_itemEightViewController alloc] init];
        [self.navigationController pushViewController:eight animated:YES];
    }
}

#pragma mark - 点击事件

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"GCD";
    
}

- (void)addTableView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)createData
{
    NSArray * array = @[@"dispatch_async",@"dispatch_group_async",@"dispatch_barrier_async",@"dispatch_apply",@"串行队列",@"并行队列",@"线程同步(NSLock,@synchronized代码块,GCD信号机制)",@"GCD-控制线程通信"];
    
    self.dataArrayM = [NSMutableArray arrayWithArray:array];
    
    [self.tableView reloadData];
}

#pragma mark - setter & getter

- (UITableView *)tableView
{
    if (!_tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArrayM
{
    if (!_dataArrayM)
    {
        self.dataArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArrayM;
}

@end
