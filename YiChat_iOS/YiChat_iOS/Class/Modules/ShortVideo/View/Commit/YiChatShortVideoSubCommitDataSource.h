//
//  YiChatShortVideoSubCommitDataSource.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/16.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YiChatShortVideoSubCommitDataSource : NSObject
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSDictionary *originData;
@property (nonatomic,strong) NSString *appearUserName;
@property (nonatomic,strong) NSString *appearIconUrl;
@property (nonatomic,strong) NSString *appearCommitTime;
@property (nonatomic,strong) NSMutableAttributedString *appearContent;

@property (nonatomic,assign) CGRect commitContentRect;

- (CGFloat)getCellH;

- (id)initWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
