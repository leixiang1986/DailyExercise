//
//  OkdeerMMPickerView.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 16/12/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "OkdeerMMPickerView.h"

NSString * const MMtoolbarColor = @"toolbarColor";
#define kFullScreenWidth  ([UIScreen mainScreen].bounds.size.width)

#undef UIColorMMPickerViewHex
#define UIColorMMPickerViewHex(hexValue) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:1.0])

@interface OkdeerMMPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *pickerViewLabel;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *pickerViewContainerView;
@property (nonatomic, strong) UIView *pickerTopBarView;
@property (nonatomic, strong) UIToolbar *pickerViewToolBar;
@property (nonatomic, strong) UIBarButtonItem *pickerViewBarButtonItemSure; //modify by chenzl
@property (nonatomic, strong) UIBarButtonItem *pickerViewBarButtonItemCancal; //modify by chenzl
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *pickerViewArray;
@property (copy) void (^onDismissCompletion)(NSString *,NSInteger);

@end

@implementation OkdeerMMPickerView

+ (OkdeerMMPickerView*)sharedView
{
    static dispatch_once_t once;
    static OkdeerMMPickerView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc] init];
    });
    return sharedView;
}

#pragma mark - /*** Show Methods ***/
+ (void)showPickerViewInView:(UIView *)view
                  withSource: (NSArray *)sourceArray
                  completion:(void (^)(NSString *,NSInteger))completion
{
    [[self sharedView] initializePickerViewInView:view
                                        withArray:sourceArray
                                      withOptions:nil];
    
    [[self sharedView] setPickerHidden:NO callBack:nil];
    [self sharedView].onDismissCompletion = completion;
    [view addSubview:[self sharedView]];
}


#pragma mark - /*** Dismiss Methods ***/
+ (void)dismissWithCompletion:(void (^)(NSString *))completion
{
    [[self sharedView] setPickerHidden:YES callBack:nil];
}

//取消
-(void)dismiss
{
    [OkdeerMMPickerView dismissWithCompletion:nil];
}

//add by chenzl
//确定
-(void)BtnSure
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    if (row < [_pickerViewArray count]) {
        self.onDismissCompletion ([_pickerViewArray objectAtIndex:row],row);
    }
    [OkdeerMMPickerView dismissWithCompletion:nil];
}

+ (void)removePickerView
{
    [[self sharedView] removeFromSuperview];
}

#pragma mark - /*** Show/hide PickerView methods ***/
- (void)setPickerHidden: (BOOL)hidden
               callBack: (void(^)(NSString *))callBack;
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         if (hidden) {
                             [_pickerViewContainerView setAlpha:0.0];
                             [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
                         } else {
                             [_pickerViewContainerView setAlpha:1.0];
                             [_pickerContainerView setTransform:CGAffineTransformIdentity];
                         }
                     } completion:^(BOOL completed) {
                         if(completed && hidden){
                             [OkdeerMMPickerView removePickerView];
                             //取消回调 modify by chenzl
                             //callBack([self selectedObject]);
                         }
                     }];
    
}

#pragma mark - /*** Initialize PickerView ***/
- (void)initializePickerViewInView: (UIView *)view
                         withArray: (NSArray *)array
                       withOptions: (NSDictionary *)options {
    
    _pickerViewArray = array;
    
    [self setFrame: view.bounds];
    [self setBackgroundColor:[UIColor clearColor]];
    
    //Whole screen with PickerView and a dimmed background
    _pickerViewContainerView = [[UIView alloc] initWithFrame:view.bounds];
    [_pickerViewContainerView setBackgroundColor: [UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7]];
    [self addSubview:_pickerViewContainerView];
    
    //PickerView Container with top bar
    _pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _pickerViewContainerView.bounds.size.height - 260.0, kFullScreenWidth, 260.0)];
    
    //增加触摸点击事件 by chenzl
    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    UIView *tapview = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kFullScreenWidth, _pickerViewContainerView.bounds.size.height - 260.0)];
    tapview.backgroundColor = [UIColor clearColor];
    [tapview addGestureRecognizer:recog];
    [_pickerViewContainerView addSubview:tapview];
    
    _pickerContainerView.backgroundColor = [UIColor whiteColor];
    [_pickerViewContainerView addSubview:_pickerContainerView];
    
    //Top bar view
    _pickerTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kFullScreenWidth, 44.0)];
    [_pickerContainerView addSubview:_pickerTopBarView];
    [_pickerTopBarView setBackgroundColor:[UIColor whiteColor]];
    CALayer *seplayer = [CALayer layer];
    seplayer.backgroundColor = UIColorMMPickerViewHex(0xe2e2e2).CGColor;
    seplayer.frame = CGRectMake(0.f, 44 - (1/[UIScreen mainScreen].scale), kFullScreenWidth, (1/[UIScreen mainScreen].scale));
    [_pickerTopBarView.layer addSublayer:seplayer];
    
    //UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //
    UIButton *surebtn = [[UIButton alloc] initWithFrame:CGRectMake(kFullScreenWidth - 60, 9.5f, 50.f, 25.f)];
    surebtn.backgroundColor = [UIColor clearColor];
    surebtn.layer.cornerRadius = surebtn.frame.size.height/2;
    surebtn.layer.masksToBounds = YES;
    surebtn.layer.borderColor = UIColorMMPickerViewHex(0x8cc63f).CGColor;
    surebtn.layer.borderWidth = (1/[UIScreen mainScreen].scale) *2;
    [surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [surebtn setTitleColor:UIColorMMPickerViewHex(0x8cc63f) forState:UIControlStateNormal];
    surebtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [surebtn addTarget:self action:@selector(BtnSure) forControlEvents:UIControlEventTouchUpInside];
    _pickerViewBarButtonItemSure = [[UIBarButtonItem alloc] initWithCustomView:surebtn];
    [_pickerTopBarView addSubview:surebtn];
    
    UIButton *cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 9.5f, 50.f, 25.f)];
    cancelbtn.backgroundColor = [UIColor clearColor];
    cancelbtn.layer.cornerRadius = surebtn.frame.size.height/2;
    cancelbtn.layer.masksToBounds = YES;
    cancelbtn.layer.borderWidth = (1/[UIScreen mainScreen].scale) *2;
    cancelbtn.layer.borderColor = UIColorMMPickerViewHex(0xcccccc).CGColor;
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:UIColorMMPickerViewHex(0xcccccc) forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelbtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _pickerViewBarButtonItemCancal = [[UIBarButtonItem alloc] initWithCustomView:cancelbtn];
    [_pickerTopBarView addSubview:cancelbtn];
    
    //Add pickerView
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, kFullScreenWidth, 216.0)];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [_pickerView setShowsSelectionIndicator: YES];
    [_pickerContainerView addSubview:_pickerView];
    
    [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
    
    //Set selected row
    [_pickerView selectRow:0 inComponent:0 animated:YES];
}

#pragma mark - /*** UIPickerViewDelegate ***/
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [_pickerViewArray count];
}

- (NSString *)pickerView: (UIPickerView *)pickerView
             titleForRow: (NSInteger)row
            forComponent: (NSInteger)component
{
    return [_pickerViewArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (id)selectedObject {
    return [_pickerViewArray objectAtIndex: [self.pickerView selectedRowInComponent:0]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UIView *customPickerView = view;
    
    UILabel *pickerViewLabel;
    
    if (customPickerView==nil) {
        
        CGRect frame = CGRectMake(0.0, 0.0, 292.0, 44.0);
        customPickerView = [[UIView alloc] initWithFrame: frame];
        
        CGRect labelFrame = CGRectMake(0.0, 4.5, 292.0, 35); // 35 or 44
        pickerViewLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [pickerViewLabel setTag:1];
        [pickerViewLabel setTextAlignment: NSTextAlignmentCenter];
        [pickerViewLabel setBackgroundColor:[UIColor clearColor]];
        [pickerViewLabel setTextColor:[UIColor blackColor]];
        [pickerViewLabel setFont:[UIFont systemFontOfSize:17]];
        [customPickerView addSubview:pickerViewLabel];
    } else {
        for (UIView *view in customPickerView.subviews) {
            if (view.tag == 1) {
                pickerViewLabel = (UILabel *)view;
                break;
            }
        }
    }
    
    if (row < [_pickerViewArray count]) {
        [pickerViewLabel setText: [_pickerViewArray objectAtIndex:row]];
    }
    return customPickerView;
}

#pragma mark - /*** 更改数据源 ***/
-(void)changeSourcesArray:(NSArray *)array
{
    if ([array count] <= 0) {
        return ;
    }
    _pickerViewArray = array;
    [_pickerView reloadAllComponents];
}

+(void)changeWithSourceArray:(NSArray *)sourceArray
{
    if ([sourceArray count] <= 0) {
        return ;
    }
    [[self sharedView] changeSourcesArray:sourceArray];
}

@end
