//
//  CopyViewController.m
//  BasicTest
//
//  Created by 雷祥 on 17/2/9.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "CopyViewController.h"
#import "CopyTestModel.h"

@interface CopyViewController ()



@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    



}



- (void)testString {
    NSString *nameOfCopy = @"nameOfCopy";  //__NSCFConstantString
    NSString *nameOfStrong = @"nameOfStrong";
    //    NSMutableString *nameOfCopy = [NSMutableString stringWithString:@"nameOfCopy"];//__NSCFString
    //    NSMutableString *nameOfStrong = [NSMutableString stringWithString:@"nameOfStrong"];
    CopyTestModel *copyTestModel = [[CopyTestModel alloc] init];
    copyTestModel.nameOfCopy = nameOfCopy;  //内部setter方法如果是直接赋值
    copyTestModel.nameOfStrong = nameOfStrong;
    NSLog(@"\n nameOfCopy:%p\n nameOfStrong:%p\n copyModelNameOfCopy:%p\n copyModelNameOfStrong:%p",nameOfCopy,nameOfStrong,copyTestModel.nameOfCopy,copyTestModel.nameOfStrong);

    [(NSMutableString *)copyTestModel.nameOfCopy insertString:@"021" atIndex:0]; //如果setter方法复写未 _nameOfCopy = nameOfCopy;如果nameOfCopy是可变字符串，那么即使property属性设置了copy结果依然是可变字符串.所以正确的写法是 _nameOfCopy = [nameOfCopy copy];
    NSLog(@"改变后的model.nameOfCopy:%@-----nameOfCopy:%@",copyTestModel.nameOfCopy,nameOfCopy);
}
//testString结论:
/**
 property中的copy如果string是不可变的那么不会copy不同地址的字符串，还是原来的地址；
 如果是可变字符串，用copy则会生成新的字符串，但是如果重写setter方法是用的是_string = string则不会生成新的不可变字符串。
 因此在重写copy属性的属性时，要用_property＝[property copy];
 */


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationItem setPrompt:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.navigationItem.prompt.length) {
        [self.navigationItem setPrompt:nil];
    }
    else {
        [self.navigationItem setPrompt:@"touchesBegan test"];
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
