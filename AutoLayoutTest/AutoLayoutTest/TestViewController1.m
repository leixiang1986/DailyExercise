//
//  TestViewController1.m
//  AutoLayoutTest
//
//  Created by 雷祥 on 17/2/7.
//  Copyright © 2017年 leixiang. All rights reserved.
//
//http://www.jianshu.com/p/3e71eb7c873c
#import "TestViewController1.h"

@interface TestViewController1 ()

@end

@implementation TestViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //重复约束等高等宽，但两次约束的条件不同，一次是子视图小于等于父视图，第二次是约束的等级小于第一次。
    //4:1的比例可以保证子视图比例，第二次的重复约束可以保证宽的一侧与父视图相等，第一次约束可以保证窄的一侧小于父视图。

}

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

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
