//
//  PredicateViewController.m
//  BasicTest
//
//  Created by 雷祥 on 17/2/10.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "PredicateViewController.h"

@interface PredicateViewController ()

@end

@implementation PredicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}

//从数组中过滤出一定条件的元素
- (void)test1ArrayFilter {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@",[UIButton class]];
    NSArray *buttons = [self.view.subviews filteredArrayUsingPredicate:predicate];
    for (UIButton *button in buttons){
//        [button setBackgroundImageStretchableForState:UIControlStateNormal];
    }
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
