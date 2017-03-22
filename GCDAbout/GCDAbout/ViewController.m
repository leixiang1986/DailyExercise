//
//  ViewController.m
//  GCDAbout
//
//  Created by 雷祥 on 2017/3/10.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "TestViewController1.h"



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
}

- (NSArray *)list {
    if (!_list) {
        _list = @[@"自旋锁--同一个类的多个实例创建单一实例",@"同步异步-串行并发"];
    }

    return _list;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 56;
    }

    return _tableView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }

    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.list[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: //自旋锁，全局弱引用
            [self method0];
            break;
        case 1: //同步异步，串行并发
            [self method1];
            break;
        case 2:

            break;

        default:
            break;
    }
}

/**
 * 自旋锁，全局弱引用
 */
- (void)method0 {
    TestViewController *vc = [[TestViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 同步异步
 */
- (void)method1 {
    TestViewController1 *vc = [[TestViewController1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
