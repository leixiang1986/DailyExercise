//
//  ViewController.m
//  NSInvocationAndNSMethodSignature
//
//  Created by 雷祥 on 2017/3/7.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ViewController.h"
#import "TestPerson.h"

//参考地址
//https://my.oschina.net/u/2340880/blog/398552
//http://www.cocoachina.com/bbs/read.php?tid=75614&keyword=NSInvocation

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


    id age = [person valueForKey:@"age"];
    if ([age isKindOfClass:[NSNumber class]]) {
        return
    }


    NSInteger ageInt = [age integerValue];
    [person setValue:nil forKey:@"name"];
    [person setValue:[NSNumber numberWithInteger:10] forKey:@"age"];
    age = [person valueForKey:@"age"];
    NSString *name = [person valueForKey:@"name"];
    ageInt = [age integerValue];
    [person setValue:@"error" forKey:@"error"];
    NSString *error = [person valueForKey:@"error"];

    NSLog(@"name:%@===nameStr",name);

    [_person addTarget:self action:@selector(test11)];

    SEL myMethod = @selector(myLog:parm:parm:);
    NSMethodSignature * sig  = [[self class] instanceMethodSignatureForSelector:myMethod];
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    [invocatin setTarget:self];
    [invocatin setSelector:myMethod];
    ViewController * view = self;
    int a=1;
    int b=2;
    int c=3;
    [invocatin setArgument:&view atIndex:0];
    [invocatin setArgument:&myMethod atIndex:1];
    [invocatin setArgument:&a atIndex:2];
    [invocatin setArgument:&b atIndex:3];
    [invocatin setArgument:&c atIndex:4];
    [invocatin retainArguments];
//    //我们将c的值设置为返回值
//    [invocatin setReturnValue:&c];
//    int d;
//    //取这个返回值
//    [invocatin getReturnValue:&d];
//    NSLog(@"dddd=%d",d);

    //调用
    [invocatin invoke];
    //参考地址
    //https://my.oschina.net/u/2340880/blog/398552
    //http://www.cocoachina.com/bbs/read.php?tid=75614&keyword=NSInvocation
}

-(int)myLog:(int)a parm:(int)b parm:(int)c{
    NSLog(@"MyLog%d:%d:%d",a,b,c);
    int result = a+b+c;
    NSLog(@"result:%d",result);
    return result;
}

-(void)myLog {
    NSLog(@"MyLog");
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
