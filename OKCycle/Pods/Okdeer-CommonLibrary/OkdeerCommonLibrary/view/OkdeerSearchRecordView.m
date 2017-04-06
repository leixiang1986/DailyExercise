//
//  OkdeerSearchRecordView.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OkdeerSearchRecordView.h"
#import "OkdeerCommonLibrary.h"
#import "UIViewController+Okdeer.h"
#import "NSString+OKExtension.h"
@interface OkdeerSearchRecordView ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIView *recordBkv;    /**< 背景页 */
@property (nonatomic, strong) UIScrollView *titleViewBk;
@property (nonatomic, strong) UIView *delviewBk;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIAlertView *alertview;
@property (nonatomic, strong) UIAlertController *alterController;       /**< 提示 */
@property (nonatomic, strong) UIView *imageview;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *seplineV;

@end

@implementation OkdeerSearchRecordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景页
        _recordBkv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, kFullScreenHeight - 64)];
        _recordBkv.backgroundColor = UIColorFromHex(0xF5F6F8);
        [self addSubview:_recordBkv];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [self addGestureRecognizer:recognizer];
        
        UIView *tipsBkv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, 44)];
        tipsBkv.backgroundColor = [UIColor whiteColor];
        [_recordBkv addSubview:tipsBkv];
        //seachimage
        _imageview = [[UIView alloc] initWithFrame:CGRectMake(20, 14, 17, 15)];
        UIImage *image = [self imagefrombundle:@"shareImageBundle" inDirectory:@"Image" fileName:@"search@2x"];
        _imageview.backgroundColor = [UIColor colorWithPatternImage:image];
        [tipsBkv addSubview:_imageview];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 100, 20)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = UIColorFromHex(0x8CC63F);
        _label.text = @"最近搜索";
        _label.font = FONTDEFAULT(16);
        [tipsBkv addSubview:_label];
        
        _seplineV = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 1, kFullScreenWidth, 1)];
        _seplineV.backgroundColor = UIColorFromHex(COLOR_E2E2E2);
        [self addSubview:_seplineV];
        
        _titleViewBk = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44.f, kFullScreenWidth, 0.f)];
        _titleViewBk.backgroundColor = UIColorFromHex(0xFFFFFF);
        _titleViewBk.contentSize = CGSizeMake(kFullScreenWidth, 0);
        [_recordBkv addSubview:_titleViewBk];
        
        _delviewBk = [[UIView alloc] initWithFrame:CGRectMake(-1.f, self.frame.size.height - 77.f, kFullScreenWidth+2.f, 77.f)];
        _delviewBk.backgroundColor = UIColorFromHex(0xFFFFFF);
        _delviewBk.layer.borderColor = UIColorFromHex(COLOR_E2E2E2).CGColor;
        _delviewBk.layer.borderWidth = 1;
        [_recordBkv addSubview:_delviewBk];
        
        _delBtn = [[UIButton alloc] initWithFrame:CGRectMake((kFullScreenWidth - 190)/2, 22.f, 190.f, 33.f)];
        [_delBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [_delBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        _delBtn.titleLabel.font = FONTDEFAULT(16);
        [_delBtn addTarget:self action:@selector(delAllsource:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.layer.borderWidth = 0.5f;
        _delBtn.layer.cornerRadius = 3.f;
        _delBtn.layer.masksToBounds = YES;
        _delBtn.layer.borderColor = UIColorFromHex(COLOR_E2E2E2).CGColor;
        [_delviewBk addSubview:_delBtn];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
            _alterController = [UIAlertController alertControllerWithTitle:nil message:@"确认清除历史记录?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [_alterController addAction:cancelAction];
            
            WEAKSELF(weakSelf);
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                STRONGSELF(strongSelf);
                if (strongSelf) {
                    if (strongSelf.didClickDelAllSource) {
                        strongSelf.didClickDelAllSource();
                    }
                }
            }];
            [_alterController addAction:okAction];
        }
        else {
            _alertview = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确认清除历史记录?"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
        }
    }
    return self;
}

//获取到图片
- (UIImage *)imagefrombundle:(NSString *)bundleName inDirectory:(NSString *)inDirectory fileName:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]];
    //没有找到bundle
    if (!bundle) {
        if (imageName.length) {
            return [UIImage imageNamed:imageName];
        }
        return nil;
    }
    
    NSString *imagePath = [bundle pathForResource:imageName ofType:@"png" inDirectory:inDirectory];
    //图片路径是nil
    if (!imagePath.length) {
        if (imageName.length) {
            return [UIImage imageNamed:imageName];
        }
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imagePath];
    return image;
}


-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self updateTagview];
}

#pragma mark --Private Method
-(void)updateTagview
{
    // 设置左边间隔
    CGFloat originX = 15;
    // 设置上边初始间隔
    CGFloat originY = 12;
    // 设置水平间隔
    CGFloat padding_h = 13;
    // 设置垂直间隔
    CGFloat padding_v = 13;
    // 设置单个标签的最大宽度
    CGFloat maxWidth = CGRectGetWidth(_titleViewBk.frame) - originX*2;
    
    for (UIView *v in [_titleViewBk subviews]) {
        [v removeFromSuperview];
    }
    
    for (int i=0; i<_titleArray.count; i++) {
        NSString *title = _titleArray[i];
        CGSize tempSize = [title calculateheight:FONTDEFAULT(16)
                                              andcontSize:CGSizeMake(maxWidth-5*2, MAXFLOAT)
                           ];
        UIButton *btn = [UIButton buttonWithType:0];
        
        // 文字上下间隔边框5,左右距离标签边框8.
        btn.frame = CGRectMake(originX, originY, tempSize.width+8, 28);
        btn.titleLabel.font = FONTDEFAULT(12);
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.numberOfLines = 0;
        [btn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = UIColorFromHex(COLOR_E2E2E2).CGColor;
        btn.layer.borderWidth = 0.5f;
        btn.layer.cornerRadius = 3.f;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [_titleViewBk addSubview:btn];
        
        originX = CGRectGetMaxX(btn.frame)+ padding_h;
        
        if (i < _titleArray.count-1) {
            tempSize = [_titleArray[i+1] calculateheight:FONTDEFAULT(16)
                                             andcontSize:CGSizeMake(maxWidth-5*2, MAXFLOAT)];
            // 如果换行,改变Y
            if (originX + (tempSize.width + 9*2) > (maxWidth+15)) {
                originX = 15;
                originY = CGRectGetMaxY(btn.frame) + padding_v;
            }
        }
        else {
            originY = CGRectGetMaxY(btn.frame) + padding_v;
        }
    }
    //
    if ([_titleArray count] > 0) {
        _titleViewBk.frame = CGRectMake(0, 44.f, kFullScreenWidth, originY);
    }
    else {
        _titleViewBk.frame = CGRectMake(0, 44.f, kFullScreenWidth, 0);
    }
    
    if (originY > (self.frame.size.height - 44.f)) {
        _titleViewBk.contentSize = CGSizeMake(kFullScreenWidth, originY);
    }
}

#pragma mark - *** btnClicked ***
-(void)btnclicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *title = btn.titleLabel.text;
    if (self.didClickTagAtString) {
        self.didClickTagAtString(title);
    }
}

//手指点击
-(void)tapClicked:(UITapGestureRecognizer *)recognizer
{
    if (self.didTaprecoginizer) {
        self.didTaprecoginizer();
    }
}

/* 清除历史记录 */
-(void)delAllsource:(id)sender
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        UIViewController *vc = [UIViewController ok_obtainTopViewController];
        [vc presentViewController:_alterController animated:YES completion:nil];
    }
    else {
        [_alertview show];
    }
}

#pragma mark === uialertview ===
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.didClickDelAllSource) {
            self.didClickDelAllSource();
        }
    }
}

@end
