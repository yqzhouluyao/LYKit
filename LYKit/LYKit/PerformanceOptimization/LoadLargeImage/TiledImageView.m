//
//  TiledImageView.m
//  LYKit
//
//  Created by zhouluyao on 3/31/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "TiledImageView.h"
#import <QuartzCore/CATiledLayer.h>


/*
 CATiledLayer 是 CALayer 的一个专门子类，
 旨在通过将大图像分成可以异步加载和显示的较小图块来高效渲染大图像。
 */
static const CGFloat kTileSize = 512;

@interface TiledImageView ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation TiledImageView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image scale:(CGFloat)scale {
    if (self = [super initWithFrame:frame]) {
        self.image = image;
        CATiledLayer *tiledLayer = (CATiledLayer *)self.layer;
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 2;
        tiledLayer.tileSize = CGSizeMake(512, 512);
        tiledLayer.contentsScale = scale;
    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

//您需要将大图像预处理成较小的图块，并将它们保存为单独的图像文件。
//命名约定如“large_image_x_y.jpg”，其中 x 和 y 代表图块坐标。
- (void)drawRect:(CGRect)rect {
    // Determine the visible rect and the corresponding tile coordinates
    CGRect visibleRect = [self.layer visibleRect];
    int startX = floorf(visibleRect.origin.x / kTileSize);
    int startY = floorf(visibleRect.origin.y / kTileSize);
    int endX = ceilf((visibleRect.origin.x + visibleRect.size.width) / kTileSize);
    int endY = ceilf((visibleRect.origin.y + visibleRect.size.height) / kTileSize);

    // Load and draw the visible image tiles
    for (int x = startX; x < endX; x++) {
        for (int y = startY; y < endY; y++) {
            @autoreleasepool {
                
//                NSString *tileName = [NSString stringWithFormat:@"large_image_%d_%d.jpg", x, y];
//                UIImage *tileImage = [UIImage imageNamed:tileName];
                NSString *tileName = [NSString stringWithFormat:@"large_image_%d_%d.jpg", x, y];
                NSString *path = [[NSBundle mainBundle] pathForResource:tileName ofType:nil];
                UIImage *tileImage = [UIImage imageWithContentsOfFile:path];

                
                CGFloat tileWidth = kTileSize;
                CGFloat tileHeight = kTileSize;
                
                // Adjust the tile size for the last row and last column
                if (x == endX - 1) {
                    tileWidth = CGRectGetMaxX(self.bounds) - x * kTileSize;
                }
                if (y == endY - 1) {
                    tileHeight = CGRectGetMaxY(self.bounds) - y * kTileSize;
                }
                
                CGRect tileRect = CGRectMake(x * kTileSize, y * kTileSize, tileWidth, tileHeight);
                [tileImage drawInRect:tileRect];
                
            }
        }
    }
}

@end
