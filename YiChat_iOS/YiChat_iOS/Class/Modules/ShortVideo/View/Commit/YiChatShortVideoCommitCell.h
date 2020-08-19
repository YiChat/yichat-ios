//
//  YiChatShortVideoCommitCell.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "ProjectTableCell.h"

NS_ASSUME_NONNULL_BEGIN
@class YiChatShortVideoSubCommitDataSource;
@interface YiChatShortVideoCommitCell : ProjectTableCell
@property (nonatomic,strong) YiChatShortVideoSubCommitDataSource *dataSource;

@property (nonatomic,copy) void(^yichatshortVideoReply)(YiChatShortVideoSubCommitDataSource *cellDataSource);


+ (id)initialWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath cellHeight:(NSNumber *)cellHeight cellWidth:(nonnull NSNumber *)cellWidth isHasDownLine:(nonnull NSNumber *)isHasDownLine isHasRightArrow:(nonnull NSNumber *)isHasRightArrow type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
