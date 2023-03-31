//
//  LYImageDecodeViewController.m
//  LYKit
//
//  Created by zhouluyao on 4/1/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "ImageDecodeViewController.h"

@interface ImageDecodeViewController ()

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation ImageDecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ImageDecoding and Resizing";
    
    // Initialize the UIImageView
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    NSURL *imageURL = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/5809200-03bbbd715c24750e.jpg"];

    [self loadImageInBackgroundWithURL:imageURL maxSize:CGSizeMake(200, 200) completion:^(UIImage *image) {
        if (image) {
            self.imageView.image = image;
        } else {
            NSLog(@"Failed to load image");
        }
    }];
}

- (UIImage *)decodedAndResizedImageWithData:(NSData *)data maxSize:(CGSize)maxSize {
    UIImage *inputImage = [UIImage imageWithData:data];
    
    // Calculate the new size
    CGSize newSize = [self newSizeForImage:inputImage maxSize:maxSize];
    
    // Use UIGraphicsImageRenderer to resize the image efficiently
    UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
    format.scale = inputImage.scale;
    format.opaque = NO;
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize format:format];
    UIImage *resizedImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [inputImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    }];
    
    return resizedImage;
}

- (CGSize)newSizeForImage:(UIImage *)image maxSize:(CGSize)maxSize {
    CGFloat widthRatio = maxSize.width / image.size.width;
    CGFloat heightRatio = maxSize.height / image.size.height;
    
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    return newSize;
}


//在后台队列上调用辅助方法并更新主队列上的 UI
- (void)loadImageInBackgroundWithURL:(NSURL *)url maxSize:(CGSize)maxSize completion:(void (^)(UIImage *))completion {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        if (!imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
            return;
        }
        
        UIImage *resizedImage = [self decodedAndResizedImageWithData:imageData maxSize:maxSize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(resizedImage);
        });
    });
}

@end
