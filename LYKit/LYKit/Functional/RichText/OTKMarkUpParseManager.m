//
//  MarkUpParseTool.m
//
//  Created by zhouluyao on 6/17/21.
//

#import "OTKMarkUpParseManager.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <YYText/YYText.h>

#define kLineSpace 5

@implementation OTKMarkUpParseManager

+ (void)parseHTMLString:(NSString *)htmlString
             labelWidth:(CGFloat)labelWidth
                   font:(UIFont *)font
           parseSuccess:(HTMLStringParseSuccess)success
           parseFailure:(HTMLStringParseFailure)failure {
    
    if (htmlString.length == 0) {
        return;
    }
    NSMutableAttributedString *text =  [NSMutableAttributedString new];
    text.yy_lineSpacing = kLineSpace;
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:htmlString attributes:nil]];
    
    NSArray *imageInfos = [self _getImagesSourceFromHtml:htmlString];
    if (imageInfos.count) {
        [self _replaceAttributedString:text withImageInfos:imageInfos currentIndex:imageInfos.count -1 labelWidth:labelWidth font:font parseSuccess:success parseFailure:failure];
    } else {
        if (success) {
            success([text mutableCopy]);
        }
    }
}

+ (CGFloat)heightForYYLabelWithAttributedString:(NSAttributedString *)attributedString labelWidth:(CGFloat)width {
    
    CGSize introSize = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:attributedString];
    return layout.textBoundingSize.height;
}

#pragma mark -private

//递归倒序替换图片
+ (void)_replaceAttributedString:(NSMutableAttributedString *)text withImageInfos:(NSArray *)imageInfos currentIndex:(NSUInteger)index labelWidth:(CGFloat)labelWidth
                            font:(UIFont *)labelFont
                    parseSuccess:(HTMLStringParseSuccess)success
                    parseFailure:(HTMLStringParseFailure)failure {
    
    if (index<0 || index>=imageInfos.count) {
        return;
    }
    __block NSUInteger currentIndex = index;
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *imageInfo = imageInfos[currentIndex];
    CGSize imageSize = CGSizeFromString(imageInfo[@"image_size"]);
    NSDictionary *imageRangeInfo = imageInfo[@"image_range"];
    NSString *imageRange = [[imageRangeInfo allKeys] firstObject];
    NSString *imageUrl = [[imageRangeInfo allValues] firstObject];
    
    //是否是base64
    if ([imageUrl hasPrefix:@"http"]) {
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            if (!image) {
                image = [UIImage imageNamed:@"img_load_fail"];
            }
            //所有的图片全部下载完成后回调
            //把指定Range的属性字符替换为YYTextAttachement
            
            NSMutableAttributedString *yyAttachmentString = [weakSelf _yyAttachmentStringWithImage:image labelWidth:labelWidth labelFont:labelFont imageSize:imageSize];
            [text replaceCharactersInRange:NSRangeFromString(imageRange) withAttributedString:yyAttachmentString];
            if (currentIndex == 0) {
                if (success) {
                    success(text);
                }
            } else {
                currentIndex --;
                [weakSelf _replaceAttributedString:text withImageInfos:imageInfos currentIndex:currentIndex labelWidth:labelWidth font:labelFont parseSuccess:success parseFailure:failure];
            }

            if (error && failure) {
                failure(error);
            }
        }];
    } else { //base64 image
        //去掉固定前缀 data:image/png;base64,
        
        NSString *base64Str = [imageUrl stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        if (!image) {
            image = [UIImage imageNamed:@"img_load_fail"];
        }
   
        NSMutableAttributedString *yyAttachmentString = [weakSelf _yyAttachmentStringWithImage:image labelWidth:labelWidth labelFont:labelFont imageSize:imageSize];
        
        [text replaceCharactersInRange:NSRangeFromString(imageRange) withAttributedString:yyAttachmentString];
        if (currentIndex == 0) {
            if (success) {
                success(text);
            }
        } else {
            currentIndex --;
            [weakSelf _replaceAttributedString:text withImageInfos:imageInfos currentIndex:currentIndex labelWidth:labelWidth font:labelFont parseSuccess:success parseFailure:failure];
        }
    }
    
}

+ (NSArray *)_getImagesSourceFromHtml:(NSString *)webString
{
    NSMutableArray * imageSources = [NSMutableArray array];
    
    //标签匹配
    NSString *pattern = @"<(img|IMG)(.*?)(/>|></img>|>)";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length])];
    
    for (NSTextCheckingResult * result in match) {
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        //获取图片返回的size
        CGSize imageSize = [self sizeWithImageString:subString];
 
        //将提取出的图片URL添加到图片数组中
        NSString *imageSource = [self imageUrlWithImgTagString:subString];
        if ([imageSource isEqualToString:@""]) {
            continue;
        }
        [imageSources addObject:@{@"image_range":@{NSStringFromRange(range):imageSource},@"image_size":NSStringFromCGSize(imageSize)}];
    }
    return imageSources;
}

+ (NSMutableAttributedString *)_yyAttachmentStringWithImage:(UIImage *)image labelWidth:(CGFloat)labelWidth labelFont:(UIFont *)labelFont imageSize:(CGSize)imageSize{
    
    CGSize size = image.size;
    if (imageSize.width > 0 && imageSize.height > 0) {
        size = imageSize;
    }
    
    if (size.width > labelWidth) {
        size.width = labelWidth;
        size.height = labelWidth * (size.height / size.width);
    }
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleToFill attachmentSize:size alignToFont:labelFont alignment:YYTextVerticalAlignmentCenter];
    return attachText;
}

+ (CGSize)sizeWithImageString:(NSString *)imageString {
    
    NSRegularExpression *widthRegular = [NSRegularExpression regularExpressionWithPattern:@"(width|WIDTH)=\"(.*?)\"" options:0 error:nil];
    NSArray* widths = [widthRegular matchesInString:imageString options:0 range:NSMakeRange(0, [imageString length])];
    if (widths.count == 0) {
        return CGSizeZero;
    }
    NSTextCheckingResult * widthResult = widths[0];
    NSRange widthRange = [widthResult range];
    NSString *widthStr = [[imageString substringWithRange:widthRange] substringFromIndex:6]; //去掉width=
    widthStr = [widthStr substringWithRange:NSMakeRange(1, widthStr.length -3)]; //去掉px
    
    NSRegularExpression *heightRegular = [NSRegularExpression regularExpressionWithPattern:@"(height|HEIGHT)=\"(.*?)\"" options:0 error:nil];
    NSArray* heights = [heightRegular matchesInString:imageString options:0 range:NSMakeRange(0, [imageString length])];
    if (heights.count == 0) {
        return CGSizeZero;
    }
    NSTextCheckingResult * heightResult = heights[0];
    NSRange heightRange = [heightResult range];
    NSString *heightStr = [[imageString substringWithRange:heightRange] substringFromIndex:7]; //去掉height=
    heightStr = [heightStr substringWithRange:NSMakeRange(1, heightStr.length -3)]; //去掉px
    
    if (widthStr.length && heightStr.length) {
        return CGSizeMake([widthStr doubleValue] / [UIScreen mainScreen].scale, [heightStr doubleValue] / [UIScreen mainScreen].scale);
    }
    return CGSizeZero;
}

/// 获取图片的Url或者Base64 string
+ (NSString *)imageUrlWithImgTagString:(NSString *)imgTagString {
    NSRegularExpression *imageUrlRegular = [NSRegularExpression
                                   regularExpressionWithPattern:@"(src|SRC)=\"(.*?)\""
                                   options:0
                                   error:nil];
    NSArray* match = [imageUrlRegular matchesInString:imgTagString options:0 range:NSMakeRange(0, [imgTagString length])];
    if (match.count == 0) {
        return @"";
    }
    NSTextCheckingResult * subRes = match[0];
    NSRange subRange = [subRes range];
    subRange.length = subRange.length;
    NSString * imageSource = [imgTagString substringWithRange:subRange];
    //去除(src|SRC)=,从下标为4的位置获取
    imageSource = [imageSource substringFromIndex:4];
    //去掉转义符
    imageSource = [imageSource stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return imageSource;
}

@end
