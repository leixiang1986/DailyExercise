//
//  ViewController.m
//  AppOne
//
//  Created by 雷祥 on 17/2/9.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


/**
    设置白名单appTwo： LSApplicationQueriesSchemes  才能让appTwo回调appOne
 */
- (IBAction)btnClick:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"appTwo://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"appTwo://"]];
    }
    else {
        NSLog(@"不能打开");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
