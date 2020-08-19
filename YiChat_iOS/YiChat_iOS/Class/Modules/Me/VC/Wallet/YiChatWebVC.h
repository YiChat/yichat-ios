//
//  YiChatWebVC.h
//  YiChat_iOS
//
//  Created by mac on 2020/5/19.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "NavProjectVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YiChatWebVC : NavProjectVC
+ (id)initialVC:(NSString *)type;
@property (nonatomic,strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
