# KRuntime
about the runtime knowledge
感谢原作者  兴宇是谁 的分享

iOS~runtime理解

Runtime是想要做好iOS开发，或者说是真正的深刻的掌握OC这门语言所必需理解的东西。最近在学习Runtime，有自己的一些心得，整理如下，
一为 查阅方便
二为 或许能给他人一些启发，
三为 希望得到大家对这篇整理不足之处的一些指点。
什么是Runtime
我们写的代码在程序运行过程中都会被转化成runtime的C代码执行，例如[target doSomething];会被转化成objc_msgSend(target, @selector(doSomething));。
OC中一切都被设计成了对象，我们都知道一个类被初始化成一个实例，这个实例是一个对象。实际上一个类本质上也是一个对象，在runtime中用结构体表示。
相关的定义：
/// 描述类中的一个方法
typedef struct objc_method *Method;

/// 实例变量
typedef struct objc_ivar *Ivar;

/// 类别Category
typedef struct objc_category *Category;

/// 类中声明的属性
typedef struct objc_property *objc_property_t;
类在runtime中的表示
//类在runtime中的表示
struct objc_class {
Class isa;//指针，顾名思义，表示是一个什么，
//实例的isa指向类对象，类对象的isa指向元类

#if !__OBJC2__
Class super_class;  //指向父类
const char *name;  //类名
long version;
long info;
long instance_size
struct objc_ivar_list *ivars //成员变量列表
struct objc_method_list **methodLists; //方法列表
struct objc_cache *cache;//缓存
//一种优化，调用过的方法存入缓存列表，下次调用先找缓存
struct objc_protocol_list *protocols //协议列表
#endif
} OBJC2_UNAVAILABLE;
/* Use `Class` instead of `struct objc_class *` */
获取列表
有时候会有这样的需求，我们需要知道当前类中每个属性的名字（比如字典转模型，字典的Key和模型对象的属性名字不匹配）。
我们可以通过runtime的一系列方法获取类的一些信息（包括属性列表，方法列表，成员变量列表，和遵循的协议列表）。

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
在Xcode上跑一下看看输出吧，需要给你当前的类写几个属性，成员变量，方法和协议，不然获取的列表是没有东西的。
注意，调用这些获取列表的方法别忘记导入头文件#import <objc/runtime.h>。

方法调用
让我们看一下方法调用在运行时的过程（参照前文类在runtime中的表示）

如果用实例对象调用实例方法，会到实例的isa指针指向的对象（也就是类对象）操作。
如果调用的是类方法，就会到类对象的isa指针指向的对象（也就是元类对象）中操作。

首先，在相应操作的对象中的缓存方法列表中找调用的方法，如果找到，转向相应实现并执行。
如果没找到，在相应操作的对象中的方法列表中找调用的方法，如果找到，转向相应实现执行
如果没找到，去父类指针所指向的对象中执行1，2.
以此类推，如果一直到根类还没找到，转向拦截调用。
如果没有重写拦截调用的方法，程序报错。
以上的过程给我带来的启发：

重写父类的方法，并没有覆盖掉父类的方法，只是在当前类对象中找到了这个方法后就不会再去父类中找了。
如果想调用已经重写过的方法的父类的实现，只需使用super这个编译器标识，它会在运行时跳过在当前的类对象中寻找方法的过程。
拦截调用
在方法调用中说到了，如果没有找到方法就会转向拦截调用。
那么什么是拦截调用呢。
拦截调用就是，在找不到调用的方法程序崩溃之前，你有机会通过重写NSObject的四个方法来处理。

+ (BOOL)resolveClassMethod:(SEL)sel;
+ (BOOL)resolveInstanceMethod:(SEL)sel;
//后两个方法需要转发到其他的类处理
- (id)forwardingTargetForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)anInvocation;
第一个方法是当你调用一个不存在的类方法的时候，会调用这个方法，默认返回NO，你可以加上自己的处理然后返回YES。
第二个方法和第一个方法相似，只不过处理的是实例方法。
第三个方法是将你调用的不存在的方法重定向到一个其他声明了这个方法的类，只需要你返回一个有这个方法的target。
第四个方法是将你调用的不存在的方法打包成NSInvocation传给你。做完你自己的处理后，调用invokeWithTarget:方法让某个target触发这个方法。
动态添加方法
重写了拦截调用的方法并且返回了YES，我们要怎么处理呢？
有一个办法是根据传进来的SEL类型的selector动态添加一个方法。

首先从外部隐式调用一个不存在的方法：

//隐式调用方法
[target performSelector:@selector(resolveAdd:) withObject:@"test"];
然后，在target对象内部重写拦截调用的方法，动态添加方法。

void runAddMethod(id self, SEL _cmd, NSString *string){
NSLog(@"add C IMP ", string);
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{

//给本类动态添加一个方法
if ([NSStringFromSelector(sel) isEqualToString:@"resolveAdd:"]) {
class_addMethod(self, sel, (IMP)runAddMethod, "v@:*");
}
return YES;
}
其中class_addMethod的四个参数分别是：

Class cls 给哪个类添加方法，本例中是self
SEL name 添加的方法，本例中是重写的拦截调用传进来的selector。
IMP imp 方法的实现，C方法的方法实现可以直接获得。如果是OC方法，可以用+ (IMP)instanceMethodForSelector:(SEL)aSelector;获得方法的实现。
"v@:*"方法的签名，代表有一个参数的方法。
关联对象
现在你准备用一个系统的类，但是系统的类并不能满足你的需求，你需要额外添加一个属性。
这种情况的一般解决办法就是继承。
但是，只增加一个属性，就去继承一个类，总是觉得太麻烦类。
这个时候，runtime的关联属性就发挥它的作用了。

//首先定义一个全局变量，用它的地址作为关联对象的key
static char associatedObjectKey;
//设置关联对象
objc_setAssociatedObject(target, &associatedObjectKey, @"添加的字符串属性", OBJC_ASSOCIATION_RETAIN_NONATOMIC); //获取关联对象
NSString *string = objc_getAssociatedObject(target, &associatedObjectKey);
NSLog(@"AssociatedObject = %@", string);
objc_setAssociatedObject的四个参数：

id object给谁设置关联对象。
const void *key关联对象唯一的key，获取时会用到。
id value关联对象。
objc_AssociationPolicy关联策略，有以下几种策略：
enum {
OBJC_ASSOCIATION_ASSIGN = 0,
OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, 
OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
OBJC_ASSOCIATION_RETAIN = 01401,
OBJC_ASSOCIATION_COPY = 01403 
};
如果你熟悉OC，看名字应该知道这几种策略的意思了吧。

objc_getAssociatedObject的两个参数。

id object获取谁的关联对象。
const void *key根据这个唯一的key获取关联对象。
其实，你还可以把添加和获取关联对象的方法写在你需要用到这个功能的类的类别中，方便使用。

//添加关联对象
- (void)addAssociatedObject:(id)object{
objc_setAssociatedObject(self, @selector(getAssociatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//获取关联对象
- (id)getAssociatedObject{
return objc_getAssociatedObject(self, _cmd);
}
注意：这里面我们把getAssociatedObject方法的地址作为唯一的key，_cmd代表当前调用方法的地址。

方法交换
方法交换，顾名思义，就是将两个方法的实现交换。例如，将A方法和B方法交换，调用A方法的时候，就会执行B方法中的代码，反之亦然。
话不多说，这是参考Mattt大神在NSHipster上的文章自己写的代码。

#import "UIViewController+swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (swizzling)

//load方法会在类第一次加载的时候被调用
//调用的时间比较靠前，适合在这个方法里做方法交换
+ (void)load{
//方法交换应该被保证，在程序中只会执行一次
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{

//获得viewController的生命周期方法的selector
SEL systemSel = @selector(viewWillAppear:);
//自己实现的将要被交换的方法的selector
SEL swizzSel = @selector(swiz_viewWillAppear:);
//两个方法的Method
Method systemMethod = class_getInstanceMethod([self class], systemSel);
Method swizzMethod = class_getInstanceMethod([self class], swizzSel);

//首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
if (isAdd) {
//如果成功，说明类中不存在这个方法的实现
//将被交换方法的实现替换到这个并不存在的实现
class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
}else{
//否则，交换两个方法的实现
method_exchangeImplementations(systemMethod, swizzMethod);
}

});
}

- (void)swiz_viewWillAppear:(BOOL)animated{
//这时候调用自己，看起来像是死循环
//但是其实自己的实现已经被替换了
[self swiz_viewWillAppear:animated];
NSLog(@"swizzle");
}

@end
在一个自己定义的viewController中重写viewWillAppear

- (void)viewWillAppear:(BOOL)animated{
[super viewWillAppear:animated];
NSLog(@"viewWillAppear");
}
Run起来看看输出吧！

我的理解：

方法交换对于我来说更像是实现一种思想的最佳技术：AOP面向切面编程。
既然是切面，就一定不要忘记，交换完再调回自己。
一定要保证只交换一次，否则就会很乱。
最后，据说这个技术很危险，谨慎使用。
完
推荐拓展阅读
著作权归作者所有

