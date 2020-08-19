//
//  YiChatSendDynamicVC.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/6/6.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#import "ProjectScrollVC.h"

NS_ASSUME_NONNULL_BEGIN
@class YiChatSendDynamicToolBar;
@interface YiChatSendDynamicVC : ProjectScrollVC

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UILabel *alertLab;


@property (nonatomic,strong) NSMutableArray *uploadResourceList;

@property (nonatomic,strong) YiChatSendDynamicToolBar *sendToolBar;

+ (id)initialVC;

@end

NS_ASSUME_NONNULL_END
