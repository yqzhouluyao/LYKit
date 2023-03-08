### CTMediator总共有3部分组成：



#### 1、CTMediator类，负责中心调度

主要通过Target-Action实现组件化解耦的，功能独立，不依赖任何组件



##### a.利用runtime进行反射，将类字符串和方法字符串，转换成对应的类的SEL方法

```objective-c
SEL action = NSSelectorFromString(@"Action_response:");
NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
[target performSelector:action withObject:params];
```

##### b.将消息和消息接收者封装成一个对象，首先利用target-action生成方法签名，创建NSInvocation对象进行invoke。

```objective-c
NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
if(methodSig == nil) {
    return nil;
}
const char* retType = [methodSig methodReturnType];
if (strcmp(retType, @encode(void)) == 0) {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setArgument:&params atIndex:2];
    [invocation setSelector:action];
    [invocation setTarget:target];
    [invocation invoke];
    return nil;
}
```



#### 2、组件对外提供服务的类Target_QuestionKit，向外暴露组件能够提供哪些服务接口，Target_QuestionKit是依赖组件的，属于组件的一部分，它的本质就是对外业务的一层服务化封装。

```objective-c
@interface Target_QuestionKit : NSObject
- (UIViewController *)questionKitViewController;
@end
```



```objective-c
@implementation Target_QuestionKit
- (UIViewController *)questionKitViewController {
  NSString *name = @"QuestionKitViewController";
  Class cls = NSClassFromString(name);
  UIViewController *vc = [[cls alloc] init];
  return vc;
}
@end
```



#### 3、CTMediator+(QuestionKit)分类：里面声明了可以调用的组件接口，其他业务模块想要调用QuestionKit模块的功能，只需要引入CTMediator+(QuestionKit)分类即可调用，实现模块之前的解耦

```objective-c
- (UIViewController *)questionKitViewControllerWithCallback:(void(^)(NSString *result))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"callback"] = callback;
    return [self performTarget:@"QuestionKit" action:@"Category_ViewController" params:params shouldCacheTarget:NO];
}
```



##### 搞一个分类出来的目的就是方便其他模块在没有耦合的情况下调用另一个模块

我们继续编译A工程，发现找不到`BViewController`。由于我们这次组件化实施的目的仅仅是将A业务线抽出来，`BViewController`是属于B业务线的，所以我们没必要把B业务也从主工程里面抽出来,但为了能够让A工程编译通过，我们需要提供一个B_Category来使得A工程可以调度到B，同时也能够编译通过，这里A业务线跟B业务线就已经完全解耦了，跟主工程就也已经完全解耦了。



#### 先写分类，再写Target

所以先写category里的target名字，action名字，param参数，到后面在业务线组件中创建Target的时候，照着category里面已经写好的内容直接copy到Target对象中就肯定不会出错



#### 好处：

对于响应者来说，什么代码都不用改，只需要包一层Target-Action即可。例如本例中的B业务线作为A业务的响应者时，不需要修改B业务的任何代码。

对于调用者来说，只需要把调用方式换成CTMediator调用即可，其改动也不涉及原有的业务逻辑，所以是十分安全的。

独立出来一个，写一个，维护成本低。

没有任何注册的逻辑代码，避免了注册文件的维护和管理。
