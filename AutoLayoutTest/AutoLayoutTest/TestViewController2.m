//
//  TestViewController2.m
//  AutoLayoutTest
//
//  Created by 雷祥 on 17/2/7.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "TestViewController2.h"
#import "Test2TableViewCell.h"

@interface TestViewController2 ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger rowCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TestViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    rowCount = 10;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Test2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    cell.indexPath = indexPath;
    cell.cellBlock = ^(BOOL isDelete,NSIndexPath *indexPath){
        if (isDelete) {
            [_tableView beginUpdates];
            rowCount--;
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            [_tableView endUpdates];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });

    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
