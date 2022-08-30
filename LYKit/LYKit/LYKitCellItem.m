//
//  LYKitCellItem.m
//  LYKit-iOS
//
//  Created by zhouluyao on 2022/8/29.
//

#import "LYKitCellItem.h"

@implementation LYKitCellItem


+ (instancetype)itemWithTitle:(NSString *)title block:(dispatch_block_t)block
{
    LYKitCellItem *item = [[LYKitCellItem alloc] init];
    item.title = title;
    item.selectBlock = block;
    return item;
}


@end
