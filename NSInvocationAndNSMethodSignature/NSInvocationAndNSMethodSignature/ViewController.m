//
//  ViewController.m
//  NSInvocationAndNSMethodSignature
//
//  Created by 雷祥 on 2017/3/7.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ViewController.h"
#import "TestPerson.h"

@interface ViewController ()
@property (nonatomic,strong) TestPerson *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    TestPerson *person = [[TestPerson alloc] init];
    person.name = @"nidemingzi";
    person.age = 38;
    person->ID = @"16546546464";
    _person = person;

    NSString *name = [person valueForKey:@"name"];
    NSLog(@"name:%@===nameStr",name);

    [_person addTarget:self action:@selector(test11)];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_person action];
}

- (void)test11 {
    NSLog(@"控制器的测试自定义事件");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
