//
//  AddNewViewController.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/22.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "AddNewViewController.h"
#import "Tools.h"
#import <objc/runtime.h>


@interface AddNewViewController(){

}
@end

@implementation AddNewViewController
-(void)viewDidLoad {

}

- (IBAction)BtnAction:(id)sender {
    Class tmpClass = [self testAllocateClassPair];
    id instance = [[tmpClass alloc] init];
    NSLog(@"新增对象：%@",instance);

    NSArray *iVars = [Tools getClassIVarNames:[instance class]];
    NSLog(@"成员变量列表:%@",iVars);
    
    NSArray *methodLists = [Tools getClassMethodList:[instance class]];
    NSLog(@"方法列表:%@",methodLists);
    
    NSArray *proLists = [Tools getClassPropertyList:[instance class]];
    NSLog(@"属性列表:%@",proLists);
    
    NSArray *protocolLists = [Tools getClassProtocolList:[instance class]];
    NSLog(@"协议列表:%@",protocolLists);
    
}


- (void)testInstance {
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
    class_addMethod(kclass, @selector(setFatherName:), (IMP)setFatherName, "v@:@");
    class_addMethod(kclass, @selector(getFatherName), (IMP)getFatherName, "v@:");
    
    //TODO:添加协议
//    class_addProtocol(kclass, <#Protocol *protocol#>)
    objc_registerClassPair(kclass);
    
    return kclass;
    
}

static void setFatherName(id self,SEL cmd,id value) {
    NSLog(@"call setFatherName");
}
static void getFatherName(id self,SEL cmd) {
    NSLog(@"call setFatherName");
}
@end
