//
//  ImageProcessor.m
//  LYKit
//
//  Created by zhouluyao on 4/1/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//
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

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4);

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

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorSpace;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

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

    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return image;
}

+ (UIImage*)processImage:(UIImage *)inputImage {
    cv::Mat inputMat = [ImageProcessor cvMatFromUIImage:inputImage];
    cv::Mat processedMat;

    // Convert to grayscale
    cv::cvtColor(inputMat, processedMat, cv::COLOR_BGRA2GRAY);

    // Apply Gaussian blur
    cv::GaussianBlur(processedMat, processedMat, cv::Size(5, 5), 0, 0);

    // Apply Canny edge detection
    cv::Canny(processedMat, processedMat, 100, 200);

    UIImage *outputImage = [ImageProcessor UIImageFromCVMat:processedMat];
    return outputImage;
}

@end


