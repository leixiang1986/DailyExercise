//
//  TestMaskView.m
//  GSD_WeiXin(wechat)
//
//  Created by 雷祥 on 17/2/6.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "TestMaskView.h"



@interface TestMaskView()
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation TestMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self setupAnimationWithProgress:0];
    }

    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.backgroundColor = [UIColor blueColor];
        _imageView.image = [UIImage imageNamed:@"test0.jpg"];
    }

    return _imageView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    _imageView.frame = frame;
}

- (void)setupAnimationWithProgress:(CGFloat)progress {
    CGFloat scale = MIN(progress, 1);
    CGFloat w = self.frame.size.width * scale * 0.8;
    CGFloat h = 50;
    if (w < h) {
        h = w;
    }

    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.frame.size.width - w) / 2, (self.frame.size.height - h) / 2, w, h)].CGPath;

    self.imageView.layer.mask = mask;
    self.imageView.alpha = scale;
}


- (void)setProgress:(CGFloat)progress {
    _progress = progress;

    [self setupAnimationWithProgress:progress];
}

@end
