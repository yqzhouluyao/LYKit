###  MGJRouter的url-block实现方案思路:

在路由中心维护着一张路由表，url为key, block为value。 注册路由表时，将key和value对应保存到路由表routes中 使用时，根据URL拿到对应的block进行执行。

```objective-c
- (NSMutableDictionary *)routes
{
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}
```



#### url-block方案注册： 

```objective-c
+ (void)load {
    [MGJRouter registerURLPattern:@"engineer://SportsPlanVC" toObjectHandler:^id(NSDictionary *routerParameters) {
        FZSportsPlanVC *planVC = [FZSportsPlanVC new];
        [planVC configContent:routerParameters[@"MGJRouterParameterUserInfo"][@"title"]];
        return planVC;
    }];
}
```



#### 获取

```objective-c
- (IBAction)mgj_goSportsPlanDetail:(UIButton *)sender {
    UIViewController *vc = [MGJRouter objectForURL:@"engineer://SportsPlanVC" withUserInfo:@{@"title":[sender currentTitle]}];
    [self.navigationController pushViewController:vc animated:YES];
}
```





### 蘑菇街的protocal-class实现方案思路

ModuleManager内维护着一张映射表，以protocol为key,以Class为Value。



#####  注册映射表

```objective-c
[ModuleManager registerClass:ClassA forProtocol:ProtocolA]
```



##### 使用映射表

```objective-c
[ModuleManager classForProtocol:ProtocolA]
```



#### protocal-class方案注册

```objective-c
+ (void)load {
    [[FZProtocolMediator sharedFZProtocolMediator] registerProtocol:NSProtocolFromString(@"FZModuleMineProtocol") forClass:[FZModuleMineProtocolImplete class]];
}
```

 

#### 获取

```objective-c
- (IBAction)protocol_class_goSportsPlanDetail:(UIButton *)sender {
    Class<FZModuleMineProtocol> class = [[FZProtocolMediator sharedFZProtocolMediator] classForProtocol:NSProtocolFromString(@"FZModuleMineProtocol")];
    UIViewController *vc = [class fetchSportsPlanVC:sender.currentTitle];
    [self.navigationController pushViewController:vc animated:YES];
}
```
