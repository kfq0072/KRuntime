//
//  LoadFramework.m
//  MyRunTime
//
//  Created by kefoqing on 16/9/21.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import "LoadFramework.h"
#define  DocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define  FrameworkPath [DocumentDirectory stringByAppendingPathComponent:@"Framework"]
@interface LoadFramework() {
   
}
@property (nonatomic, strong) NSMutableArray *libSuccessLoadArray;
@end
@implementation LoadFramework

- (NSMutableArray*)onLoadFramewrok {
     NSArray * fwList = [self getFramewrokArray];
    __weak typeof(self) weakSelf = self;
    [fwList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf loadFramewrokWithName:obj];
    }];
    return self.libSuccessLoadArray;
}

- (id)onActiveFrameworkClass :(id)obj {
    Class pacteraClass = NSClassFromString(obj);
    if (!pacteraClass) {
        NSLog(@"Unable to get TestDylib class");
        return nil;
    }
    /*
     *初始化方式采用下面的形式
     　alloc　init的形式是行不通的
     　同样，直接使用PacteraFramework类初始化也是不正确的
     *通过- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
     　方法调用入口方法（showView:withBundle:），并传递参数（withObject:self withObject:frameworkBundle）
     */
    NSObject *pacteraObject = [pacteraClass new];
    return pacteraObject;
}

- (NSArray*)getFramewrokArray {
    NSString *frameworkPath = [DocumentDirectory stringByAppendingPathComponent:@"Framework"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:frameworkPath]) {
        [fileManager createDirectoryAtPath:frameworkPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"frameworkPath:%@",frameworkPath);
    NSArray * fwList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:frameworkPath error:nil]];
    return fwList;
}

- (BOOL)loadFramewrokWithName:(NSString*)libName {
    NSError *error = nil;
    NSString *libPath = [FrameworkPath stringByAppendingPathComponent:libName];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:libPath];
    if (frameworkBundle && [frameworkBundle load]) {
        NSLog(@"bundle load framework success.");
        
        [self.libSuccessLoadArray addObject:[self deleteFrameworkType:libName]];
        return YES;
    }else {
        NSLog(@"bundle load framework err:%@",error);
        return NO;
    }
}
-(NSMutableArray *)libSuccessLoadArray {
    if (_libSuccessLoadArray == nil) {
        _libSuccessLoadArray = [NSMutableArray new];
    }
    return _libSuccessLoadArray;
}

- (NSMutableArray*)activeClass {
    NSMutableArray *instanceArray = [NSMutableArray new];
    /*
     *通过NSClassFromString方式读取类
     *PacteraFramework　为动态库中入口类
     */
    [_libSuccessLoadArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class pacteraClass = NSClassFromString(obj);
        if (!pacteraClass) {
            NSLog(@"Unable to get TestDylib class");
            return;
        }
        /*
         *初始化方式采用下面的形式
         　alloc　init的形式是行不通的
         　同样，直接使用PacteraFramework类初始化也是不正确的
         *通过- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
         　方法调用入口方法（showView:withBundle:），并传递参数（withObject:self withObject:frameworkBundle）
         */
        NSObject *pacteraObject = [pacteraClass new];
        [instanceArray addObject:pacteraObject];
        
    }];
    return instanceArray;
}

- (NSString*)deleteFrameworkType:(NSString*)file {
    NSString *reslut = file;
    if ([file containsString:@"."]) {
        NSArray *array =  [file componentsSeparatedByString:@"."];
        if ( [array count] > 0) {
            reslut = array[0];
        }
    }
    return reslut;
}
@end
