//
//  Son+BB.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/13.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "Son+BB.h"
#import <objc/runtime.h>

NSString const * kExposeController = @"exposeController";//随意一个标志

@implementation Son (BB)

-(void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &kExposeController, name, OBJC_ASSOCIATION_COPY);
//    objc_removeAssociatedObjects(name);//移除关联
}
-(NSString *)name {
    return objc_getAssociatedObject(self, &kExposeController);
}
@end
