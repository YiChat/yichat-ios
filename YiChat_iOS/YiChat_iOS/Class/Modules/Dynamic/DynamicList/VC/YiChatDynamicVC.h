//
//  YiChatDynamicVC.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/6/6.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#import "ProjectTableVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YiChatDynamicVC : ProjectTableVC

@property (nonatomic,strong) NSString *userId;

+ (id)initialVC;

@end

NS_ASSUME_NONNULL_END
