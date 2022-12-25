//
//  BrowserImageViewController.m
//
//  Created by zhouluyao on 6/10/21.
//

#import "BrowserImageViewController.h"
#import "UIColor+Hex.h"
#import "ZGAppInfoUtil.h"
#import "UIView+Frame.h"
//#import "UIImage+ImageWithColor.h"


@interface BrowserImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *images;  //存图片地址
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageArray; //存图片
@property (nonatomic, assign) NSInteger imageTag;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BrowserImageViewController

- (instancetype)initWithImages:(NSArray *)images currentIndex:(NSInteger)index {
    if (self = [super init]) {
        self.images = images;
        self.currentIndex = index;
        self.imageArray = [NSMutableArray array];
        self.imageTag = 1000;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startDraw];
    [self setupNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)goBackVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navContentHeight = 44;
    CGFloat navH = statusBarHeight + navContentHeight;
    UIView *navV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navH)];
    navV.backgroundColor = [UIColor zg_colorWithHex:0x333333 andAlpha:0.6];
    self.navigationView = navV;
    [self.view addSubview:navV];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_btn_back_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, [ZGAppInfoUtil safeAreaTopHeight] + 6, 40, 32);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [backBtn addTarget:self action:@selector(goBackVC) forControlEvents:UIControlEventTouchUpInside];
    [navV addSubview:backBtn];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) * 0.5, statusBarHeight, 200, navContentHeight);
    [navV addSubview:self.titleLabel];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex + 1, (unsigned long)self.images.count];
}

- (void)startDraw {
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    scrollview.backgroundColor = [UIColor blackColor];
    scrollview.showsHorizontalScrollIndicator = scrollview.showsVerticalScrollIndicator = NO;
    scrollview.userInteractionEnabled = YES;
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.images.count,0);
    [self.view addSubview:scrollview];
    self.mainScrollView = scrollview;
    scrollview.directionalLockEnabled = YES;
    for (int i = 0 ; i< self.images.count; i ++) {
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        
        UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        UIScrollView *childScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, scrollview.zg_height)];
        childScrollView.backgroundColor = [UIColor clearColor];
        childScrollView.showsHorizontalScrollIndicator = childScrollView.showsVerticalScrollIndicator = NO;
        
        childScrollView.delegate = self;
        childScrollView.minimumZoomScale = 1.0;
        childScrollView.maximumZoomScale = 3;
        [childScrollView setZoomScale:1];
        childScrollView.userInteractionEnabled = YES;
        [self.mainScrollView addSubview:childScrollView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = self.imageTag + i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:doubleTap];
        [imageView addGestureRecognizer:pressGesture];
        [childScrollView addSubview:imageView];
        [self.imageArray addObject:imageView];
        
        if ([self.images[i] isKindOfClass:[UIImage class]]) {
            UIImage *image = self.images[i];
            imageView.image = image;
            [self setImageViewFrame:imageView image:image];
        } else if ([self.images[i] isKindOfClass:[NSString class]]){
            imageView.image = [self createImageWithColor:[UIColor zg_colorWithHex:0xE8E8E8]];
            imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, childScrollView.zg_height);
            [self resetImageUrl:self.images[i] imageView:imageView];
        }
    }
    scrollview.contentOffset = CGPointMake(self.currentIndex * scrollview.zg_width, 0);
}

-(CGSize)resizeImageSize:(CGSize)size {
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat maxHeight = [ZGAppInfoUtil screenHeight];
    CGFloat maxWidth = [ZGAppInfoUtil screenWidth];
    //如果图片尺寸大于view尺寸，按比例缩放
    if(width > maxWidth || height > maxHeight) {
        CGFloat ratio = height / width;
        CGFloat maxRatio = maxHeight / maxWidth;
        if(ratio < maxRatio){
            width = maxWidth;
            height = width*ratio;
        } else {
            height = maxHeight;
            width = height / ratio;
        }
    } else {
        CGFloat ratio = height / width;
        width = [ZGAppInfoUtil screenWidth];
        height = [ZGAppInfoUtil screenWidth] * ratio;
    }
    return CGSizeMake(width, height);
}

- (void)setImageViewFrame:(UIImageView *)imageView image:(UIImage *)image {
    CGSize imageReSize = [self resizeImageSize:image.size];
    imageView.frame = CGRectMake(([ZGAppInfoUtil screenWidth] - imageReSize.width) / 2, ([ZGAppInfoUtil screenHeight] - imageReSize.height) / 2, imageReSize.width, imageReSize.height);
}


-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 增量为=位移距离/2
    UIView *view = [scrollView.subviews objectAtIndex:0];
    if ([view isKindOfClass:[UIImageView class]]){
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        view.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                               scrollView.contentSize.height * 0.5 + offsetY);
    }


}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIView *view in scrollView.subviews) {
        return view;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.zg_width;
        if (index != self.currentIndex) {
            for (UIScrollView *scrollview in scrollView.subviews){
                if ([scrollview isKindOfClass:[UIScrollView class]]){
                    [scrollview setZoomScale:1.0];
                }
            }
            self.currentIndex = index;
            
            self.titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex + 1, (unsigned long)self.images.count];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    float newScale = [(UIScrollView *)gesture.view.superview zoomScale] * 2;
    [UIView animateWithDuration:0.3 animations:^{
        [(UIScrollView *)gesture.view.superview setZoomScale:newScale];
    }];
    if (newScale > 2) {
        newScale = 1;
        [UIView animateWithDuration:0.3 animations:^{
            [(UIScrollView *)gesture.view.superview setZoomScale:newScale];
        }];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        BOOL allowed = [ZGAppInfoUtil checkPhotoLibraryAuthorizationStatus:^(UIAlertController *alert) {
            [self presentViewController:alert animated:YES completion:nil];
        }];
        if (!allowed) {
            return;
        }
        UIImage *image = self.imageArray[self.currentIndex].image;
        if (!image) {
            return;
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"是否保存图片" preferredStyle:UIAlertControllerStyleActionSheet];

        [ac addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        
    } else {
//        [self.view alertWithMessage:@"保存成功"];
    }
}

- (void)resetImageUrl:(NSString *)imageUrl imageView:(UIImageView *)imageView {
//    if ([imageUrl hasPrefix:@"http"]) {
//        if ([imageUrl containsString:@"?auth_key="]) {
//            NSURL *url = [NSURL URLWithString:imageUrl];
//            NSString *imageKey = [NSString imageUrlKey:imageUrl];
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
//            if (!image) {
//                [self setImage:imageView needCache:YES url:url imageKey:imageKey];
//            } else {
//                imageView.image = image;
//                [self setImageViewFrame:imageView image:image];
//            }
//        } else {
//            [self setImage:imageView needCache:NO url:[NSURL URLWithString:imageUrl] imageKey:imageUrl];
//        }
//    } else {
//        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageUrl];
//        if (image) {
//            imageView.image = image;
//            [self setImageViewFrame:imageView image:image];
//        }  else {
//            NSString *cdnUrl = [NSString disposeCDNUrl:imageUrl];
//            [self setImage:imageView needCache:YES url:[NSURL URLWithString:cdnUrl] imageKey:imageUrl];
//        }
//
//    }
}

- (void)setImage:(UIImageView *)imageView needCache:(BOOL)needCache url:(NSURL *)url imageKey:(NSString *)imageKey {
//    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xE8E8E8)] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (image) {
//            if (needCache) {
//                [[SDImageCache sharedImageCache] removeImageForKey:url.absoluteString  withCompletion:nil];
//                [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey completion:nil];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self setImageViewFrame:imageView image:image];
//            });
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//            });
//            
//        }
//    }];
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
