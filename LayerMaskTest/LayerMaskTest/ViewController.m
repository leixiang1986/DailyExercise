//
//  ViewController.m
//  LayerMaskTest
//
//  Created by 雷祥 on 17/2/7.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "ViewController.h"
#import "TestMaskView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong) TestMaskView *maskView;   // 封装了layer的mask属性的view
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.maskView];

}


- (IBAction)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.maskView.progress = slider.value;
}

- (TestMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[TestMaskView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.progress = 0;
    }

    return _maskView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
