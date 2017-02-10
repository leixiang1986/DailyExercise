//
//  CopyViewController.m
//  BasicTest
//
//  Created by 雷祥 on 17/2/9.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "CopyViewController.h"

@interface CopyViewController ()



@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationItem setPrompt:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.navigationItem.prompt.length) {
        [self.navigationItem setPrompt:nil];
    }
    else {
        [self.navigationItem setPrompt:@"testCopy"];
    }

    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));

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
