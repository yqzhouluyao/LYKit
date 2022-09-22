//
//  LYKitTests.m
//  LYKitTests
//
//  Created by zhouluyao on 2022/9/22.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYCalculatorTool.h"
#import "LYNetworkRequest.h"

//对于每一个业务类，我们都会有一个对应的测试类，所有的测试类需要继承XCTestCase
@interface LYKitTests : XCTestCase <LYNetworkRequestDelegate> {
    XCTestExpectation *_expectation;
}

@end

@implementation LYKitTests
// setUp方法会在XCTestCase的测试方法每次调用之前调用，所以可以把一些测试代码需要用的初始化代码和全局变量写在这个方法里;
- (void)setUp {
   [super setUp];
}
//在每个单元测试方法执行完毕后，XCTest会执行tearDown方法，把需要测试完成后销毁的内容写在这个里，以便保证下面的测试不受本次测试影响
- (void)tearDown {
   [super tearDown];
}
//用XCTAssert 和函数去验证测试用例和正确的结果,测试的函数以test开头
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//运算测试
- (void)testAdd {
    int result = [LYCalculatorTool add:1 b:1];
    XCTAssertEqual(result, 2);
    
    int result2 = [LYCalculatorTool add:3 b:0];
    XCTAssertEqual(result2, 3);
    
    double result3 = [LYCalculatorTool devide:4 b:2];
    XCTAssertEqual(result3, 2);
    
    double result4 = [LYCalculatorTool devide:4 b:0];
    XCTAssertEqual(result4, 0);
    
}
//网络测试
- (void)testHttpRequest {
    XCTWaiter *waiter = [[XCTWaiter alloc] initWithDelegate:self];
    _expectation = [[XCTestExpectation alloc] initWithDescription:@"请求百度首页数据"];
    
    // 发起网络请求
    LYNetworkRequest *http = [[LYNetworkRequest alloc] init];
    http.delegate = self;
    [http fetchUrl];
    
    // 等待3秒, 如果expectation满足期望（既调用：[_expectation fulfill]）, 则继续往下执行
    [waiter waitForExpectations:@[_expectation] timeout:3];
}

// 代理回调: 网络返回
- (void)http:(LYNetworkRequest *)http receiveData:(NSData *)data error:(NSError *)error {
    
    XCTAssertNotNil(data, @"网络无响应");
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"dataStr:%@", dataStr);  // XML数据, 这里没进行解析
    
    [_expectation fulfill];     // 结束等待
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
