//
//  LYGrayStyleViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/12/29.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYGrayStyleViewController.h"
#import "LYGrayStyle.h"

@interface LYGrayStyleViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation LYGrayStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
    
    UIButton *grayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, 80, 30)];
    [grayStyleBtn addTarget:self action:@selector(grayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [grayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [grayStyleBtn setTitle:@"全局置灰" forState:UIControlStateNormal];
    [self.view addSubview:grayStyleBtn];
    
    UIButton *cancelGrayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 500, 80, 30)];
    [cancelGrayStyleBtn addTarget:self action:@selector(cancelGrayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelGrayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelGrayStyleBtn setTitle:@"取消置灰" forState:UIControlStateNormal];
    [self.view addSubview:cancelGrayStyleBtn];
    
    UIButton *imageGrayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 400, 120, 30)];
    [imageGrayStyleBtn addTarget:self action:@selector(imageGrayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageGrayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [imageGrayStyleBtn setTitle:@"置灰图片1" forState:UIControlStateNormal];
    [self.view addSubview:imageGrayStyleBtn];
    
    
    UIButton *cancelImageGrayStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 400, 120, 30)];
    [cancelImageGrayStyleBtn addTarget:self action:@selector(cancelImageGrayStyleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelImageGrayStyleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelImageGrayStyleBtn setTitle:@"取消置灰图片1" forState:UIControlStateNormal];
    [self.view addSubview:cancelImageGrayStyleBtn];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImage *sourceImage = [UIImage imageNamed:@"years_share_icon"];
    self.imageView.image = [self changeGrayImage:sourceImage];
}

//图片置灰操作
 - (UIImage *)changeGrayImage:(UIImage *)sourceImage{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *superImage = [CIImage imageWithCGImage:sourceImage.CGImage];
        CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
        [lighten setValue:superImage forKey:kCIInputImageKey];
     // 修改亮度   -1---1   数越大越亮
        [lighten setValue:@(0) forKey:@"inputBrightness"];
        // 修改饱和度  0---2
        [lighten setValue:@(0) forKey:@"inputSaturation"];
      // 修改对比度  0---4
        [lighten setValue:@(0.5) forKey:@"inputContrast"];
        CIImage *result = [lighten valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
        // 得到修改后的图片
      //        UIImage *newImage =  [UIImage imageWithCGImage:cgImage];
        UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:sourceImage.scale orientation:sourceImage.imageOrientation];
        // 释放对象
        CGImageRelease(cgImage);
         return newImage;
}

- (void)grayStyleBtnClick {
    [LYGrayStyle openGlobalGrayStyle];
}

- (void)cancelGrayStyleBtnClick {
    [LYGrayStyle closeGlobalGrayStyle];
}

- (void)imageGrayStyleBtnClick {
    [LYGrayStyle openGrayStyleWithView:self.imageView];
}

- (void)cancelImageGrayStyleBtnClick {
    [LYGrayStyle closeGrayStyleWithView:self.imageView];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
        _imageView.image = [UIImage imageNamed:@"years_share_icon"];
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
