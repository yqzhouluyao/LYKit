//
//  NSString+OTKRegular.m
//  OffcnQuestionKit
//
//  Created by zhouluyao on 8/13/21.
//

#import "NSString+OTKRegular.h"

@implementation NSString (OTKRegular)

- (NSString *)otk_deleteHtmlTagExceptImg {
    NSMutableString *filtedString = [NSMutableString stringWithString:self];
    NSMutableArray * htmlTags = [NSMutableArray array];
    //标签匹配
    NSString *parten = @"(?!<(img).*?>)<.*?>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    NSArray* match = [reg matchesInString:filtedString options:0 range:NSMakeRange(0, [filtedString length])];
    
    for (NSTextCheckingResult * result in match) {
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [filtedString substringWithRange:range];
        //将提取出的图片URL添加到图片数组中
        [htmlTags addObject:@{NSStringFromRange(range):subString}];
    }
    
    for (int i = (int)(htmlTags.count -1); i>=0; i--) {
        NSDictionary *tagInfo = htmlTags[i];
        NSString *tagRangeKey = [[tagInfo allKeys] firstObject];
        NSRange tagRange = NSRangeFromString(tagRangeKey);
        [filtedString replaceCharactersInRange:tagRange withString:@""];
    }
    return filtedString.copy;
}

- (NSString *)otk_parseHtmlMarkupToStr {
    NSString *htmlStr = self;
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&cent;" withString:@"¢"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&yen;" withString:@"¥"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&euro;" withString:@"€"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    return htmlStr;
}


@end

