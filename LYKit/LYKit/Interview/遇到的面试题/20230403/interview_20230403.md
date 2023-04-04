### 一、Output the print result of the following code and analyze the reason

```c
#include <stdio.h>
int main() {
    int a[5] = {1, 2, 3, 4, 5};
    int *ptr = (int *)(&a + 1);
    printf("%d, %d", *(a + 1), *(ptr + 1));
    return 0;
}
```

#### *ptr 代表啥？

##### &a 是数组 a 的地址，(&a + 1)就是数组的地址+sizeof(数组)，ptr就是移动到数组内存后面的位置,此时ptr指向数组最后一个元素之后的内存位置。

##### 访问 *(ptr + 1) 会导致读取超出数组边界的内存。这是未定义的行为，可能会导致崩溃或不可预测的输出。



#### *(a + 1)是啥？

##### a代表数字的首元素，a+1,救赎数组的第二个元素，*(a + 1) 等同于 a[1]，即 2。









### 二、Please use the flow chart to describe the process of a viewController from initialization to presentation on the screen in as much detail as possible？In what scenarios has loadView been used?

1、初始化，创建 UIViewController 的实例，例如，[[MyViewController alloc] init]

2、loadView,当您需要以编程方式创建视图层次结构而不是使用 Interface Builder 或故事板时，您通常会覆盖 loadView。

3、viewDidLoad 加载视图后（通过 loadView 或从故事板加载），将调用 viewDidLoad 方法。

4、viewWillAppear，行每次视图出现时应完成的任何任务，例如刷新数据或更新 UI。

5、更新视图布局， 视图控制器的视图布局被更新以匹配屏幕尺寸和方向。

 viewWillLayoutSubviews 在布局过程开始之前被调用。

 viewDidLayoutSubviews 在布局过程完成后被调用。

6、viewDidAppear

 

#### loadView何时调用？

loadView 方法通常用于需要以编程方式创建视图层次结构而不是使用 Interface Builder 或故事板的场景。

当你覆盖 loadView 时，你应该在方法中创建根视图和整个视图层次结构，然后将根视图分配给 self.view。



### 三、Output the print result of the following code and analyze the reason

```objective-c
#import <Foundation/Foundation.h>

@interface Father : NSObject
@end

@implementation Father
@end

@interface Son : Father
- (id)init;
@end

@implementation Son
- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Son *son = [[Son alloc] init];
    }
    return 0;
}
```

#### 打印结果：

Son

Son

#### 分析原因：

1、使用 [[Son alloc] init] 创建了 Son Class的一个实例。 当调用Son类的init方法时，self指向了Son Class的一个实例。因此，[self class] 返回 Son 类，第一个 NSLog 打印“Son”。

2、第二个 NSLog 打印 [super class]，由于 super 是 Father Class的一个实例，因此可能会期望它打印“Father”。

然而，由于 Objective-C 运行时的工作方式，调用 [super class] 等同于调用 [self class]。

这是因为Father类中没有重写类方法，Objective-C运行时会使用NSObject类中的方法来判断对象的类,Son 类没有覆盖类方法，因此运行时将在其超类 Father 中查找方法实现。

由于 Father 也没有覆盖类方法，运行时将继续在 NSObject 类中查找。 NSObject 中的类方法通过以对象为参数调用object_getClass 函数返回对象的类。

所以，当你调用[super class]时，objc_msgSendSuper函数最终会执行NSObject中的类方法，返回对象的类，而不是父类。在这种情况下，对象是 Son 类的一个实例，因此类方法返回 Son 类，并打印“Son”。





### 四、Output the print result of the following code and analyze the reason

```objective-c
#import <UIKit/UIKit.h>

@implementation YourViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:view];
    view.bounds = CGRectMake(10, 10, 150, 150);
    NSLog(@"1: %@", NSStringFromCGRect(view.frame));
    view.layer.anchorPoint = CGPointMake(0, 0);
    NSLog(@"2: %@", NSStringFromCGRect(view.frame));
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    NSLog(@"3: %@", NSStringFromCGRect(view.frame));
}

@end
```

1、当view.bounds设置为 (10, 10, 150, 150) 时，Frame的大小会更改为 {150, 150}，

但view.center保持不变（100 + 50*0.5 = 125），由于view.center最初是 (125, 125)，中心位置确定，Size为 {150, 150}，那view.origin为125 - 150 * 0.5 = 50，

当您更新bound时，frame.oringn会被调整以保持view.center不变，从而导致框架 {{50, 50}, {150, 150}}。



2、锚点的默认值是(0.5,0.5), 旋转、缩放或对视图应用任何其他变换，这些操作将围绕锚点执行，

当改变view.layer.anchorPoint，Frame被更新，使得新锚点在view.superView中的位置保持不变。

 {{50, 50}, {150, 150}}，此时的瞄点是（0.5，0.5）,现在要把这个锚点变成(0，0)，只能移动view的origin，因为此时锚点的位置是50 + 150 * 0.5 = 125;

origin移动到锚点位置0，0)，所以view.layer.anchorPoint = CGPointMake(0, 0);之后新的frame是 （125,125,150,150）



3、当view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);，在 x 轴和 y 轴上应用缩放因子为 2 的缩放变换后，视图的框架大小发生变化，宽度和高度加倍。但是，框架的原点与以前相同，位于 {125, 125}。缩放变换后的新帧是 {{125, 125}, {300, 300}}。



### 五、Output the print result of the following code and analyze the reason

```
- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(testFunc) withObject:nil afterDelay:0];
        NSLog(@"2");
    });
    NSLog(@"3");
}

- (void)testFunc {
    NSLog(@"4");
}
```



#### 打印结果：

3

1

2

#### 分析原因：

1、dispatch_async它是在指定队列异步执行的代码块，不会阻塞当前线程，所以先打印3

2、在全局队列中执行的后台线程按顺序执行，先输出1，再输出2

3、performSelector:withObject:afterDelay: 该方法在当前线程的runloop调度 testFunc 方法，由于当前线程是后台线程，没有run loop，testFunc 方法不会执行。



#### 如果想要testFunc执行应该如何处理？

```objc
[self performSelector:@selector(testFunc) withObject:nil afterDelay:0];
//切换到主线程的队列中执行
dispatch_async(dispatch_get_main_queue(), ^{
      [self performSelector:@selector(testFunc) withObject:nil afterDelay:0];
  });
```

  





### 六、Output the print result of the following code and analyze the reason

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        dispatch_sync(serialQueue, ^{
            NSLog(@"1");
        });
    });
    
    NSLog(@"2");
    
    dispatch_async(serialQueue, ^{
        NSLog(@"3");
    });
    
    NSLog(@"4");
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"5");
    });
    
    NSLog(@"6");
}
```



#### 打印结果：

2 

or

2 , 4

#### 分析原因：

1、dispatch_async 在 serialQueue中执行，不会阻塞主线程，所以会打印2

2、在第一个异步块内执行同步调度，串行队列将被阻塞，发生死锁，能不能打印4取决于发生死锁的时间

 



### 七、remove duplicate elements in linked list

```c++
#include <iostream>
#include <unordered_set>

struct Node {
    int data;
    Node* next;

    Node(int data) : data(data), next(nullptr) {}
};

//removeDuplicates 函数遍历链表，使用 unordered_set 跟踪唯一元素。如果遇到重复元素，它会通过更新前一个节点的下一个指针将其从列表中删除。
void removeDuplicates(Node* head) {
    if (head == nullptr) {
        return;
    }
   // unordered_set 是一个基于哈希表的容器，它以无特定顺序存储唯一元素
    std::unordered_set<int> uniqueElements;
  //我们创建一个指针 current，它最初指向链表的头部。我们将使用这个指针来遍历列表。
    Node* current = head;
  //我们创建一个指针 prev，它最初指向 nullptr。该指针将用于跟踪列表中的前一个节点。当我们删除重复元素时，我们需要它来更新下一个指针。
    Node* prev = nullptr;
   //我们开始一个循环，一直持续到当前指针到达链表的末尾
    while (current != nullptr) {
      //我们检查当前元素的数据是否不在 uniqueElements 集合中。 find 函数返回指向找到的元素的迭代器，如果未找到该元素，则返回 end()。如果当前元素的数据不在集合中，则意味着我们之前没有见过这个元素，它不是重复的
        if (uniqueElements.find(current->data) == uniqueElements.end()) {
            // This element hasn't been seen before, add it to the set
            uniqueElements.insert(current->data);
          //当我们在列表中向前移动时，我们将 prev 指针更新为当前节点。
            prev = current;
        } else {
            //如果当前元素的数据已经在 uniqueElements 集合中，则执行这部分代码，这意味着它是重复的
            prev->next = current->next;
        }
      //我们将当前指针移动到列表中的下一个节点以继续遍历。
        current = current->next;
    }
}

void printLinkedList(Node* head) {
    Node* current = head;
    while (current != nullptr) {
        std::cout << current->data << " ";
        current = current->next;
    }
    std::cout << std::endl;
}

int main() {
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);
    head->next->next->next = new Node(2);
    head->next->next->next->next = new Node(4);
    head->next->next->next->next->next = new Node(1);

    std::cout << "Original linked list: ";
    printLinkedList(head);

    removeDuplicates(head);

    std::cout << "Linked list after removing duplicates: ";
    printLinkedList(head);

    return 0;
}
```







### 八、Write a function to recursively delete all files under the specified path

```c++
#include <iostream>
#include <filesystem>
#include <stdexcept>

namespace fs = std::filesystem;

void deleteFilesRecursively(const fs::path& path) {
    if (!fs::exists(path)) {
        throw std::runtime_error("The specified path does not exist.");
    }

    if (fs::is_directory(path)) {
        for (const auto& entry : fs::directory_iterator(path)) {
            if (fs::is_directory(entry.path())) {
                deleteFilesRecursively(entry.path());
            } else if (fs::is_regular_file(entry.path())) {
                fs::remove(entry.path());
            }
        }
    } else {
        throw std::runtime_error("The specified path is not a directory.");
    }
}

int main() {
    try {
        fs::path path("path/to/your/directory");
        deleteFilesRecursively(path);
        std::cout << "All files under the specified path have been deleted." << std::endl;
    } catch (const std::runtime_error& e) {
        std::cerr << e.what() << std::endl;
    }

    return 0;
}

```

