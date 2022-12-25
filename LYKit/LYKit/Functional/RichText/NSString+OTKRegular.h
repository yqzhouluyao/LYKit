//
//  NSString+OTKRegular.h
//  OffcnQuestionKit
//
//  Created by zhouluyao on 8/13/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (OTKRegular)
/// 只保留img标签
- (NSString *)otk_deleteHtmlTagExceptImg;
/// 把html标记解析成字符串，&nbsp; -> @" "
- (NSString *)otk_parseHtmlMarkupToStr;
@end

NS_ASSUME_NONNULL_END
