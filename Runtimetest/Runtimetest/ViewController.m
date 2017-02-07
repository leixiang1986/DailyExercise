//
//  ViewController.m
//  Runtimetest
//
//  Created by 雷祥 on 17/1/3.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "ViewController.h"
#import "TestInitWithFrameView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1，测试同一个类的两个分类，增加方法交换(是可以的)


    NSMutableArray *test = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++) {
        [test addObject:[NSNumber numberWithInteger:i]];
    }
    [test objectAtIndex:11];
    [test insertObject:@"11" atIndex:12];

//
//    [TestInitWithFrameView initWithFrame:]
//    [TestInitWithFrameView init]
    //复写时：调用init方法先调用initWithFrame再调用init方法
    TestInitWithFrameView *view = [[TestInitWithFrameView alloc] init];

    
    //    [TestInitWithFrameView initWithFrame:]
    //复写时：调用initWithFrame方法初始化，只会调用initWithFrame方法
    TestInitWithFrameView *view1 = [[TestInitWithFrameView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
