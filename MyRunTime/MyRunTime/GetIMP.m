//
//  GetIMP.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/22.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "GetIMP.h"
#import <objc/runtime.h>

@implementation GetIMP

- (void)test1 {
    NSLog(@"%s",__FUNCTION__);
}

+ (void)testGetIMPFormSelector {
    SEL aSelector = @selector(test1);
//    1.获取方法实现的两种形式
    IMP instanceIMP1 = class_getMethodImplementation(objc_getClass("GetIMP"), aSelector);
    
    IMP classIMP1 = class_getMethodImplementation(objc_getMetaClass("GetIMP"), aSelector);
    
//    2.
    Method instanceMethod = class_getInstanceMethod(objc_getClass("GetIMP"), aSelector);
    IMP instanceIMP2 = method_getImplementation(instanceMethod);
    
    Method classMethod2 = class_getInstanceMethod(objc_getMetaClass("GetIMP"), aSelector);
    IMP classIMP2 = method_getImplementation(classMethod2);
    
    NSLog(@"%p , %p , %p , %p",instanceIMP1,classIMP1,instanceIMP2,classIMP2);
    
}

-(void)dealloc {
    
}
@end
