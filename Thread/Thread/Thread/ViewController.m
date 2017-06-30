//
//  ViewController.m
//  Thread
//
//  Created by Agenric on 2017/6/16.
//  Copyright © 2017年 Agenric. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // NSThread
    NSString *someString = @"";
    [self performSelectorOnMainThread:@selector(doSomeThing:) withObject:someString waitUntilDone:YES];
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@""] waitUntilDone:YES];
    
    // GCD
    // 获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 开启一个新的线程，
    dispatch_async(queue, ^{
        // 执行耗时操作
        // dosomething
        
        // 回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // dosomething
        });
    });
    
    // NSOperationQueue
    // 创建队列
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    // 将要做的操作添加到队列中
    [queue1 addOperationWithBlock:^{
        // 执行耗时操作
        // dosomething
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // refresh UI
        }];
    }];
}


- (void)doSomeThing:(NSString *)string {
    
}

- (void)GCDMethod {
    dispatch_queue_t queue = nil;
    
    // 栅栏函数（控制任务的执行顺序）
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier");
    });
    
    // 延迟执行（延迟。控制在哪个线程执行）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after method");
    });
    
    // 一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"Often used for singleton");
    });
    
    // 快速迭代（开多个线程并完成迭代操作）
    NSArray *array = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"];
    dispatch_apply(array.count, queue, ^(size_t index) {
        NSLog(@"%zu: %@", index, [array objectAtIndex:index]);
    });
    
    // 队列组（同栅栏函数）
    dispatch_group_t group = dispatch_group_create();
    
}


@end
