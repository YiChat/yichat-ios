//
//  YiChatShortVideoCommitView.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "ProjectAnimateView.h"


typedef void(^RefeshCommit)(NSInteger count);

NS_ASSUME_NONNULL_BEGIN

@interface YiChatShortVideoCommitView : ProjectAnimateView

@property (nonatomic,copy) RefeshCommit refeshCommit;

+ (id)createWithFrame;

- (void)initialText;

- (void)activeshowWithData:(NSDictionary *)videoDic backBlocked:(void(^)(BOOL isNeedRefeshCommit))blocked;

- (void)deactiveHidden;


@end

NS_ASSUME_NONNULL_END
