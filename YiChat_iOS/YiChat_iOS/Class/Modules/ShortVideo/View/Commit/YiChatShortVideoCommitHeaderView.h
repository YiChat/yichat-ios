//
//  YiChatShortVideoCommitHeaderView.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/16.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YiChatShortVideoDataSource;
@interface YiChatShortVideoCommitHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) YiChatShortVideoDataSource *dataSource;

@property (nonatomic,copy) void(^yichatShortVideoClickPraise)(YiChatShortVideoDataSource *dataSource);

@property (nonatomic,copy) void(^yichatShortVideoClickShowSubCommit)(BOOL isShow,YiChatShortVideoDataSource *dataSource);

@property (nonatomic,copy) void(^yichatShortVideoClickReply)(YiChatShortVideoDataSource *dataSource);

+ (id)initialWithReuseIdentifier:(NSString *)reuseIdentifier type:(NSNumber *)type;

- (void)createUI;

- (void)updateType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
