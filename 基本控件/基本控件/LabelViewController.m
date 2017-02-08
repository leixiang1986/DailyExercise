//
//  LabelViewController.m
//  基本控件
//
//  Created by 雷祥 on 17/2/8.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "LabelViewController.h"

@interface LabelViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self test1FontAdjust];
//    [self test2FontAdjustOfLayout];

}


//方法1:测试 label1.adjustsFontSizeToFitWidth = YES;和 [label sizeToFit];用frame固定时的作用，
- (void)test1FontAdjust {
    // 隐藏storyboard中的控件
    self.secondLabel.hidden = YES;
    self.firstLabel.hidden = YES;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 10, 100, 20)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    label.backgroundColor = [UIColor blueColor];
//    label.text = @"这是一个label";
    label.text = @"很多很多很多很多很多啊时代发生的发生发达省份錒时间就阿斯顿肌肤就是叫阿道夫";
    [self.view addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [label sizeToFit];
    label.adjustsFontSizeToFitWidth = YES;


    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 100, 50)];
    label1.backgroundColor = [UIColor blueColor];
    label1.text = @"这是一个label,很多很多很多很多好好好，哈哈哈地方啊师傅";
    label1.numberOfLines = 0;
    [self.view addSubview:label1];
    label1.font = [UIFont systemFontOfSize:14];
    label1.minimumScaleFactor = 0.5;
    //    [label1 sizeToFit];
    label1.adjustsFontSizeToFitWidth = YES;

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(160, 200, 10, 50)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
}
//结论：通过frame设置sizeToFit时，单行高度为文字高度，宽度向后扩充；多行时，宽度最大为设置宽度（设置宽度内的最大文字宽度）高度向下扩充。如果单行字数不够为文字高度宽度；
//  通过frame设置adjustsFontSizeToFitWidth根据内容多少改变字体大小，可设置最小的调整比例





//方法2:测试 label1.adjustsFontSizeToFitWidth = YES;和 [label sizeToFit];用约束固定时的作用，
- (void)test2FontAdjustOfLayout {
    self.secondLabel.adjustsFontSizeToFitWidth = YES;
    [self.secondLabel setMinimumScaleFactor:0.5];

//    [self.secondLabel sizeToFit];

}
//方法2结论：在约束时adjustsFontSizeToFitWidth设置为yes时可以调整字体大小；在约束的权限大于收缩或抗压缩权限时，sizeToFit是没有作用的，sizeToFit可以通过设置priority来实现



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.secondLabel.text = [NSString stringWithFormat:@"%@添加的内容",self.secondLabel.text];
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
