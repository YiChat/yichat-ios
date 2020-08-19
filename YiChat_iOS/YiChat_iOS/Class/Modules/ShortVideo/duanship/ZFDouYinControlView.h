

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"

typedef void(^PlayBlock)(NSString *videoId);

@interface ZFDouYinControlView : UIView <ZFPlayerMediaControl>

@property (nonatomic,strong) NSString *videoId;

@property (nonatomic,copy) PlayBlock playBlock;

- (void)resetControlView;

- (void)showCoverViewWithUrl:(NSString *)coverUrl withImageMode:(UIViewContentMode)contentMode;

-(void)stop;

@end
