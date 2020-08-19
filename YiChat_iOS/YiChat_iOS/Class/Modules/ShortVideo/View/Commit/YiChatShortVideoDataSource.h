//
//  YiChatShortVideoDataSource.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YiChatShortVideoSubCommitDataSource;
@interface YiChatShortVideoDataSource : NSObject

@property (nonatomic,strong) NSDictionary *originData;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *appearUserName;
@property (nonatomic,strong) NSString *appearIconUrl;
@property (nonatomic,strong) NSString *appearCommitTime;
@property (nonatomic,assign) NSInteger replyNum;

@property (nonatomic,assign) BOOL praseState;
@property (nonatomic,assign) NSInteger praiseNum;

@property (nonatomic,strong) NSMutableAttributedString *appearContent;

@property (nonatomic,strong) NSMutableArray <YiChatShortVideoSubCommitDataSource *>*appearSubCommitList;

@property (nonatomic,assign) CGRect commitContentRect;

@property (nonatomic,assign) NSInteger subCommitPageNo;
@property (nonatomic,assign) NSInteger subCommitPageSize;



@property (nonatomic,assign) BOOL isShowClick;
@property (nonatomic,assign) BOOL isShowingSubCommit;

@property (nonatomic,assign) BOOL isShowMoreSubCommit;

@property (nonatomic,assign) BOOL isLoadingSubCommit;

@property (nonatomic,assign) BOOL isPraseing;

- (id)initWithData:(id)data;

- (CGFloat)getHeaderH;

- (CGFloat)getFooterH;

- (void)update;

@end

NS_ASSUME_NONNULL_END
