//
//  YiChatShortVideoSubCommitDataSource.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/16.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatShortVideoSubCommitDataSource.h"
#import "YiChatCommitUI.h"

@interface YiChatShortVideoSubCommitDataSource ()

@property (nonatomic,weak) YiChatCommitUI *commitUI;

@end

@implementation YiChatShortVideoSubCommitDataSource

- (id)initWithData:(id)data{
    self = [super init];
    if(self){
        _commitUI = [YiChatCommitUI getUIConfig];
        
        _originData = data;
        
        [self intialCellData];
        
    }
    return self;
}

- (void)intialCellData{
    NSString *commit = @"";
    NSString *time = @"";
    
   
    NSString *usericon = @"";
    NSString *userName = @"";
    
    if(_originData[@"avatar"] && [_originData[@"avatar"] isKindOfClass:[NSString class]]){
        usericon = _originData[@"avatar"];
    }
    if(_originData[@"nick"] && [_originData[@"nick"] isKindOfClass:[NSString class]]){
        userName = _originData[@"nick"];
    }
    if(_originData[@"content"] && [_originData[@"content"] isKindOfClass:[NSString class]]){
        commit = _originData[@"content"];
    }
    if(_originData[@"timeDesc"] && [_originData[@"timeDesc"] isKindOfClass:[NSString class]]){
           time = _originData[@"timeDesc"];
       
    }
    
    if(_originData[@"userId"] && [_originData[@"userId"] isKindOfClass:[NSNumber class]]){
        self.userId = [NSString stringWithFormat:@"%d",[_originData[@"userId"] intValue]];
    }
    
    NSString *show = @"";
    NSString *tmp = @"";
    if(_originData[@"replyNick"] && [_originData[@"replyNick"] isKindOfClass:[NSString class]]){
       
        show = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"回复",_originData[@"replyNick"],@":",commit,@" ",time];
    }
    else{
        show = [NSString stringWithFormat:@"%@%@%@",commit,@" ",time];
    }
    _appearCommitTime = time;
    _appearIconUrl = usericon;
    _appearUserName = userName;
    
    NSMutableAttributedString *commitShow = [ProjectHelper helper_factoryFontMakeAttributedStringWithTwoDiffirrentTextWhileSpecialWithRange:NSMakeRange(0, show.length - time.length) font:_commitUI.subCommitListContentFont andFont:_commitUI.subCommitListContentTimeFont color:_commitUI.subCommitListContentColor color:_commitUI.subCommitListContentTimeColor withText:show];
    _appearContent = commitShow;
    
    
    _commitContentRect = [_commitUI getTextMessageRectWithText:commitShow withMaxSize:CGSizeMake(_commitUI.subCommitListContentMaxW , MAXFLOAT) font:_commitUI.subCommitListContentFont];
    
}

- (CGFloat)getCellH{
    return _commitUI.subCommitListUserIconSize.height + _commitContentRect.size.height;
}

@end
