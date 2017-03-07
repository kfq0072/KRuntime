//
//  RuntimeKit.h
//  MRuntimeKit
//
//  Created by hsm on 2017/3/4.
//  Copyright © 2017年 SM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeKit : NSObject
/**
 获取类名
 
 @param mClass 相应类
 @return NSString :类名
 
 */
+ (NSString *)fetchClassName:(Class)mClass;

/**
 获取成员变量
 
 @param mClass 相应类
 @return NSArray :成员变量列表
 
 */
+ (NSArray *)fetchIvarList:(Class)mClass;

/**
 获取成员属性
 
 @param mClass 相应类
 @return NSArray :成员属性列表
 
 */
+ (NSArray *)fetchPropertyList:(Class)mClass;

/**
 获取实例方法
 
 @param mClass 相应类
 @return NSArray :实例方法列表
 
 */

+ (NSArray *)fetchMethodList:(Class)mClass;

/**
 获取协议列表
 
 @param mClass 相应类
 @return NSString :协议列表
 
 */
+ (NSArray *)fetchProtocolList:(Class)mClass;

/**
 往类动态添加新的方法和实现
 
 @param mClass 相应类
 @param methodSel 方法的名
 @param methodSelImp 对应方法实现的方法名
 
 */

+ (void)addMethod:(Class)mClass method:(SEL)methodSel methodImp:(SEL)methodSelImp;
/**
 方法交换
 
 @param mClass 相应类
 @param method1 被交换的方法
 @param method2 交换的方法
 
 */
+ (void)swapMethod:(Class)mClass currentMethod :(SEL)method1 targetMethod:(SEL)method2;
@end
