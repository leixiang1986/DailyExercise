//
//  ButtonViewController.m
//  基本控件
//
//  Created by 雷祥 on 17/2/8.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "ButtonViewController.h"
#import "UIButton+ImageAndTitleDisplay.h"

@interface ButtonViewController ()

@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self test1AdjustFont];
//    [self test2NormalAttribute:YES]; //根据是否是正常宽度，测试文字因宽度不够而压缩
//    [self test3TitleAndImageInsets];
    [self test4Categary];

}

//测试1:文字在显示不完时，自动调整大小
- (void)test1AdjustFont{
    UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn1.frame = CGRectMake(130, 80, 60, 30);
    [btn1 setTitle:@"这是一个but" forState:(UIControlStateNormal)];
    btn1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn2.frame = CGRectMake(50, 80, 60, 30);
    btn2.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn2.titleLabel.minimumScaleFactor = 0.3;
    [btn2 setTitle:@"这是一个but" forState:(UIControlStateNormal)];
    btn2.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    btn2.backgroundColor = [UIColor blueColor];
    btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5); //只有title时可以这样设置
    [self.view addSubview:btn2];
}
//结论：可以根据文字的多少调整自动调整文字的大小，可以设置UIBaselineAdjustmentAlignCenters，让其上下居中

//测试2:常用属性
- (void)test2NormalAttribute:(BOOL)normalWidth{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];

    CGFloat width = 45;
    if (normalWidth) {
        width = 80;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 15); //内容整体内嵌
    }

    btn.frame = CGRectMake(50, 250, width, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn setShowsTouchWhenHighlighted:YES]; //点击发亮,以图片为中心发亮
    btn.adjustsImageWhenHighlighted = NO;   //不显示深的颜色
    btn.titleLabel.adjustsFontSizeToFitWidth = YES; //文字可调整
    btn.titleLabel.minimumScaleFactor = 0.2;
    btn.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters; // 文字的大小调整后，上下剧中显示
    [btn setImage:[UIImage imageNamed:@"arrow_down_black"] forState:(UIControlStateNormal)];
    [btn setTitle:@"标题" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
}

//测试3:同时有标题和图片
- (void)test3TitleAndImageInsets{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(50, 200, 80, 35);
    [btn setImage:[UIImage imageNamed:@"arrow_down_black"] forState:(UIControlStateNormal)];
    [btn setTitle:@"标题" forState:(UIControlStateNormal)];
    btn.imageView.backgroundColor = [UIColor blueColor];
    btn.titleLabel.backgroundColor = [UIColor greenColor];
    btn.backgroundColor = [UIColor redColor];
    NSLog(@"image:%@===label:%@",btn.imageView,btn.titleLabel);
    [self.view addSubview:btn];

//    CGFloat titleImageWidth = btn.titleLabel.frame.size.width + btn.imageView.frame.size.width;
//    CGFloat titleImageHeight = MAX(btn.titleLabel.frame.size.height, btn.imageView.frame.size.height);
    CGFloat space = 4;
    //相对于原来的imageView位置进行移动
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width + space/2, 0, -btn.titleLabel.frame.size.width - space/2); // imageView向右整体移动titleLabel的宽度+space/2
    //相对于原来的titleLabel位置进行移动
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width - space/2, 0, btn.imageView.frame.size.width + space/2);   // titleLable向左整体移动imageView的宽度+space/2
//    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];整体向右移动10

}

//测试4:通过分类来设置按钮的样式,是图片在左,右,上,下等情况
- (void)test4Categary {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(50, 200, 80, 50);
    [btn setDisplayType:(OKButtonImageAndTitleDisplayTypeImageLeft) withSpace:5];
    [btn setImage:[UIImage imageNamed:@"arrow_down_black"] forState:(UIControlStateNormal)];
    [btn setTitle:@"标题" forState:(UIControlStateNormal)];
    btn.imageView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    btn.titleLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
    btn.backgroundColor = [UIColor redColor];
    NSLog(@"image:%@===label:%@",btn.imageView,btn.titleLabel);
    [self.view addSubview:btn];

//    btn.displayType = OKButtonImageAndTitleDisplayTypeImageDown;
//    btn.displayType = OKButtonImageAndTitleDisplayTypeImageRight;
//    btn.spacing = 10;

    UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    btn1.displayType = OKButtonImageAndTitleDisplayTypeImageRight;
    [self.view addSubview:btn1];
    btn1.frame = CGRectMake(50, 300, 80, 50);


}
//结论：每次都是相对于原始位置的挪动，即都是相对图片在左边，文字在右边，间距为0的移动。哪怕是设置了图片在上边，再移动时也是相对原始状态的改变。


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
