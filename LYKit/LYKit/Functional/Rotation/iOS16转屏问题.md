### 1、在iOS16上使用下面的代码强制转屏，会报下面的错**[Orientation] BUG IN CLIENT OF UIKIT: Setting UIDevice.orientation is not supported. Please use UIWindowScene.requestGeometryUpdate(_:)**

```objective-c
        [[UIApplication sharedApplication] setStatusBarOrientation: isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
        //隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self prefersStatusBarHidden];
        //设置横屏
         NSNumber *orientationTarget = [NSNumber numberWithInt:isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
         [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
```



#### 解决方案：对于iOS16及以上的系统使用下面方法进行转屏

```objective-c
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *ws = (UIWindowScene *)array[0];
        UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] init];
        geometryPreferences.interfaceOrientations = isLandscape ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
        [ws requestGeometryUpdateWithPreferences:geometryPreferences
            errorHandler:^(NSError * _Nonnull error) {
            //业务代码
        }];
    }
```





### 2、在iOS 16中转屏的时候，直接获取设备方向：UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;将返回UIDeviceOrientationUnknown？



#### 解决方案：在iOS16及以上用以下方法获取方向

```objective-c
BOOL isLandscape = NO;
if (@available(iOS 16.0, *)) {
        
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *ws = (UIWindowScene *)array[0];
        
        if(ws.interfaceOrientation == UIInterfaceOrientationPortrait || ws.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            isLandscape = NO;
        } else {
            isLandscape = YES;
        }
    }
```



### 3、在强制转屏后，控制器的view.frame不正确，监听self.view.frame的变化打印如下

```shell
{
  kind = 1;
  new = "NSRect: {{0, 97.666666666666657}, {852, 0}}";
}
```



#### 解决方案：在\- (**void**)viewWillLayoutSubviews 方法中重新设置self.view.frame的值

```objective-c
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;

    if (isLandscape) {
        self.view.frame = CGRectMake(x, y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } else {
        self.view.frame = CGRectMake(x, y, w, h);
    }
}
```

