//
//  ViewController.m
//  基本控件
//
//  Created by 雷祥 on 17/2/8.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "ViewController.h"
#import "LabelViewController.h"
#import "ButtonViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.



}


- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"UILabel",@"UIButton",];
    }

    return _dataSource;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell"];
    cell.textLabel.text = _dataSource[indexPath.row];

    return cell;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@",segue.identifier);

}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case 0: //label
//        {
//            LabelViewController *labelVC = [[LabelViewController alloc] init];
//            [self.navigationController pushViewController:labelVC animated:YES];
//
//            break;
//        }
//
//        case 1: //button
//        {
//            ButtonViewController *buttonVC = [[ButtonViewController alloc] init];
//            [self.navigationController pushViewController:buttonVC animated:YES];
//
//            break;
//        }
//
//        default:
//            break;
//    }
//
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
