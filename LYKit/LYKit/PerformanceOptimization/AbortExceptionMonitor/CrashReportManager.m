//
//  CrashReportManager.m
//  LYKit
//
//  Created by zhouluyao on 4/7/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "CrashReportManager.h"
#import "WPFMetricKitManager.h"
#import "HadesAbortMetricRootFrame.h"

@interface CrashReportManager ()

@property (nonatomic, strong) NSString *subscribeID;

@end

@implementation CrashReportManager

+ (instancetype)sharedManager {
    static CrashReportManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CrashReportManager alloc] init];
    });
    return instance;
}


- (void)subscribeToCrashReports {
    if (@available(iOS 14.0, *)) {
        __weak typeof(self) weakSelf = self;
        self.subscribeID = [WPFMetricKitManager addSubscriber:^(NSArray * _Nonnull payload, WPFMetricPayloadType type) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (type == WPFMetricPayloadTypeDiagnostic) {
                [strongSelf handleDiagnosticPayloads:payload];
            }
        }];
    }
}

- (void)unsubscribeFromCrashReports {
    if (@available(iOS 14.0, *)) {
        [WPFMetricKitManager removeSubscriber:self.subscribeID];
    }
}

//当触发崩溃时，App未捕获到异常而终止，为了获取崩溃数据，您需要等待崩溃后的下一次启动获取
//该方法将在下一次应用程序启动时调用，MetricKit 框架会提供来自先前应用程序会话的崩溃数据。
//MetricKit 每天提供一次诊断有效负载，因此您可能不会在重新启动应用程序后立即看到崩溃数据。
//想要测试可以在底部菜单栏，Debug->Simulator MetricKit Payloads 触发
- (void)handleDiagnosticPayloads:(NSArray *)payloads API_AVAILABLE(ios(14.0)) {
    
    for (id payload in payloads) {
        // Ensure the payload is an MXDiagnosticPayload
        if ([payload isKindOfClass:[MXDiagnosticPayload class]]) {
            MXDiagnosticPayload *diagnosticPayload = (MXDiagnosticPayload *)payload;
            
            for (MXCrashDiagnostic *diagnostic in diagnosticPayload.crashDiagnostics) {
                // Check if the diagnostic is a crash diagnostic
                if ([diagnostic isKindOfClass:[MXCrashDiagnostic class]]) {
                    // Extract the crash data and process it
                    NSDictionary *crashData = [self extractCrashData:diagnostic];
                    [self processCrashDataAndUpload:crashData];
                }
            }
        }else if ([payload isKindOfClass:[MXMetricPayload class]]) {
            MXMetricPayload *metricPayload = (MXMetricPayload *)payload;
            // Process the metric payload here
            [self processMetricPayload:metricPayload];
        }
    }
}




- (NSDictionary *)extractCrashData:(MXDiagnostic *)diagnostic  API_AVAILABLE(ios(14.0)){
    MXCrashDiagnostic *crashDiagnostic = (MXCrashDiagnostic *)diagnostic;
    
    NSMutableDictionary *crashData = [NSMutableDictionary dictionary];
    
    // Extract relevant data from the crashDiagnostic object
    crashData[@"callStackTree"] = crashDiagnostic.callStackTree.JSONRepresentation;
    crashData[@"applicationVersion"] = crashDiagnostic.applicationVersion;
    crashData[@"terminationReason"] = crashDiagnostic.terminationReason;
    
    // Add any other required fields from crashDiagnostic
    
    return crashData;
}

- (void)processMetricPayload:(MXMetricPayload *)metricPayload  API_AVAILABLE(ios(13.0)){
    // Handle the metric payload data as needed
}

- (void)processCrashDataAndUpload:(NSDictionary *)crashData {
    // Build a dictionary with the necessary information
    NSMutableDictionary *processedCrashData = [NSMutableDictionary dictionaryWithDictionary:crashData];

    // Add the missing information, such as the SDK version, APP version, and device unique identifier deviceId
    processedCrashData[@"sdkVersion"] = @"1.0.0";
    processedCrashData[@"app"] = @{@"channel": @"appstore", @"version": @"3.2.96"};
    processedCrashData[@"device"] = @{@"deviceId": @"xxxx-xxx-xxx",
                                      @"systemVersion": @"",
                                      @"kernelVersion": @"",
                                      @"manufacturer": @"Apple",
                                      @"brand": @"iPhone",
                                      @"model": crashData[@"device"][@"model"],
                                      @"cpu": crashData[@"device"][@"cpu"]};

    // Process HadesAbortMetricRootFrame instances and generate the upload format string
    NSArray *rootFrames = crashData[@"rootFrames"];
    NSMutableArray *uploadFormatStrings = [NSMutableArray arrayWithCapacity:rootFrames.count];

    for (NSDictionary *frameData in rootFrames) {
        HadesAbortMetricRootFrame *frame = [[HadesAbortMetricRootFrame alloc] initWithDictionary:frameData];
        NSString *uploadFormatString = [frame uploadFormatString];
        [uploadFormatStrings addObject:uploadFormatString];
    }

    processedCrashData[@"uploadFormatStrings"] = uploadFormatStrings;

    // Upload the processed crash data to your server
    [self uploadCrashDataToServer:processedCrashData];
}

- (void)uploadCrashDataToServer:(NSDictionary *)crashData {
    // Convert the crash data dictionary to JSON data
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:crashData options:0 error:&error];

    if (!jsonData) {
        NSLog(@"Error converting crash data to JSON: %@", error);
        return;
    }

    // Set up the URL and the request
    NSURL *url = [NSURL URLWithString:@"https://yourserver.com/api/crash_reports"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = jsonData;

    // Send the request
    NSURLSessionDataTask *uploadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error uploading crash data: %@", error);
        } else {
            NSLog(@"Crash data uploaded successfully");
        }
    }];

    [uploadTask resume];
}



@end
