//
//  ZFSourceLoadManage.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/5/30.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#import "ZFSourceLoadManage.h"

static ZFSourceLoadManage *manage = nil;

static NSArray *chatDefualtEmojiResource = nil;
@interface ZFSourceLoadManage ()

@end

@implementation ZFSourceLoadManage

+ (void)load{
    NSMutableArray *defaultChatIcons = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < 140; i++) {
        if(i != 44){
            NSString *name = [NSString stringWithFormat:@"emoji_%d@3x%@",i,@".png"];
            UIImage *img = [UIImage imageNamed:name];
            
            if(img != nil){
                [defaultChatIcons addObject:img];
            }
        }
    }
    chatDefualtEmojiResource = defaultChatIcons;
}

+ (id)sharedManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[self alloc] init];
        manage.defaultChatEmojiArr = chatDefualtEmojiResource;
        
    });
    return manage;
}

- (NSArray *)getEmojiTextList{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < 140; i ++) {
        if(i != 44){
            [arr addObject:[NSString stringWithFormat:@"[emoji_%d]",i]];
        }
    }
    return arr;
}

@end
