//
//  Person.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/13.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "Person.h"

@implementation Person
+(void)load {
    NSLog(@"%s",__FUNCTION__);
}

+(void)initialize {
     NSLog(@"%s",__FUNCTION__);
}

-(instancetype)init {
    if (self = [super init]) {
        NSLog(@"%s",__func__);
        NSLog(@"111: %@",NSStringFromClass([self class]));
        NSLog(@"222: %@",NSStringFromClass([super class]));
    }
    return self;
}

@end
