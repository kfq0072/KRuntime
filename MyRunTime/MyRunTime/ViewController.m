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
#import "GetIMP.h"
#import "Tools.h"


@interface ViewController () {
    BOOL _flag;
}
- (IBAction)BtnAction:(id)sender;
@property (nonatomic, copy)NSArray *myArray;
@property (nonatomic, strong)NSString *str1;
@property (nonatomic, weak)NSString *str2;
@end

@implementation ViewController
- (void)testPoint:(NSString*)str {
    
}
- (void)testPoint {
    char *p;
    NSLog(@"指针长度： %ld",sizeof(p));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GetIMP *kIMP = [[GetIMP alloc] init];
    
    [self testPoint];
    
    _str1 = [[NSString alloc] initWithUTF8String:"string 1"];;
    _str2 = _str1;
    _str1 = nil;
    NSLog(@"%@",_str2);//当str2为weak时，_str1为创建堆内存，_str2为null
    [self testRuntimeCategroy];
    [self performSelectorOnMainThread:@selector(myVCFunction:) withObject:@"dy" waitUntilDone:NO];
       // Do any additional setup after loading the view, typically from a nib.
}
- (void)testInitialize {
    Person * a = [Person new];
    Son *s = [Son new];
}

- (void)testRuntimeCategroy {
    Son *s = [Son new];
    s.name = @"hello categroy";
    NSLog(@"categroy property:%@",s.name);
}
-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//对应的类方法
+(BOOL)resolveClassMethod:(SEL)sel {
    return YES;
}
//1.对应的实例方法
+(BOOL)resolveInstanceMethod:(SEL)sel {
    //可以动态指向另外一个方法
    if (sel == @selector(myVCFunction:)) {
        class_addMethod([self class], sel, (IMP)dynamic_show, "v@:@");
         return YES;
    }
    return [super resolveInstanceMethod:sel];
   
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


- (IBAction)BtnAction:(id)sender {

    NSArray *iVars = [Tools getClassIVarNames:[self class]];
    NSLog(@"成员变量列表:%@",iVars);
    
    NSArray *methodLists = [Tools getClassMethodList:[self class]];
    NSLog(@"方法列表:%@",methodLists);
    
    NSArray *proLists = [Tools getClassPropertyList:[self class]];
    NSLog(@"属性列表:%@",proLists);
    
    NSArray *protocolLists = [Tools getClassProtocolList:[self class]];
    NSLog(@"协议列表:%@",protocolLists);
    
}

-(void)dealloc {
    
}
@end
