//
//  YiChatCommitUI.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YiChatCommitUI : NSObject

@property (nonatomic,assign) CGFloat horizontalBlankW;


@property (nonatomic,assign) CGSize commitListUserIconSize;

@property (nonatomic,strong) UIFont *commitListUserNameFont;
@property (nonatomic,strong) UIColor *commitListUserNameColor;

@property (nonatomic,assign) CGFloat commitListContentMaxW;
@property (nonatomic,strong) UIFont *commitListContentFont;
@property (nonatomic,strong) UIColor *commitListContentColor;

@property (nonatomic,strong) UIFont *commitListContentTimeFont;
@property (nonatomic,strong) UIColor *commitListContentTimeColor;

@property (nonatomic,assign) CGSize commitListClickSublistSize;
@property (nonatomic,strong) UIFont *commitListClickSublistFont;
@property (nonatomic,strong) UIColor *commitListClickSublistColor;



@property (nonatomic,assign) CGSize subCommitListUserIconSize;

@property (nonatomic,strong) UIFont *subCommitListUserNameFont;
@property (nonatomic,strong) UIColor *subCommitListUserNameColor;

@property (nonatomic,assign) CGFloat subCommitListContentMaxW;
@property (nonatomic,strong) UIFont *subCommitListContentFont;
@property (nonatomic,strong) UIColor *subCommitListContentColor;

@property (nonatomic,strong) UIFont *subCommitListContentTimeFont;
@property (nonatomic,strong) UIColor *subCommitListContentTimeColor;



+ (id)getUIConfig;

- (CGRect)getTextMessageRectWithText:(NSAttributedString *)str withMaxSize:(CGSize)maxSize font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
