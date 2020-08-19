
#import <UIKit/UIKit.h>
#import "NavProjectVC.h"

typedef NS_ENUM(NSUInteger,YiChatShortVideoListType){
    YiChatShortVideoListTypeViewList=0,
    YiChatShortVideoListTypeMyVideo,
    YiChatShortVideoListTypeDynamic,
    YiChatShortVideoListTypeLike
};

@interface ZFDouYinViewController : NavProjectVC
@property(nonatomic,assign) YiChatShortVideoListType type;

@property (nonatomic,strong) NSArray *viewDataList;

@property (nonatomic,assign) NSInteger sType;

+ (id)initialVC;
- (void)playTheIndex:(NSInteger)index;

+ (id)initialVCSearchVCType:(YiChatShortVideoListType)type dataSource:(NSArray *)data;
@end
