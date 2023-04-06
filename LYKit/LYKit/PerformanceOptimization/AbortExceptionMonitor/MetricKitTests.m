//
//  MetricKitTests.m
//  LYKitTests
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface MetricKitTests : XCTestCase

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation MetricKitTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.appDelegate = [[AppDelegate alloc] init];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSubscribeMetricData {
    XCTAssertNil(self.appDelegate.subscribeID, @"Subscribe ID should be nil before subscribing");
    
    [self.appDelegate subscribeMetricData];
    
    XCTAssertNotNil(self.appDelegate.subscribeID, @"Subscribe ID should not be nil after subscribing");
}


@end
