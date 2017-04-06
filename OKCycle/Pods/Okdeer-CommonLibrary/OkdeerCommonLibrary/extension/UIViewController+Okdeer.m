//
//  UIViewController+Okdeer.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "UIViewController+Okdeer.h"

@implementation UIViewController (Okdeer)



#pragma mark - /*** 顶层控制器 ***/

/**
 * 通过控制器获取其导航控制器中的顶层控制器
 */
- (UIViewController *)ok_obtainNavigationVCTopViewController {
    UIViewController *viewController = self;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *topVC = [(UINavigationController *)self topViewController];
        viewController = topVC ? topVC : viewController;
    }else{
        UIViewController *parentViewController = viewController.parentViewController;
        if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {
            UIViewController *viewController1 = [(UINavigationController *)parentViewController topViewController];
            viewController = viewController1 ? viewController1 : viewController;
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                viewController = [viewController ok_obtainNavigationVCTopViewController];
            }
        }else if (parentViewController){
            viewController = parentViewController;
        }
    }

    return viewController;
}

/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)ok_obtainTopViewController{
    UIViewController *viewController = [self activityViewController];
    UIViewController *lastViewController  = [self getCurrentViewController:viewController];
    return lastViewController;
}

/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)getCurrentViewController:(UIViewController *)viewController
{
    UIViewController *lastViewController  = nil;
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)viewController ;
        NSInteger selectIndex = tabBarController.selectedIndex ;
        if (selectIndex < tabBarController.viewControllers.count) {
            UIViewController *tabViewController = tabBarController.viewControllers[selectIndex];
            if ([tabViewController isKindOfClass:[UINavigationController class]]) {
                lastViewController = [[(UINavigationController *)tabViewController viewControllers] lastObject];
                lastViewController = [self getPresentedViewController :lastViewController];
            }else{
                lastViewController = [self getPresentedViewController:tabViewController];
            }
        }
    }else if ([viewController isKindOfClass:[UINavigationController class]]){
        
        lastViewController = [[(UINavigationController *)viewController viewControllers] lastObject];
        lastViewController = [self getPresentedViewController:lastViewController];
    }else{
        
        lastViewController = [self getPresentedViewController:viewController];
    }
    
    return lastViewController;
}
/**
 *  获取PresentedViewController
 */
+ (UIViewController *)getPresentedViewController:(UIViewController *)viewController
{
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;                // 1. ViewController 下
        
        if ([viewController isKindOfClass:[UINavigationController class]]) {                // 2. NavigationController 下
            viewController =  [self getCurrentViewController:viewController];
        }
        
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = [self getCurrentViewController:viewController];     // 3. UITabBarController 下
        }
    }
    return viewController;
}
/**
 *  获取当前处于activity状态的view controller
 */
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

@end
