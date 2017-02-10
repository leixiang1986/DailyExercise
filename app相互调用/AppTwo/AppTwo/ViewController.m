//
//  ViewController.m
//  AppTwo
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

- (IBAction)click:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"appOne://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"appOne://"]];
    }
    else{
        NSLog(@"不能打开");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
