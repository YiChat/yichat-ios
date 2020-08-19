//
//  YiChatDynamicCommitView.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/8/14.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YiChatDynamicCommitView : UIView

@property (nonatomic,strong) NSString *trendId;

@property (nonatomic,strong) NSString *subCommitId;

@property (nonatomic,assign) CGSize keyBoardSize;

@property (nonatomic,copy) void(^YiChatDynamicCommitViewSend)(NSString *text,NSString *trendId);

@property (nonatomic,copy) void(^YiChatDynamicCommitViewSendFull)(NSString *text,NSString *trendId,NSString *subcommitId);

@property (nonatomic,copy) void(^YiChatDynamicCommitViewKeyBoardShow)(CGSize keyBoard);

+ (id)create;

- (void)beginActive:(NSString *)trendId;

- (void)beginActive:(NSString *)trendId subCommitId:(NSString *)subCommitid;

- (void)removeActive;


@end

NS_ASSUME_NONNULL_END
