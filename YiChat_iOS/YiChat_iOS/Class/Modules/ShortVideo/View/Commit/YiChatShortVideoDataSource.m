//
//  YiChatShortVideoDataSource.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatShortVideoDataSource.h"
#import "YiChatCommitUI.h"
@interface YiChatShortVideoDataSource ()

@property (nonatomic,weak) YiChatCommitUI *commitUI;

@end

@implementation YiChatShortVideoDataSource

- (id)initWithData:(id)data{
    self = [super init];
    if(self){
        
        _commitUI = [YiChatCommitUI getUIConfig];
        _appearSubCommitList = [NSMutableArray arrayWithCapacity:0];
        _subCommitPageNo = 1;
        _subCommitPageSize = 10.0;
        _isLoadingSubCommit = NO;
        
        _originData = data;
        
        [self intialHeaderData];
        
    }
    return self;
}

- (void)intialHeaderData{
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
    
    if(_originData[@"praiseStatus"] && ([_originData[@"praiseStatus"] isKindOfClass:[NSNumber class]] || [_originData[@"praiseStatus"] isKindOfClass:[NSString class]])){
        _praseState = [_originData[@"praiseStatus"] boolValue];
    }
    else{
        _praseState = NO;
    }
    
    if(_originData[@"praiseCount"] && ([_originData[@"praiseCount"] isKindOfClass:[NSNumber class]] || [_originData[@"praiseCount"] isKindOfClass:[NSString class]])){
        _praiseNum = [_originData[@"praiseCount"] intValue];
    }
    else{
        _praiseNum = 0;
    }

    
    
     NSString *show = [NSString stringWithFormat:@"%@--%@",commit,time];
    _appearCommitTime = time;
    _appearIconUrl = usericon;
    _appearUserName = userName;
    
    NSMutableAttributedString *commitShow = [ProjectHelper helper_factoryFontMakeAttributedStringWithTwoDiffirrentTextWhileSpecialWithRange:NSMakeRange(0, commit.length) font:_commitUI.commitListContentFont andFont:_commitUI.commitListContentTimeFont color:_commitUI.commitListContentColor color:_commitUI.commitListContentTimeColor withText:show];
    _appearContent = commitShow;
    
    
    _commitContentRect = [_commitUI getTextMessageRectWithText:commitShow withMaxSize:CGSizeMake(_commitUI.commitListContentMaxW , MAXFLOAT) font:_commitUI.commitListContentFont];
    
    _replyNum = [_originData[@"replyCount"] integerValue];
    if(_replyNum != 0){
        _isShowClick = YES;
    }
    else{
        _isShowClick = NO;
    }
    if(_isShowingSubCommit == YES){
        _isShowClick = NO;
    }
    
    
    if(_isShowClick){
        _isShowMoreSubCommit = NO;
    }
    else{
        if(_replyNum > 20.0){
               _isShowMoreSubCommit = YES;
           }
           else{
               _isShowMoreSubCommit = NO;
           }
    }
    
    _isPraseing = NO;
    
}

- (void)update{
    if(_isShowClick){
          _isShowMoreSubCommit = NO;
      }
      else{
          if(_replyNum > 20.0){
                 _isShowMoreSubCommit = YES;
             }
             else{
                 _isShowMoreSubCommit = NO;
             }
      }
      
}

- (CGFloat)getHeaderH{
    if(_isShowClick == NO){
        
        return _commitContentRect.size.height + _commitUI.commitListUserIconSize.height + 10.0;
    }
    else{
        
        return _commitContentRect.size.height + _commitUI.commitListUserIconSize.height + _commitUI.commitListClickSublistSize.height + 10.0;
    }
}

- (CGFloat)getFooterH{
    if(_isShowMoreSubCommit){
        return _commitUI.commitListClickSublistSize.height;
    }
    else{
        return 0.0001;
    }
}


@end
