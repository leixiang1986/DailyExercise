//
//  UIButton+ImageAndTitleDisplay.m
//  基本控件
//
//  Created by 雷祥 on 17/2/10.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "UIButton+ImageAndTitleDisplay.h"
#import <objc/message.h>

static const void *kSpacing = &kSpacing;
static const void *kDisplayType = &kDisplayType;
static const void *kHasAddObserver = &kHasAddObserver;

@interface UIButton ()
@property (nonatomic, assign, readwrite) BOOL hasAddObserver;
@property (nonatomic, assign, readwrite) OKButtonImageAndTitleDisplayType displayType;         /**< 图片和titleLabel位置布局类型 */
@property (nonatomic, assign, readwrite) NSInteger spacing;                                    /**< 图片和titleLabel的间距，在只有图片或者只有文字时，此值无效（因为设置为CGFloat会崩溃暂时用NSInteger） */

@end

@implementation UIButton (ImageAndTitleDisplay)
//是否已经添加监听
- (void)setHasAddObserver:(BOOL)hasAddObserver{
    NSNumber *hasAddObserverNum = [NSNumber numberWithBool:hasAddObserver];
    objc_setAssociatedObject(self, kHasAddObserver, hasAddObserverNum, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hasAddObserver {
    return [objc_getAssociatedObject(self, kHasAddObserver) boolValue];
}

- (void)setSpacing:(NSInteger)spacing {
    NSNumber *space = [NSNumber numberWithInteger:spacing];
    objc_setAssociatedObject(self, kSpacing, space, OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)spacing {
    NSNumber *space = objc_getAssociatedObject(self, kSpacing);
    return space.integerValue;
}




- (void)setDisplayType:(OKButtonImageAndTitleDisplayType)displayType {



    NSNumber *dispalyTypeNum = [NSNumber numberWithInt:displayType];
    objc_setAssociatedObject(self, kDisplayType, dispalyTypeNum, OBJC_ASSOCIATION_ASSIGN);
}


- (OKButtonImageAndTitleDisplayType)displayType {
    return [objc_getAssociatedObject(self, kDisplayType) integerValue];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"observeValueForKeyPath:%@===%@",keyPath,change);
    if ([keyPath isEqualToString:@"titleLabel.text"]) {
        [self displayWithType:self.displayType];
    }
    else if ([keyPath isEqualToString:@"imageView.image"]){
        [self displayWithType:self.displayType];
    }
}

- (void)displayWithType:(OKButtonImageAndTitleDisplayType)type {
    switch (type) {
        case OKButtonImageAndTitleDisplayTypeImageLeft:
            [self setImageLeft];
            break;
        case OKButtonImageAndTitleDisplayTypeImageRight:
            [self setImageRight];
            break;
        case OKButtonImageAndTitleDisplayTypeImageUp:
            [self setImageUp];
            break;
        case OKButtonImageAndTitleDisplayTypeImageDown:
            [self setImageDown];
            break;

        default:
            break;
    }
}


- (void)setDisplayType:(OKButtonImageAndTitleDisplayType)displayType withSpace:(CGFloat)spacing{
    if (!self.hasAddObserver) {//在西安设置OKButtonImageAndTitleDisplayType 后设置文字和图片时，需要监听
        [self addObserver:self forKeyPath:@"titleLabel.text" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
        [self addObserver:self forKeyPath:@"imageView.image" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
        self.hasAddObserver = YES;
        NSLog(@"只有一次");
    }
    if (spacing < 0) {
        spacing = 0;
    }

    self.spacing = spacing;
    self.displayType = displayType;
    if (self.titleLabel.text.length && self.imageView.image) {
        [self displayWithType:displayType];
    }
}


#pragma mark 设置imageView和titleLabel的位置
//图片在右，文字在左
- (void)setImageRight{
    CGFloat space = [self getValidSpace];
    //相对于原来的imageView位置进行移动
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width + space, 0, -self.titleLabel.frame.size.width - space); // imageView向右整体移动titleLabel的宽度+space/2
    //相对于原来的titleLabel位置进行移动
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width - space, 0, self.imageView.frame.size.width + space);   // titleLable向左整体移动imageView的宽度+space/2
}


//图片在上，文字在下
- (void)setImageUp {
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + self.spacing, -(titleSize.width))];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + self.spacing, -(imageSize.width), 0, 0)];

}

//图片在左边
- (void)setImageLeft {
    CGFloat validSpace = [self getValidSpace];
    //相对原来的位置进行移动
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -validSpace/2, 0, validSpace/2);
    //相对于原来的titleLabel位置进行移动
    self.titleEdgeInsets = UIEdgeInsetsMake(0, validSpace/2, 0, -validSpace/2);
}

//图片在下边
- (void)setImageDown {
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGFloat validSpace = [self getValidSpace];
    [self setImageEdgeInsets:UIEdgeInsetsMake(titleSize.height + validSpace,0, 0, -(titleSize.width))];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageSize.width), imageSize.height + validSpace, 0)];
}

//获取有效间距
- (CGFloat)getValidSpace{
    //只有图片和文字都有时，间距才有效.
    return self.titleLabel.text.length && self.imageView.image ? self.spacing : 0;
}


- (void)dealloc {
    if (self.hasAddObserver) {
        [self removeObserver:self forKeyPath:@"titleLabel.text"];
        [self removeObserver:self forKeyPath:@"imageView.image"];
    }
}

@end
