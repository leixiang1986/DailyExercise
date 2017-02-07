//
//  ViewController.m
//  TwoImageViewShowOneImage
//
//  Created by 雷祥 on 17/2/7.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *panView;

@end
//两张imageView显示一个图片
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_panView addGestureRecognizer:pan];

    _topView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);         //显示内容的上面一半
    _topView.layer.anchorPoint = CGPointMake(0.5, 1);               //设置锚点
//    _topView.layer.position = CGPointMake(_topView.frame.size.width , _topView.frame.size.height);
    _bottomView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);    //显示内容的下面一半
    _bottomView.layer.anchorPoint = CGPointMake(0.5, 0);

}


- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:_panView];
    CGFloat angle = (translation.y / self.panView.frame.size.height) * M_PI;
//    CATransform3D transform = CATransform3DMakeRotation(angle, 1, 0, 0);
//    transform.m34 = 1 / 100.0;
    CATransform3D trans = CATransform3DIdentity;
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        if ([NSValue valueWithCATransform3D:self.topView.layer.transform]) {
//
//        }
//        trans = self.topView.layer.transform;
//    }
//    else {
//        trans =
//    }
//    trans = self.topView.layer.transform;

    trans.m34 = -1.0/1000;
    trans = CATransform3DRotate(trans, -angle, 1, 0, 0);
    self.topView.layer.transform = trans;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
