//
//  ViewController.m
//  Quazx2DTest
//
//  Created by 雷祥 on 16/12/30.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "ViewController.h"
#import "XibViewForXib.h"
#import "Masonry.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UIImage *image = [UIImage imageNamed:@"测试.png"];
//    image = [self circleImage:image];
//    self.imageView.image = image;
//
//    self.secondImageView.image = [self watermark:image withString:@"水印"];

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(100, 200, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];



}

-(void)btnClick:(id)sender{
    UIImage *image = [self screenShots];
    NSData *data = UIImagePNGRepresentation(image);
    BOOL isOk = [data writeToFile:@"/Users/leixiang/Desktop/screenShots.png" atomically:YES];
    if (isOk) {
        NSLog(@"写入成功");
    }
}

//截屏
- (UIImage *)screenShots {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [window.layer renderInContext:ctx];
    UIImage *screenShotsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenShotsImage;
}


// 水印图片
- (UIImage *)watermark:(UIImage *)image withString:(NSString *)string {
    if (!image) {
        return nil;
    }
    UIGraphicsBeginImageContext(image.size);
//    UIGraphicsBeginImageContextWithOptions(<#CGSize size#>, <#BOOL opaque#>, <#CGFloat scale#>)
    //绘制原图片
    [image drawAtPoint:CGPointMake(0, 0)];
    if (string) {
        // 绘制文字
        if (image.size.width > 80 && image.size.height > 30) {
            [string drawAtPoint:CGPointMake(image.size.width - 80, image.size.height - 30) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]}];
        }

    }

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;

}

// 圆形图片
- (UIImage *)circleImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;

    if (image.size.width < image.size.height) {
        width = image.size.width;
        height = width;
        x = 0;
        y = (image.size.height - height) / 2;
    }
    else {
        width = image.size.height;
        height = width;
        x = (image.size.width - width) / 2;
        y = 0;
    }
    UIGraphicsBeginImageContext(image.size);
    CGRect circleFrame = CGRectMake(x, y, width, height);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
    // 切割路径
    [path addClip];
    //绘制原图
    [image drawAtPoint:CGPointMake(0, 0)];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
