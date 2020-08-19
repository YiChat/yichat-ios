
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface ZFTableData : NSObject
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, assign) NSInteger agree_num;
@property (nonatomic, assign) NSInteger share_num;
@property (nonatomic, assign) NSInteger post_num;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat thumbnail_width;
@property (nonatomic, assign) CGFloat thumbnail_height;
@property (nonatomic, assign) CGFloat video_duration;
@property (nonatomic, assign) CGFloat video_width;
@property (nonatomic, assign) CGFloat video_height;
@property (nonatomic, copy) NSString *thumbnail_url;
@property (nonatomic, copy) NSString *video_url;

@property (nonatomic,strong) NSString *videoId;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSString *seconds;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *nick;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *praseCount;
@property (nonatomic,strong) NSString *commentCount;
@property (nonatomic,strong) NSString *viewCount;
@property (nonatomic,assign) BOOL praiseStatus;
@end
