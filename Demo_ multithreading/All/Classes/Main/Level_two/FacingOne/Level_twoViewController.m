//
//  Level_twoViewController.m
//  Demo_Date
//
//  Created by goulela on 16/12/13.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_twoViewController.h"

#import "Masonry.h"

#import "Level_two_itemOneViewController.h"
#import "Level_two_itemTwoViewController.h"
#import "Level_two_itemThreeViewController.h"
#import "Level_two_itemFourViewController.h"
#import "Level_two_itemFiveViewController.h"
#import "Level_two_itemSixViewController.h"
#import "Level_two_itemSevenViewController.h"
#import "Level_two_itemEightViewController.h"

@interface Level_twoViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayM;

@end

@implementation Level_twoViewController


- (void)record {

    /**
     [NSThread sleepForTimeInterval:2];
     */
    
    [NSThread sleepUntilDate:[NSDate date]];
    
    [NSThread currentThread];
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
        Level_two_itemOneViewController * one = [[Level_two_itemOneViewController alloc] init];
        [self.navigationController pushViewController:one animated:YES];
    } else if (indexPath.row == 1) {
        Level_two_itemTwoViewController * two = [[Level_two_itemTwoViewController alloc] init];
        [self.navigationController pushViewController:two animated:YES];
    } else if (indexPath.row == 2) {
        Level_two_itemThreeViewController * three = [[Level_two_itemThreeViewController alloc] init];
        [self.navigationController pushViewController:three animated:YES];
    } else if (indexPath.row == 3) {
        Level_two_itemFourViewController * four = [[Level_two_itemFourViewController alloc] init];
        [self.navigationController pushViewController:four animated:YES];
    } else if (indexPath.row == 4) {
        Level_two_itemFiveViewController * five = [[Level_two_itemFiveViewController alloc] init];
        [self.navigationController pushViewController:five animated:YES];
    } else if (indexPath.row == 5) {
        Level_two_itemSixViewController * six = [[Level_two_itemSixViewController alloc] init];
        [self.navigationController pushViewController:six animated:YES];
    } else if (indexPath.row == 6) {
        Level_two_itemSevenViewController * seven = [[Level_two_itemSevenViewController alloc] init];
        [self.navigationController pushViewController:seven animated:YES];
    } else if (indexPath.row == 7) {
        Level_two_itemEightViewController * eight = [[Level_two_itemEightViewController alloc] init];
        [self.navigationController pushViewController:eight animated:YES];
    }
}

#pragma mark - 点击事件

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"2";
    
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
    NSArray * array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    
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
