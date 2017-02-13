//
//  ViewController.m
//  BasicTest
//
//  Created by 雷祥 on 17/2/9.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "ViewController.h"
#import "PredicateViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [self setEdgesForExtendedLayout:(UIRectEdgeNone)];


}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


//    [self.tableView layoutIfNeeded];
//    [self.tableView setNeedsLayout];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"tableView:%@===%@\n===\n view:%@",NSStringFromCGRect(self.tableView.frame),NSStringFromCGRect(self.tableView.bounds),NSStringFromCGRect(self.view.frame));
}



- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"copy",@"predicate"];
    }
    return _titles;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell"];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        PredicateViewController *vc = [[PredicateViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
