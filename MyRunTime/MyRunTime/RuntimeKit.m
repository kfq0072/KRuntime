//
//  RuntimeKit.m
//  MRuntimeKit
//
//  Created by hsm on 2017/3/4.
//  Copyright © 2017年 SM. All rights reserved.
//

#import "RuntimeKit.h"
#import <objc/runtime.h>
@implementation RuntimeKit
+ (NSString *)fetchClassName:(Class)mClass
{
    const char *className = class_getName(mClass);
    return [NSString stringWithUTF8String:className];
}

+ (NSArray *)fetchIvarList:(Class)mClass
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(mClass, &count);
    NSMutableArray *mutableList = [NSMutableArray new];
    for (unsigned int i = 0 ; i < count; i++) {
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        NSDictionary *dic = @{@"type":[NSString stringWithUTF8String:ivarType],
                              @"ivarName":[NSString stringWithUTF8String:ivarName]
                              };
        [mutableList addObject:dic];
    }
    free(ivarList);
    return [NSArray arrayWithArray:mutableList];
}

+ (NSArray *)fetchPropertyList:(Class)mClass
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(mClass, &count);
    NSMutableArray *list = [NSMutableArray new];
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        [list addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return [NSArray arrayWithArray:list];
}

+ (NSArray *)fetchMethodList:(Class)mClass
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(mClass, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ ) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:mutableList];

}

+ (NSArray *)fetchProtocolList:(Class)mClass
{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(mClass, &count);
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++ ) {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableList addObject:[NSString stringWithUTF8String: protocolName]];
    }
    
    return [NSArray arrayWithArray:mutableList];
}

+ (void)addMethod:(Class)mClass method:(SEL)methodSel methodImp:(SEL)methodSelImp
{
    Method method = class_getInstanceMethod(mClass, methodSelImp);
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(mClass, methodSel, methodIMP, types);
}

+ (void)swapMethod:(Class)mClass currentMethod :(SEL)method1 targetMethod:(SEL)method2
{
    Method firstM = class_getInstanceMethod(mClass, method1);
    Method secondM = class_getInstanceMethod(mClass, method2);
    method_exchangeImplementations(firstM, secondM);
}
@end
