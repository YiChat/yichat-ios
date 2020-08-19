//
//  YiChatShortControlView.h
//  YiChat_iOS
//
//  Created by mac on 2020/5/9.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
NS_ASSUME_NONNULL_BEGIN

@interface YiChatShortControlView : UIView <ZFPlayerMediaControl>
- (void)resetControlView;

- (void)showCoverViewWithUrl:(NSString *)coverUrl withImageMode:(UIViewContentMode)contentMode;
@end

NS_ASSUME_NONNULL_END
