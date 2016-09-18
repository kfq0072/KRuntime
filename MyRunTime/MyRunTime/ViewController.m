//
//  ViewController.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/13.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"
#import "Son.h"
#import "Son+BB.h"
#import "ExchangeViewController.h"

@interface ViewController () {
    BOOL _flag;
}
- (IBAction)BtnAction:(id)sender;
@property (nonatomic, copy)NSArray *myArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testRuntimeCategroy];
    [self performSelectorOnMainThread:@selector(myVCFunction:) withObject:@"dy" waitUntilDone:NO];
}
- (void)testInitialize {
    Person * a = [Person new];
    Son *s = [Son new];
}

#pragma mark - 测试runtime 对象关联
- (void)testRuntimeCategroy {
    Son *s = [Son new];
    s.name = @"hello categroy";
    NSLog(@"categroy property:%@",s.name);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 测试runtime消息转发
//对应的类方法
+(BOOL)resolveClassMethod:(SEL)sel {
    return YES;
}
//1.对应的实例方法
+(BOOL)resolveInstanceMethod:(SEL)sel {
    //可以动态指向另外一个方法
    if (sel == @selector(myVCFunction:)) {
//        class_addMethod([self class], sel, (IMP)dynamic_show, "v@:@");
    }
    return YES;
}

//2.转给目标target，这个对象执行aSelector方法
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [ExchangeViewController new];
}
//3.尝试获得一个方法签名。如果获取不到，则直接调用doesNotRecognizeSelector抛出异常。如果能获取，则返回非nil：创建一个 NSlnvocation 并传给forwardInvocation:
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [ExchangeViewController instanceMethodSignatureForSelector:aSelector];
}
//4.调用forwardInvocation:方法，将第3步获取到的方法签名包装成 Invocation 传入，如何处理就在这里面了，并返回非ni
-(void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = [anInvocation selector];
    ExchangeViewController *myVC = [ExchangeViewController new];
    if ([myVC respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:myVC];
    }else {
        [super forwardInvocation:anInvocation];
    }
}
-(void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%s",__FUNCTION__);
}

//自定义动态方法
void dynamic_show(id self ,SEL _cmd,id param1) {
    NSLog(@"动态添加方法:%@",param1);
}

#pragma mark - runtime 相关类的操作
- (IBAction)BtnAction:(id)sender {
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    
    //获取方法列表
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
    }
    
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }

}

@end
