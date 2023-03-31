//
//  LYImageViewController.m
//  LYKit
//
//  Created by zhouluyao on 4/1/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "LYImageViewController.h"
#import "ImageProcessor.h"

@interface LYImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LYImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Image Processing";
    
    // Initialize the UIImageView
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    NSURL *imageURL = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/5809200-03bbbd715c24750e.jpg"];
    
    [self loadAndProcessImageFromURL:imageURL completion:^(UIImage *processedImage) {
        if (processedImage) {
            self.imageView.image = processedImage;
        } else {
            NSLog(@"Failed to load and process image");
        }
    }];
}

- (void)loadAndProcessImageFromURL:(NSURL *)imageURL completion:(void (^)(UIImage *))completion {
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *inputImage = [UIImage imageWithData:data];
            UIImage *processedImage = [ImageProcessor processImage:inputImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(processedImage);
            });
        } else {
            NSLog(@"Failed to download image: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    }];
    
    [dataTask resume];
}

@end
