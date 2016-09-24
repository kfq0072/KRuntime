//
//  Tools.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/23.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "Tools.h"
#import <objc/runtime.h>
@implementation Tools

+ (NSArray*)getClassIVarNames:(Class)kClass {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;
    
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList(kClass, &count);
    for (unsigned int i; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        [array addObject:[NSString stringWithUTF8String:ivarName]];
    }
    return [NSArray arrayWithArray:array];
}
+ (NSArray*)getClassMethodList:(Class)kClass {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;

    //获取方法列表
    Method *methodList = class_copyMethodList(kClass, &count);
    for (unsigned int i; i<count; i++) {
        Method method = methodList[i];
         [array addObject:NSStringFromSelector(method_getName(method))];
    }
    return [NSArray arrayWithArray:array];
}

+ (NSArray*)getClassPropertyList:(Class)kClass {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList(kClass, &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *iVarName = [NSString stringWithUTF8String:propertyName];
        [array addObject:iVarName];
    }
     return [NSArray arrayWithArray:array];
}

+ (NSArray*)getClassProtocolList:(Class)kClass {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(kClass, &count);
    for (unsigned int i; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
         [array addObject:[NSString stringWithUTF8String:protocolName]];
    }
    return [NSArray arrayWithArray:array];
}



@end
