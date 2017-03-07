//
//  Son.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/13.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "Son.h"

@implementation Son

//ios app启动，所有类都会自动调用此函数,它来初始化静态变量
+ (void)load{
    NSLog(@"%s ",__func__);
}
//+ initialize 方法的调用看起来会更合理，通常在它里面写代码比在 + load 里写更好。+ initialize 很有趣，因为它是懒调用的，也有可能完全不被调用。类第一次被加载时，
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
