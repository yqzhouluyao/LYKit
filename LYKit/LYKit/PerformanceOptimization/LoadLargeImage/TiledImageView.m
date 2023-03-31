//
//  TiledImageView.m
//  LYKit
//
//  Created by zhouluyao on 3/31/23.
//  Copyright © 2023 zhouluyao. All rights reserved.
//

#import "TiledImageView.h"
#import <QuartzCore/CATiledLayer.h>
#import <YYCache/YYCache.h>

/*
 CATiledLayer 是 CALayer 的一个专门子类，
 旨在通过将大图像分成可以异步加载和显示的较小图块来高效渲染大图像。
 */
static const CGFloat kTileSize = 512;

@interface TiledImageView ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) YYCache *imageCache;

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
        
        //优化3：延迟加载和高效缓存：实现一个简单的 LRU 缓存来存储图像块并仅在需要时加载它们。这有助于平衡内存使用和性能。
        self.imageCache = [[YYCache alloc] initWithName:@"imageCache"];
        self.imageCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        
        //优化4：通过清除不必要的数据或资源来响应内存警告。对于 TiledImageView，您可以在收到内存警告时释放图像缓存。
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];

    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (UIImage *)cachedImageForKey:(NSString *)key {
    return (UIImage *)[self.imageCache objectForKey:key];
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
    [self.imageCache setObject:image forKey:key];
}

- (void)drawRect:(CGRect)rect {
    // Determine the visible rect and the corresponding tile coordinates
    CGRect visibleRect = [self.layer visibleRect];
    int startX = floorf(visibleRect.origin.x / kTileSize);
    int startY = floorf(visibleRect.origin.y / kTileSize);
    int endX = ceilf((visibleRect.origin.x + visibleRect.size.width) / kTileSize);
    int endY = ceilf((visibleRect.origin.y + visibleRect.size.height) / kTileSize);
    
    //您需要将大图像预处理成较小的图块，并将它们保存为单独的图像文件。
    //命名约定如“large_image_x_y.jpg”，其中 x 和 y 代表图块坐标。
    // Load and draw the visible image tiles
    for (int x = startX; x < endX; x++) {
        for (int y = startY; y < endY; y++) {
            //优化1:添加自动释放
            //一次加载大量图像可能会导致内存问题,可以将图像加载和绘制代码包装在 @autoreleasepool 块中，可确保在退出块时释放临时对象。
            
            @autoreleasepool {
            //优化2：imageWithContentsOfFile: 替代imageNamed:
            //imageNamed：将图像缓存在内存中，这对于在您的应用程序中重复使用的图像很有用。但是，在加载大量图像（如图块）的情况下，缓存行为可能会导致内存问题。
            //imageWithContentsOfFile：不缓存图片，即图片不再使用时会被释放。这可能更适合加载大量图像，因为它有助于防止内存问题。
                
                NSString *tileName = [NSString stringWithFormat:@"large_image_%d_%d.jpg", x, y];
                UIImage *tileImage = [self cachedImageForKey:tileName];
                if (!tileImage) {
                    tileImage = [UIImage imageNamed:tileName];
                    [self cacheImage:tileImage forKey:tileName];
                }

                
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

// Add this method in TiledImageView.m
- (void)memoryWarningNotification:(NSNotification *)notification {
    [self.imageCache removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
