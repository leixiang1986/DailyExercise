//
//  Test2TableViewCell.h
//  AutoLayoutTest
//
//  Created by 雷祥 on 17/2/7.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Test2TableViewCell : UITableViewCell
@property (nonatomic, copy) void(^cellBlock)(BOOL, NSIndexPath *cellIndex);
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
