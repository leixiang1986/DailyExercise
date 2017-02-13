//
//  CCAlertView.m
//  Okdeer-jieshun-parkinglot
//
//  Created by mao wangxin on 2016/11/15.
//  Copyright © 2016年 okdeer. All rights reserved.
//

#import "CCAlertView.h"
#import <objc/runtime.h>

//获取系统版本
#define KsystemVersion              [[[UIDevice currentDevice] systemVersion] floatValue]

static NSString *UIAlertViewKey = @"UIAlertViewKey";

@implementation UIAlertView (Block)

/**
 
 下面是 <stdarg.h> 里面重要的几个宏定义如下：
 typedef char* va_list;
 void va_start ( va_list ap, prev_param ); // ANSI version
 type va_arg ( va_list ap, type );
 void va_end ( va_list ap );
 va_list 是一个字符指针，可以理解为指向当前参数的一个指针，取参必须通过这个指针进行。
 <Step 1> 在调用参数表之前，定义一个 va_list 类型的变量，(假设va_list 类型变量被定义为ap)；
 <Step 2> 然后应该对ap 进行初始化，让它指向可变参数表里面的第一个参数，这是通过 va_start 来实现的，第一个参数是 ap 本身，第二个参数是在变参表前面紧挨着的一个变量,即“...”之前的那个参数；
 <Step 3> 然后是获取参数，调用va_arg，它的第一个参数是ap，第二个参数是要获取的参数的指定类型，然后返回这个指定类型的值，并且把 ap 的位置指向变参表的下一个变量位置；
 <Step 4> 获取所有的参数之后，我们有必要将这个 ap 指针关掉，以免发生危险，方法是调用 va_end，他是输入的参数 ap 置为 NULL，应该养成获取完参数表之后关闭指针的习惯。说白了，就是让我们的程序具有健壮性。通常va_start和va_end是成对出现。
 
 */

+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonName otherButtonTitles: otherButtonTitles, nil];
    NSString *other = nil;
    va_list args;
    if (otherButtonTitles) {
        va_start(args, otherButtonTitles);
        while ((other = va_arg(args, NSString*))) {
            [alert addButtonWithTitle:other];
        }
        va_end(args);
    }
    alert.delegate = alert;
    [[[UIApplication sharedApplication] keyWindow] addSubview:alert];
    [alert show];
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
}


- (void)setAlertViewCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    [self willChangeValueForKey:@"callbackBlock"];
    objc_setAssociatedObject(self, &UIAlertViewKey, alertViewCallBackBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"callbackBlock"];
}

- (UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    return objc_getAssociatedObject(self, &UIAlertViewKey);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.alertViewCallBackBlock) {
        self.alertViewCallBackBlock(buttonIndex);
    }
}
@end


static char const * const kButtonBlockKey       = "kButtonBlockKey";
static char const * const kCancelBlockKey       = "kCancelBlockKey";

@interface CCAlertView ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIView   *contentView;
@property (nonatomic, copy) void(^buttonBlock)(NSInteger buttonIndex);
@property (nonatomic, copy) void(^cancelBlock)();
/** ActionSheet所有按钮数组 */
@property (nonatomic, strong) NSMutableArray *actionSheetButtonArr;

@end

@implementation CCAlertView

#pragma mark ================================= 系统UIAlertView弹框 ========================

+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
                         title:(NSString *)title
                       message:(NSString *)message
              cancelButtonName:(NSString *)cancelButtonName
             otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION
{
    if (KsystemVersion < 9.0){ // iOS9以前系统弹框
        
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if(alertViewCallBackBlock){
                alertViewCallBackBlock(buttonIndex);
            }
        } title:title message:message cancelButtonName:cancelButtonName otherButtonTitles:otherButtonTitles, nil];
        
    } else { //ios9以后系统弹框
        
        //获取按钮个数
        NSMutableArray *mutableOtherTitles = [NSMutableArray array];
        va_list otherButtonTitleList;
        va_start(otherButtonTitleList, otherButtonTitles);
        {
            for (NSString *otherButtonTitle = otherButtonTitles; otherButtonTitle != nil; otherButtonTitle = va_arg(otherButtonTitleList, NSString *)) {
                [mutableOtherTitles addObject:otherButtonTitle];
            }
        }
        va_end(otherButtonTitleList);
        
        //按钮至少要有一个
        if(mutableOtherTitles.count == 0 && !cancelButtonName) return;
        
        //防止传入错误参数
        if(title && ![title isKindOfClass:[NSString class]]) {
            title = @"标题错误!";
        }
        
        if(message && ![message isKindOfClass:[NSString class]]) {
            message = @"提示信息错误!";
        }
        
        //弹出ios9以上的系统框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //如果按钮个数大于两个, 则把 "取消"按钮放最后, 否则放第一个
        if (mutableOtherTitles.count>1) { //多个按钮时,系统布局会有差别
            
            //普通按钮放前面
            for(int i=0; i<mutableOtherTitles.count; i++) {
                [alertController addAction:[UIAlertAction actionWithTitle:mutableOtherTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(alertViewCallBackBlock){
                        
                        if(cancelButtonName){
                            alertViewCallBackBlock(i+1);//取消按钮放在第一个,所以要加1
                        } else {
                            alertViewCallBackBlock(i);
                        }
                    }
                }]];
            }
            
            //取消按钮放最后
            if(cancelButtonName)
            {
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(alertViewCallBackBlock){
                        alertViewCallBackBlock(0);
                    }
                }]];
            }
            
            
            /** 设置颜色*/
            if([CCAlertView getVariableWithClass:[alertController.actions.firstObject class] varName:@"titleTextColor"])
            {
                for(int i = 0;i < alertController.actions.count;i++)
                {
                    UIAlertAction *action = alertController.actions[i];
                    if(i == alertController.actions.count-1)
                    {
                        [action setValue:Color_Main forKey:@"titleTextColor"];//黄色
                    } else {
                        [action setValue:Color_BlackFont forKey:@"titleTextColor"];
                    }
                }
            }
            
            
        } else
        {  //只有一个或两个按钮的情况
            
            //取消按钮放前面
            if(cancelButtonName)
            {
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(alertViewCallBackBlock){
                        alertViewCallBackBlock(0);
                    }
                }]];
            }
            
            //普通按钮放最后
            for(int i=0; i<mutableOtherTitles.count; i++) {
                [alertController addAction:[UIAlertAction actionWithTitle:mutableOtherTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(alertViewCallBackBlock){
                        
                        if(cancelButtonName){
                            alertViewCallBackBlock(i+1);//取消按钮放在第一个,所以要加1
                        } else {
                            alertViewCallBackBlock(i);
                        }
                    }
                }]];
            }
            
            /** 设置颜色*/
            if([CCAlertView getVariableWithClass:[alertController.actions.firstObject class] varName:@"titleTextColor"])
            {
                for(int i = 0;i < alertController.actions.count;i++)
                {
                    UIAlertAction *action = alertController.actions[i];
                    if(alertController.actions.count == 1)
                    {
                        [action setValue:Color_Main forKey:@"titleTextColor"];//黄色
                        
                    } else if (alertController.actions.count == 2) {
                        
                        if(i == 0){
                            [action setValue:Color_BlackFont forKey:@"titleTextColor"];
                        } else {
                            [action setValue:Color_Main forKey:@"titleTextColor"];
                        }
                    }
                }
            }
        }
        
        //** 设置字体为细体
        if([CCAlertView getVariableWithClass:[alertController class] varName:@"attributedTitle"])
        {
            if(title){
                NSAttributedString *titleAttrs = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: UIColorFromHex(0x323232), NSFontAttributeName: FONTDEFAULT(16)}];
                [alertController setValue:titleAttrs forKey:@"attributedTitle"];
            }
            
            if(message && [CCAlertView getVariableWithClass:[alertController class] varName:@"_attributedMessage"]){
                NSAttributedString *messageAttrs = [[NSAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName: UIColorFromHex(0x323232), NSFontAttributeName: FONTDEFAULT(14)}];
                [alertController setValue:messageAttrs forKey:@"_attributedMessage"];
            }
        }
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark ========================= 系统带输入的UIAlertView弹框 ========================

+ (void)inputAlertWithTitle:(NSString *)title
                placeholder:(NSString *)placeholder
                cancelTitle:(NSString *)cancelTitle
                 otherTitle:(NSString *)otherTitle
                buttonBlock:(void (^)(NSString *inputText))buttonBlock
                cancelBlock:(void (^)())cancelBlock
{
    NSString *showText = nil;
    if ([title rangeOfString:@"提现"].location != NSNotFound) { //特殊处理
        showText = [[title componentsSeparatedByString:@"提现"] lastObject];
        title = @"提现";
    }
    
    if (KsystemVersion < 9.0){ // iOS9以前系统弹框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:cancelTitle
                                              otherButtonTitles:otherTitle,nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = placeholder;
        //        if (showText) {
        //            textField.text = showText;
        //            textField.enabled = NO;
        //        }
        [alert show];
        
        //保存block
        objc_setAssociatedObject(alert, kButtonBlockKey, buttonBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(alert, kCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
    } else { //弹出ios9以上的系统框
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (buttonBlock) {
                NSString *inputStr = [alertController.textFields[0] text];
                buttonBlock(inputStr);
            }
        }]];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.placeholder = placeholder;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            //            if (showText) {
            //                textField.text = showText;
            //                textField.enabled = NO;
            //            }
            
            if (KsystemVersion < 9.0) {
                textField.superview.superview.layer.cornerRadius = 1;
                textField.superview.superview.layer.masksToBounds = YES;
                textField.superview.superview.layer.borderColor = UIColorFromHex(0xdcdcdc).CGColor;
                textField.superview.superview.layer.borderWidth = 0.5;
            } else {
                
                /** 是否能获取该属性*/
                Class cls = NSClassFromString(@"_UIAlertControllerTextField");
                if([textField isKindOfClass:cls] && [CCAlertView getVariableWithClass:cls varName:@"_textFieldView"])
                {
                    UIView *textFieldBorderView = [textField valueForKeyPath:@"_textFieldView"];
                    if ([textFieldBorderView isKindOfClass:[UIView class]]) {
                        textFieldBorderView.layer.cornerRadius = 3;
                        textFieldBorderView.layer.masksToBounds = YES;
                        textFieldBorderView.layer.borderWidth = 0.5;
                        textFieldBorderView.layer.borderColor = UIColorFromHex(0xdcdcdc).CGColor;
                    }
                }
            }
        }];
        
        /** 是否能获取该属性*/
        if([CCAlertView getVariableWithClass:[alertController class] varName:@"attributedTitle"])
        {
            //设置标题为细体
            NSAttributedString *titleAttrs = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:Color_BlackFont, NSFontAttributeName: FONTDEFAULT(16)}];
            [alertController setValue:titleAttrs forKey:@"attributedTitle"];
        }
        
        //设置按钮颜色
        if([CCAlertView getVariableWithClass:[UIAlertAction class] varName:@"titleTextColor"])
        {
            for (UIAlertAction *action in alertController.actions) {
                if ([action.title isEqualToString:@"取消"]) {
                    [action setValue:UIColorFromHex(0x282828) forKey:@"titleTextColor"];
                } else {
                    [action setValue:Color_Main forKey:@"titleTextColor"];
                }
            }
        }
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - iOS9.0以下系统UIAlertView弹框代理

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        void (^cancelBlock)() = objc_getAssociatedObject(alertView, kCancelBlockKey);
        if (cancelBlock) {
            cancelBlock();
        }
        
    } else if (buttonIndex == 1) {
        void (^buttonBlock)(NSString *) = objc_getAssociatedObject(alertView, kButtonBlockKey);
        if (buttonBlock) {
            NSString *inputStr = [[alertView textFieldAtIndex:0] text];
            buttonBlock(inputStr);
        }
    }
}


#pragma mark - 系统Alert弹框,2秒自动消失

/**
 *  系统Alert弹框,自动消失
 *
 *  @msg 提示文字
 */
void showAlertToast(NSString *msg) {
    
    //隐藏页面上的弹框
    [[CCAnimation instanceAnimation] stopAnimationWithDuration:CCNumberTypeOf0 completion:nil];
    
    // 移除仓口的以前UIAlertView的系统弹框
    for (UIWindow* w in [UIApplication sharedApplication].windows){
        for (NSObject* o in w.subviews){
            if ([o isKindOfClass:[UIAlertView class]]){
                [(UIAlertView*)o dismissWithClickedButtonIndex:[(UIAlertView*)o cancelButtonIndex] animated:NO];
            }
        }
    }
    
    if (!msg && msg.length == 0) return;
    
    if (KsystemVersion < 9.0){ // iOS8以前系统弹框
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        //** 设置字体为细体
        NSObject *obj = [alertView valueForKeyPath:@"_alertController"];
        if(msg && [obj isKindOfClass:[UIAlertController class]]){
            
            UIAlertController *alertVC = (UIAlertController *)obj;
            //** 设置字体为细体
            if([CCAlertView getVariableWithClass:[alertVC class] varName:@"_attributedMessage"])
            {
                //细体字
                UIFont *textFont = [UIFont fontWithName:@"Heiti SC" size:14];
                if (!textFont) {
                    textFont = FONTDEFAULT(14);
                }
                if(msg && [CCAlertView getVariableWithClass:[alertVC class] varName:@"_attributedMessage"]){
                    NSAttributedString *messageAttrs = [[NSAttributedString alloc] initWithString:msg attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:textFont}];
                    [alertVC setValue:messageAttrs forKey:@"_attributedMessage"];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultAlertTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
        });
        
    } else { //ios9以后系统弹框
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        //查看是否已经有弹框,有就先移除弹框, 否则多个弹框显示会异常
        UIViewController *hasPresentedVC = window.rootViewController.presentedViewController;
        if (hasPresentedVC && [hasPresentedVC isKindOfClass:[UIAlertController class]]) {
            [hasPresentedVC dismissViewControllerAnimated:NO completion:nil];
        } else {
            hasPresentedVC = [CCUtility obtainCurrentViewController];
            if (hasPresentedVC && [hasPresentedVC isKindOfClass:[UIAlertController class]]) {
                [hasPresentedVC dismissViewControllerAnimated:NO completion:nil];
            }
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        //** 设置字体为细体
        if([CCAlertView getVariableWithClass:[alertController class] varName:@"_attributedMessage"])
        {
            //细体字
            UIFont *textFont = [UIFont fontWithName:@"Heiti SC" size:14];
            if (!textFont) {
                textFont = FONTDEFAULT(14);
            }
            if(msg && [CCAlertView getVariableWithClass:[alertController class] varName:@"_attributedMessage"]){
                NSAttributedString *messageAttrs = [[NSAttributedString alloc] initWithString:msg attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:textFont}];
                [alertController setValue:messageAttrs forKey:@"_attributedMessage"];
            }
        }
        [window.rootViewController presentViewController:alertController animated:NO completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultAlertTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:NO completion:nil];
        });
    }
}

/** 
 *  返回字符串Size
 */
+(CGSize)stringSize:(NSString *)string andFont:(UIFont *)fontsize andwidth:(CGFloat)numsize
{
    NSString *text = string;
    UIFont *font = fontsize;//跟label的字体大小一样
    CGSize size = CGSizeMake(numsize, MAXFLOAT);//跟label的宽设置一样
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}


/**
 *  校验一个类是否有该属性
 */
+ (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name
{
    unsigned int outCount;
    BOOL hasProperty = NO;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (int i = 0; i < outCount; i++)
    {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        
        NSString *absoluteName = [NSString stringWithString:name];
        absoluteName = [absoluteName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:absoluteName]) {
            hasProperty = YES;
            break;
        }
    }
    //释放
    free(ivars);
    return hasProperty;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end

