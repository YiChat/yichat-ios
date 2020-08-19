//
//  YiChatPersonalCentorModel.h
//  YiChat_iOS
//
//  Created by mac on 2020/4/19.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YiChatPersonalCentorInfoModel : NSObject
@property (nonatomic,strong) NSString *videoId;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSString *seconds;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *nick;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *praseCount;
@property (nonatomic,strong) NSString *commentCount;
@property (nonatomic,strong) NSString *viewCount;
@property (nonatomic,assign) BOOL praiseStatus;

@end

@interface YiChatPersonalCentorModel : NSObject
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,assign) NSInteger code;
@property (nonatomic,assign) BOOL success;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNo;
@property (nonatomic,strong) NSArray *data;
@end

NS_ASSUME_NONNULL_END
