//
//  LYKitCellItem.h
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYKitCellItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) dispatch_block_t selectBlock;

+ (instancetype)itemWithTitle:(NSString *)title block:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
