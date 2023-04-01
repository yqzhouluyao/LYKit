//
//  ImageProcessor.m
//  LYKit
//
//  Created by zhouluyao on 4/1/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

//用于在包含 OpenCV 标头之前临时取消定义 NO 宏，然后恢复其原始值。
//这样做是为了避免 Apple 定义的 NO 宏与 OpenCV 标头之间发生冲突。
// Store the original value of the 'NO' macro
#pragma push_macro("NO")
// Undefine the 'NO' macro to avoid conflicts with OpenCV headers
#undef NO
// Include OpenCV headers
#import <opencv2/opencv.hpp>
// Restore the original value of the 'NO' macro
#pragma pop_macro("NO")
// Your code using OpenCV goes here

#import "ImageProcessor.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>

@implementation ImageProcessor

//将 UIImage 转换为 OpenCV cv::Mat，创建一个与输入图像具有相同尺寸和类型的 cv::Mat
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4);
    //使用 CGBitmapContextCreate() 创建一个位图上下文，然后将输入图像绘制到上下文中。最后，它返回 cv::Mat
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                        // Width of bitmap
                                                    rows,                        // Height of bitmap
                                                    8,                           // Bits per component
                                                    cvMat.step[0],               // Bytes per row
                                                    colorSpace,                  // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

//OpenCV cv::Mat 转换为 UIImage。
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    //它使用来自 cv::Mat 的数据创建一个 CGDataProviderRef
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorSpace;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    //设置适当的颜色空间，并使用 CGImageCreate() 创建一个 CGImageRef
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 // Width
                                        cvMat.rows,                                 // Height
                                        8,                                          // Bits per component
                                        8 * cvMat.elemSize(),                       // Bits per pixel
                                        cvMat.step[0],                              // Bytes per row
                                        colorSpace,                                 // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,
                                        provider,                                   // CGDataProviderRef
                                        NULL,                                       // Decode
                                        false,                                      // Should interpolate
                                        kCGRenderingIntentDefault);                 // Intent
    
    //最后，它从 CGImageRef 创建并返回一个 UIImage。
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return image;
}
//使用 OpenCV 函数处理输入图像。
+ (UIImage*)processImage:(UIImage *)inputImage {
    cv::Mat inputMat = [ImageProcessor cvMatFromUIImage:inputImage];
    cv::Mat processedMat;

    
    // Convert to grayscale,它将输入图像转换为灰度图像
    cv::cvtColor(inputMat, processedMat, cv::COLOR_BGRA2GRAY);

    // Apply Gaussian blur ,应用高斯模糊
    cv::GaussianBlur(processedMat, processedMat, cv::Size(5, 5), 0, 0);

    // Apply Canny edge detection,然后应用 Canny 边缘检测算法
    cv::Canny(processedMat, processedMat, 100, 200);
    
    //它将处理后的 cv::Mat 转换回 UIImage 并返回它
    UIImage *outputImage = [ImageProcessor UIImageFromCVMat:processedMat];
    return outputImage;
}

@end


