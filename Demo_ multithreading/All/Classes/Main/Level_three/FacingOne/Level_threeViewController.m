//
//  Level_threeViewController.m
//  Demo_Date
//
//  Created by goulela on 16/12/13.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "Level_threeViewController.h"

#import "Masonry.h"

#import "Level_three_itemOneViewController.h"
#import "Level_three_itemTwoViewController.h"
#import "Level_three_itemThreeViewController.h"
#import "Level_three_itemFourViewController.h"
#import "Level_three_itemFiveViewController.h"
#import "Level_three_itemSixViewController.h"
#import "Level_three_itemSevenViewController.h"
#import "Level_three_itemEightViewController.h"

@interface Level_threeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayM;

@end

@implementation Level_threeViewController

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
        Level_three_itemOneViewController * one = [[Level_three_itemOneViewController alloc] init];
        [self.navigationController pushViewController:one animated:YES];
    } else if (indexPath.row == 1) {
        Level_three_itemTwoViewController * two = [[Level_three_itemTwoViewController alloc] init];
        [self.navigationController pushViewController:two animated:YES];
    } else if (indexPath.row == 2) {
        Level_three_itemThreeViewController * three = [[Level_three_itemThreeViewController alloc] init];
        [self.navigationController pushViewController:three animated:YES];
    } else if (indexPath.row == 3) {
        Level_three_itemFourViewController * four = [[Level_three_itemFourViewController alloc] init];
        [self.navigationController pushViewController:four animated:YES];
    } else if (indexPath.row == 4) {
        Level_three_itemFiveViewController * five = [[Level_three_itemFiveViewController alloc] init];
        [self.navigationController pushViewController:five animated:YES];
    } else if (indexPath.row == 5) {
        Level_three_itemSixViewController * six = [[Level_three_itemSixViewController alloc] init];
        [self.navigationController pushViewController:six animated:YES];
    } else if (indexPath.row == 6) {
        Level_three_itemSevenViewController * seven = [[Level_three_itemSevenViewController alloc] init];
        [self.navigationController pushViewController:seven animated:YES];
    } else if (indexPath.row == 7) {
        Level_three_itemEightViewController * eight = [[Level_three_itemEightViewController alloc] init];
        [self.navigationController pushViewController:eight animated:YES];
    }
}

#pragma mark - 点击事件

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"3";
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

