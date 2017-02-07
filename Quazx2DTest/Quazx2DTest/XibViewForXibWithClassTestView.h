//
//  XibViewForXibWithClassTestView.h
//  Quazx2DTest
//
//  Created by 雷祥 on 16/12/30.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
//测试xibview能够在代码和界面中用
IB_DESIGNABLE
@interface XibViewForXibWithClassTestView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
