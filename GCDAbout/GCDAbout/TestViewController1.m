//
//  TestViewController1.m
//  GCDAbout
//
//  Created by 雷祥 on 2017/3/22.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "TestViewController1.h"
#import "Model.h"

@interface TestViewController1 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation TestViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];


    /**
     *  异步并发队列:根据任务的多少和设备的核数，开线程
     *  异步串行队列:在自创队列上很可能会开线程，但在主队列上不会开线程，会在主线程上执行(方法1，2对比)
     *  同步并发队列:主线程调用,尽管是并发队列，但是是同步函数，不具备开线程的能力，还是在调用线程(主线程中执行)
     *  主线程调用同步串行队列，队列为自创队列，执行任务是在主线程执行。(方法5)
     *  主线程调用同步串行队列，并且串行队列上是主队列，则会发生死锁（方法4)；如果调用者是子线程，执行任务是主队列的主线程，不会发生死锁
     *  总结：任务在哪个线程中执行，不仅与gcd的同步异步，串行并发有关，还与调用线程有关(具体看方法开头的结论)
     */


}





- (NSArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"0异步并发",@"1异步串行(自创队列)",@"2异步串行(主队列)",@"3同步并发",@"4主线程调用同步串行(同步队列为主线程---会死锁)",@"5主线程调用同步串行(同步队列为自创)",@"6子线程调用同步串行(队列为主队列,不会死锁)",@"7子线程调用同步串行(队列为自创队列)"];
        for (NSInteger i = 0; i < titles.count; i++) {
            Model *model = [[Model alloc] init];
            model.index = i;
            model.name = titles[i];
            [temp addObject:model];
        }
        _dataSource = [temp copy];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,size.width, size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }

    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    Model *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self asyncConcurrent0];
            break;
        case 1:
            [self asyncSerial1];
            break;
        case 2:
            [self asyncSerial2];
            break;
        case 3:
            [self syncConcurrent3];
            break;
        case 4:
            [self syncSerial4];
            break;
        case 5:
            [self syncSerial5];
            break;
        case 6:
            [self syncSerial6];
            break;
        case 7:
            [self syncSerial7];
            break;


        default:
            break;
    }

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self asyncConcurrent0];
}

/**
 * 异步并发
 */
- (void)asyncConcurrent0 {
    NSLog(@"0异步并发开始");
//    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(queue, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_async(queue, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_async(queue, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });


    NSLog(@"0异步并发结束");
}

/**
 *  异步串行(自创队列)(结论:在自创队列中，异步串行会尽管调用是主线程(注意这里是主线程调用--调用!!!)，但依然可以开一条新线程执行任务)
 */
- (void)asyncSerial1 {
    NSLog(@"1异步串行开始");
    dispatch_queue_t queue = dispatch_queue_create("asyncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_async(queue, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    NSLog(@"1异步串行结束");
}

/**
 *  异步串行(主队列)(结论:在主队列中，虽然是异步函数，但在主队列这个串行队列中始终会在主线程中执行)
 */
- (void)asyncSerial2 {
    NSLog(@"2异步串行(主队列)开始");
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_async(queue, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    NSLog(@"2异步串行(主队列)结束");
}

/**
 * 同步并发
 */
- (void)syncConcurrent3 {
    NSLog(@"3同步并发开始");
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    NSLog(@"3同步并发结束");
}

/**
 * 同步串行(如果是主线程调用，在主线程执行就会发生死锁，主线程执行syncSerial4方法，方法中又需主线程执行任务且是同步)
 */
- (void)syncSerial4 {
    NSLog(@"4同步串行开始");
    dispatch_queue_t queueMain = dispatch_get_main_queue(); //主线程

    dispatch_sync(queueMain, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queueMain, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queueMain, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    NSLog(@"4同步串行结束");
}

/**
 * 同步串行,在主线程中调用，在自创队列中执行任务(结论:在主线程中执行，尽管是主线程调用，但队列不是主队列,不会形成死锁)
 */
- (void)syncSerial5 {
    NSLog(@"5同步串行开始");
    dispatch_queue_t queue = dispatch_queue_create("asyncSerial", DISPATCH_QUEUE_SERIAL);   //创建线程

    dispatch_sync(queue, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queue, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queue, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });


    NSLog(@"5同步串行结束");
    NSLog(@"调用线程：thread----%@",[NSThread currentThread]);
}

/**
 * 子线程中调用主队列中的同步串行任务（结论:会在主线程中执行任务,不会死锁）
 */
- (void)syncSerial6 {
    [NSThread detachNewThreadSelector:@selector(method6) toTarget:self withObject:nil];
}

/**
 * 子线程中调用主队列中的同步串行任务（结论:会在主线程中执行任务,不会死锁）
 */
- (void)method6 {
    NSLog(@"6子线程调用主队列的同步开始");
    dispatch_queue_t queueMain = dispatch_get_main_queue(); //主线程

    dispatch_sync(queueMain, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queueMain, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queueMain, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    NSLog(@"6子线程调用主队列的同步结束");
}



/**
 * 子线程调用自创队列的同步串行任务(结论:在调用的子线程中执行任务)
 */
- (void)syncSerial7 {
    [NSThread detachNewThreadSelector:@selector(method7) toTarget:self withObject:nil];

}

/**
 * 子线程调用自创队列的同步串行任务
 */
- (void)method7 {
    NSLog(@"7子线程调用自创队列的同步串行开始");
    dispatch_queue_t queue = dispatch_queue_create("syncSerial7", DISPATCH_QUEUE_SERIAL);

    dispatch_sync(queue, ^{
        NSLog(@"task1");
        for (NSInteger i = 0; i < 1230; i++) {
            NSLog(@"hahah");
        }
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queue, ^{
        NSLog(@"task2");
        NSLog(@"thread----%@",[NSThread currentThread]);
    });

    dispatch_sync(queue, ^{
        NSLog(@"task3");
        NSLog(@"thread----%@",[NSThread currentThread]);

    });

    NSLog(@"7子线程调用自创队列的同步串行结束");
    NSLog(@"调用线程:%@",[NSThread currentThread]);
}



@end
