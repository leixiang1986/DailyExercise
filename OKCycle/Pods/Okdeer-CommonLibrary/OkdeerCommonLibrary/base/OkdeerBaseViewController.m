//
//  OkdeerBaseViewController.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OkdeerBaseViewController.h"
#import "OkdeerCommonLibrary.h"
#import "OkdeerAnimation.h"

#define kAlterFieldTag 10000
#define kAlterViewTag 10001
#define kAlterLoginTag 10002

@interface OkdeerBaseViewController ()<UIGestureRecognizerDelegate, UIAlertViewDelegate,UINavigationControllerDelegate>{
    void (^_returnBlock)(NSString *button);
}

@end

@implementation OkdeerBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = UIColorFromHex(0xf5f6f8);
    [self addNotification];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 管理子类请求对象

/**
 * 子类请求对象数组
 */
- (NSMutableArray<NSURLSessionDataTask *> *)sessionDataTaskArr
{
    if (!_sessionDataTaskArr) {
        NSMutableArray *sessionDataTaskArr = [NSMutableArray array];
        self.sessionDataTaskArr = sessionDataTaskArr;
    }
    return _sessionDataTaskArr;
}

/**
 * 父类释放时取消子类所有请求操作
 */
- (void)cancelRequestSessionTask
{
    if (_sessionDataTaskArr.count==0) return;
    
    for (NSURLSessionDataTask *sessionTask in self.sessionDataTaskArr) {
        if ([sessionTask isKindOfClass:[NSURLSessionDataTask class]]) {
            [sessionTask cancel];
        }
    }
    //清除所有请求对象
    [self.sessionDataTaskArr removeAllObjects];
}

#pragma mark - //****************** 通知 ******************//
/**
 *  添加通知
 */
- (void)addNotification{
    // 监听textFieldText 输入的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    // 监听 textViewText 输入的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    // 监听状态栏状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ipChangeNotification) name:@"AllIpChangeNotification" object:nil];
}

/**
 *  textfield内容发生改变，有表情禁止输入
 *
 *  @param notify
 */
-(void)textFieldTextDidChange:(NSNotification *)notify{
    if ([notify.object isKindOfClass:[UITextField class]]) {
        UITextField *textField = notify.object;
        NSString *noEmoji = [self disable_emoji:textField.text] ;
        if (![noEmoji isEqualToString:textField.text]) {
            [self alterViewShow];
            textField.text = noEmoji ;
        }
    }
}
/**
 *  textview内容发生改变，有表情禁止输入
 *
 *  @param notify
 */
- (void)textViewTextDidChange:(NSNotification *)notify {
    if ([notify.object isKindOfClass:[UITextView class]]) {
        UITextView *textView = notify.object;
        NSString *noEmoji = [self disable_emoji:textView.text] ;
        if (![noEmoji isEqualToString:textView.text]) {
            [self alterViewShow];
            textView.text = noEmoji;
        }
    }
}
/**
 *  监听状态栏变化
 */
- (void)handleUIApplicationWillChangeStatusBarFrameNotification:(NSNotification *)notification
{
    [self changeAppFrame];
}
/**
 * IP改变的通知
 */
- (void)ipChangeNotification {
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated] ;
    
    self.willDisappear = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //PopGestureRecognizerenabled(YES);     // 为no 不能滑动  yes  可以滑动
    self.navigationController.interactivePopGestureRecognizer.delegate = self;    /**< 设置 导航栏 是否返回上一个页面的 代理方法 */
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated] ;
    self.willDisappear = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

/**
 *  手势将要开始的代理方法
 *
 *  @param gestureRecognizer 手势
 *
 *  @return 是否允许
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        if (self.gestureShouldPopBlock) {
            self.gestureShouldPopBlock();
        }
        return YES;
    }
}


/**
 *  子类复写,如果需要返回到根视图，则需重写子类，root 为YES
 *
 *  @param sender  sender
 */
-(void)backBtnClick:(id)sender{
    [[OkdeerAnimation instanceAnimation] stopAnimationWithDuration:0 completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

/**< 更新数据 */
- (void)upDateData
{

}

/**
 *  执行跳转  具体操作由子类进行操作
 *
 *  @param currentVC 当前的控制器
 *  @param objc  控制器需要的参数
 */
+ (void)controllerPush:(UIViewController *)currentVC objc:(id )objc{
    
}

/**
 *  改变相应的高度
 */
- (void)changeAppFrame{
    
}

- (BOOL)shouldAutorotate{
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - /*** 其他Method ***/
- (void)alterViewShow
{
    // --- AlterView 展示
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能包含表情" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [alter dismissViewControllerAnimated:YES completion:nil];
            });
        });
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"不能包含表情"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
            });
        });
    }
}

/**
 *  替换掉表情
 *
 *  @param text 输入的文字
 *
 *  @return 替换掉后的文字
 */
- (NSString *)disable_emoji:(NSString *)text{
    
    __block NSString *noEmoji = text;
    __block BOOL isEmoji = NO ;
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                     isEmoji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             }else if (ls >= 0xfe0f){
                 isEmoji = YES;
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""] ;
             }
             
         } else {
             // non surrogate
             
             if (hs >= 0x2500 && hs<= 0x254b) {
                 
             }else if (0x2100 <= hs && hs <= 0x27ff && hs != 0x22ef && hs != 0x263b) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a ) {
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 isEmoji = YES;
             }
         }
     }];
    text = noEmoji;
    return text;
}


- (void)dealloc
{
    //取消子类所有请求操作
    [self cancelRequestSessionTask];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

@end
