//
//  YiChatChangePhoneNumVC.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/5/29.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#import "NavProjectVC.h"

NS_ASSUME_NONNULL_BEGIN
@class YiChatUserModel;
@interface YiChatChangePhoneNumVC : NavProjectVC

@property (nonatomic,strong) YiChatUserModel *model;


+ (id)initialVC;

@end

NS_ASSUME_NONNULL_END
