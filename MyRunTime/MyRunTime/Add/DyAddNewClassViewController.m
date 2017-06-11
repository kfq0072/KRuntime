//
//  AddNewViewController.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/22.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "DyAddNewClassViewController.h"
#import "RuntimeKit.h"
#import <objc/runtime.h>

@protocol FatherProtocol <NSObject>

- (void)testFatherProtocol;

@end

@interface DyAddNewClassViewController(){

}
@end

@implementation DyAddNewClassViewController

-(void)viewDidLoad {

}

- (IBAction)BtnAction:(id)sender {
    Class tmpClass = [self testAllocateClassPair];
    id instance = [[tmpClass alloc] init];
    NSLog(@"新增对象：%@",instance);

    Class class = [instance class];
    NSLog(@"className: %@",[RuntimeKit fetchClassName:class]);
    NSLog(@"IvarList: %@",[RuntimeKit fetchIvarList:class]);
    NSLog(@"fetchPropertyList:%@",[RuntimeKit fetchPropertyList:class]);
    NSLog(@"fetchMethodList:%@",[RuntimeKit fetchMethodList:class]);
    NSLog(@"fetchProtocolList:%@",[RuntimeKit fetchProtocolList:class]);
    
}

- (Class)testAllocateClassPair {
    const char * className = "Father";
    Class kclass = objc_getClass(className);
    if (!kclass) {
        Class superClass = [NSObject class];
        kclass = objc_allocateClassPair(superClass, className, 0);
    }

    //添加成员变量
    NSUInteger size;
    NSUInteger alignment;
    NSGetSizeAndAlignment("*", &size, &alignment);
    class_addIvar(kclass, "_family", size, alignment, "*");
    
    //添加属性
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "C", "" }; // C = copy
    objc_property_attribute_t backingivar  = { "V", "kfq" };
    objc_property_attribute_t attrs[] = {type, ownership, backingivar };
    class_addProperty(kclass, "name", attrs, 3);
    
    //添加方法
    class_addMethod(kclass, @selector(setNoParamFunction), (IMP)setNoParamFunction, "v@:");
//    class_addMethod(kclass, @selector(setOneParamFunction:), (IMP)setOneParamFunction, "v@:@");
    [RuntimeKit addMethod:kclass method:@selector(setOneParamFunction:) methodImp:@selector(setOneParamFunction:)];
    //TODO:添加协议
//    class_addProtocol(kclass, fatherp)
    objc_registerClassPair(kclass);
    
    return kclass;
    
}

static void setOneParamFunction(id self,SEL cmd,id value) {
    NSLog(@"call setOneParamFunction");
}
static void setNoParamFunction(id self,SEL cmd) {
    NSLog(@"call setNoParamFunction");
}
@end
