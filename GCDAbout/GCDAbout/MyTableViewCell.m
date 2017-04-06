//
//  MyTableViewCell.m
//  UnfoldTableView
//
//  Created by 雷祥 on 2017/3/10.
//  Copyright © 2017年 okdeer. All rights reserved.
//

//参考:http://blog.jobbole.com/107367/
#import "MyTableViewCell.h"
#include <libkern/OSAtomic.h>
#import "MyFormatter.h"


@interface MyTableViewCell ()
@property (nonatomic,strong) NSDateFormatter *formater;
@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self amountAttributes];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.textLabel addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];

    }

    return self;
}


- (NSDateFormatter *)formater {
    if (!_formater) {
        __weak static MyFormatter *dateFormater = nil;
        static OSSpinLock lock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&lock);
        _formater = dateFormater;
        if (!_formater) {
            _formater = [[MyFormatter alloc] init];
            [_formater setDateFormat:@"yyyy-MM-dd"];
            dateFormater = _formater;
        }
        OSSpinLockUnlock(&lock);
    }

    return _formater;
}


- (NSDictionary *)amountAttributes;
{
    if (_amountAttributes == nil) {
        static __weak NSDictionary *cachedAttributes = nil; //static弱引用，可使该类只拥有一个实例变量，在该类此次调用完成，会被释放
        static OSSpinLock lock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&lock);  //自旋锁比互斥锁效率高(不会引起调用线程的睡眠；互斥锁会引起调用线程的睡眠，让core能执行别的线程)，但会消耗cpu，如果长时间不能解锁，就会降低cpu，自旋锁一般用于小资源的加锁
        _amountAttributes = cachedAttributes;
        if (_amountAttributes == nil) {
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            attributes[NSFontAttributeName] = [UIFont fontWithName:@"ComicSans" size:20];
            attributes[NSParagraphStyleAttributeName] = [NSParagraphStyle defaultParagraphStyle];
            attributes[NSForegroundColorAttributeName] = [UIColor redColor];
            _amountAttributes = attributes ;
            cachedAttributes = _amountAttributes;
        }
        OSSpinLockUnlock(&lock);
    }
    NSLog(@"=====%p",_amountAttributes);  //只有一个实例
    return _amountAttributes;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        id content = change[@"new"];
        if ([content isKindOfClass:[NSString class]]) {
            NSString *date = [self.formater stringFromDate:[NSDate date]];
            self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:date attributes:self.amountAttributes];

        }
        else {
            self.textLabel.attributedText = nil;
        }
    }

}




- (void)dealloc {
    NSLog(@"dell dealloc");
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"setSelected:%d----%ld",selected,_indexPath.row);
    if (selected) {
        self.backgroundColor = [UIColor yellowColor];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
    // Configure the view for the selected state
}

@end
