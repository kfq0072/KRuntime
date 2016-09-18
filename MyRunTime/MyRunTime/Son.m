//
//  Son.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/13.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "Son.h"

@implementation Son
//ios app启动，在 main 函数之前执行的,所有类都会自动调用此函数(不用初始化),我们用它来初始化静态变量，先是super类，然后是子类
+ (void)load{
    NSLog(@"%s ",__func__);
}
+ (void)initialize{
    NSLog(@"%s ",__func__);
}
- (instancetype)init{
    if (self = [super init]) {
        NSLog(@"%s",__func__);
    }
    return self;
}

@end
