//
//  YiChatCommitUI.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatCommitUI.h"

static YiChatCommitUI *commit = nil;
@implementation YiChatCommitUI

+ (id)getUIConfig{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commit = [[YiChatCommitUI alloc] init];
        [commit initConfigure];
    });
    return commit;
}

- (void)initConfigure{
    _horizontalBlankW = PROJECT_SIZE_NAV_BLANK;
    _commitListUserIconSize = CGSizeMake(30.0, 30.0);

    _commitListUserNameFont = PROJECT_TEXT_FONT_COMMON(13);
    _commitListUserNameColor = PROJECT_COLOR_TEXTGRAY;

    _commitListContentMaxW = PROJECT_SIZE_WIDTH - _commitListUserIconSize.width * 2 - _horizontalBlankW * 2;
    _commitListContentFont = PROJECT_TEXT_FONT_COMMON(14.5);
    _commitListContentColor = PROJECT_COLOR_TEXTCOLOR_BLACK;
    
    _commitListContentTimeFont = PROJECT_TEXT_FONT_COMMON(13);
    _commitListContentTimeColor = PROJECT_COLOR_TEXTGRAY;
    
    _commitListClickSublistSize = CGSizeMake(_commitListContentMaxW, 40.0);
    _commitListClickSublistFont = PROJECT_TEXT_FONT_COMMON(14.5);
    _commitListClickSublistColor = PROJECT_COLOR_TEXTCOLOR_BLACK;
    
    
    _subCommitListUserIconSize = CGSizeMake(30.0, 30.0);

    _subCommitListUserNameFont = PROJECT_TEXT_FONT_COMMON(13);
    _subCommitListUserNameColor = PROJECT_COLOR_TEXTGRAY;

    _subCommitListContentMaxW = PROJECT_SIZE_WIDTH - _commitListUserIconSize.width * 2 - _horizontalBlankW * 4;
    _subCommitListContentFont = PROJECT_TEXT_FONT_COMMON(14.5);
    _subCommitListContentColor = PROJECT_COLOR_TEXTCOLOR_BLACK;
    
    _subCommitListContentTimeFont = PROJECT_TEXT_FONT_COMMON(13);
    _subCommitListContentTimeColor = PROJECT_COLOR_TEXTGRAY;
}


- (CGRect)getTextMessageRectWithText:(NSAttributedString *)str withMaxSize:(CGSize)maxSize font:(UIFont *)font{
    if(str && [str isKindOfClass:[NSAttributedString class]]){
        NSAttributedString *string = str;
        UILabel *lab = [[UILabel alloc] init];
        lab.font = font;
        lab.attributedText = string;
        lab.numberOfLines = 0;
        CGSize size = [lab sizeThatFits:maxSize];
        
        CGRect rect = CGRectZero;
        
        if(size.width < maxSize.width){
            rect =  CGRectMake(0, 0, size.width, size.height);
        }
        else{
            rect =  CGRectMake(0, 0, maxSize.width, size.height);
        }
        
        return rect;
        
    }
    return CGRectZero;
}
@end
