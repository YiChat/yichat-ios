//
//  YiChatCreateGroupVC.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/6/20.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#import "ProjectTableVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YiChatCreateGroupVC : ProjectTableVC

/**
 * createEndStyle pop 回上一页
 */
@property (nonatomic,assign) NSInteger createEndStyle;

+ (id)initialVC;

@end

NS_ASSUME_NONNULL_END
