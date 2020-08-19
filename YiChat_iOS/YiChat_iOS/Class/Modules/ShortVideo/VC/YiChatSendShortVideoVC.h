//
//  YiChatSendShortVideoVC.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/14.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatSendDynamicVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YiChatSendShortVideoVC : YiChatSendDynamicVC

@property (nonatomic,copy) void(^yichatSendShortVideoSuccess)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
