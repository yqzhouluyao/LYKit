//
//  LoadLargeImageViewController.m
//  LYKit
//
//  Created by zhouluyao on 3/31/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "LoadLargeImageViewController.h"
#import "TiledImageView.h"

@interface LoadLargeImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TiledImageView *tiledImageView;


@end

@implementation LoadLargeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"加载大图优化";
    
    // Initialize the UIScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 10.0;
    self.scrollView.minimumZoomScale = 0.1;
    [self.view addSubview:self.scrollView];

    // Load the large image
    UIImage *largeImage = [UIImage imageNamed:@"large_image.jpg"];
    CGSize imageSize = largeImage.size;
    CGFloat imageScale = largeImage.scale;

    // Add the TiledImageView to the UIScrollView
    self.tiledImageView = [[TiledImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height) image:largeImage scale:imageScale];
    [self.scrollView addSubview:self.tiledImageView];

    // Set the content size of the UIScrollView
    self.scrollView.contentSize = self.tiledImageView.bounds.size;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.tiledImageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tiledImageView setNeedsDisplay];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.tiledImageView setNeedsDisplay];
}


@end
