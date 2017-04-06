//
//  UIBarButtonItem+OKExtension.m
//  Pods
//
//  Created by 雷祥 on 2017/3/8.
//
//

#import "UIBarButtonItem+OKExtension.h"
#import "UIViewController+Okdeer.h"
#import "UIButton+OKExtension.h"

@implementation UIBarButtonItem (OKExtension)
/**
 * 添加点击的按钮:items到左边还是右边:type,在控制器vc的导航控制器,distance是调整位置的距离为负数是更靠边，为正数就往中间移动
 */
+ (void)ok_addBarButtonItems:(NSArray <UIBarButtonItem *>*)items toNavigation:(OKNavigationBarType)type inVC:(UIViewController *)vc adjustDistance:(CGFloat)distance {
    if (!items.count || !vc) {
        return;
    }

    vc = [vc ok_obtainNavigationVCTopViewController];
    if (type == OKNavigationBarTypeLeft) {
        vc.navigationItem.leftBarButtonItems = nil;
        vc.navigationItem.leftBarButtonItems = [self ok_barButtonItemsWithItemFixedSpace:items adjustDistance:distance];
    }
    else if (type == OKNavigationBarTypeRight){
        vc.navigationItem.rightBarButtonItems = nil;
        vc.navigationItem.rightBarButtonItems = [self ok_barButtonItemsWithItemFixedSpace:items adjustDistance:distance];
    }
}

/**
 * 给items添加调整距离,往中间移动为正，靠边为负
 */
+ (NSArray *)ok_barButtonItemsWithItemFixedSpace:(NSArray <UIBarButtonItem *>*)items adjustDistance:(CGFloat)distance {
    if (!items.count) {
        return nil;
    }

    NSMutableArray *tempItemArray = [[NSMutableArray alloc] initWithArray:items];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = distance;
    [tempItemArray insertObject:spaceItem atIndex:0];
    return [tempItemArray copy];
}

/**
 *  创建一个BarButtonItem 按钮size为 25*25 实际图片大小为17.5*17.5 UI要求
 *
 */
+ (instancetype)ok_barButtonItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonMustItemWithImage:image highImage:highImage target:target action:action];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
