//
//  MarkUpParseTool.h
//
//  Created by zhouluyao on 6/17/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HTMLStringParseSuccess)(NSMutableAttributedString *attributedString);
typedef void(^HTMLStringParseFailure)(NSError * _Nonnull error);

@interface OTKMarkUpParseManager : NSObject


/// 把带有<img>的Html字符串转换成YYTextAttachment格式的属性字符串
/// @param htmlString HTML标签
/// @param labelWidth 当图片尺寸大于label的宽度时，用于缩放
/// @param font YYLabel的字体大小
/// @param success 图片全部下载完成，把<img>标签字符串转换成YYTextAttachment
/// @param failure 图片下载失败
+ (void)parseHTMLString:(NSString *)htmlString
             labelWidth:(CGFloat)labelWidth
                   font:(UIFont *)font
           parseSuccess:(HTMLStringParseSuccess)success
           parseFailure:(HTMLStringParseFailure)failure;


/// 根据带有YYTextAttachment格式的属性字符串、字体大小、YYLabel显示的最大宽度，计算出YYLabel的高度
/// @param attributedString 可能带有YYTextAttachment格式的属性字符串
/// @param width YYLabel的宽度
+ (CGFloat)heightForYYLabelWithAttributedString:(NSAttributedString *)attributedString labelWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
