//
//  YiChatInviteModel.h
//  YiChat_iOS
//
//  Created by mac on 2020/5/6.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YiChatBassModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YiChatInviteInfoModel : NSObject

//"userId": 20107817,
//"avatar": "http://yiliao08.oss-cn-beijing.aliyuncs.com/20107817_20200506152749680.png",
//"nick": "测试添加账号",
//"appId": null,
//"gender": null,
//"friendStatus": 1,  --是否是好友  0是 1否
//"timeDesc": "2020-05-06 15:57:06"
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *nick;
@property (nonatomic,strong) NSString *appId;
//@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *friendStatus;
@property (nonatomic,strong) NSString *timeDesc;
//@property (nonatomic,strong) NSString *userId;
@end

@interface YiChatInviteModel : YiChatBassModel
@property (nonatomic,strong) NSArray *data;
@end

NS_ASSUME_NONNULL_END
