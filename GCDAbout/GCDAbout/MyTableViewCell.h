//
//  MyTableViewCell.h
//  UnfoldTableView
//
//  Created by 雷祥 on 2017/3/10.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *amountAttributes;
@property (nonatomic,copy) NSIndexPath *indexPath;
@end
