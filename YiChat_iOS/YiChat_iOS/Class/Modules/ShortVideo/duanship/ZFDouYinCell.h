

#import <UIKit/UIKit.h>
#import "ZFTableData.h"


@class ZFDouYinCell;

@protocol ZFDouYinCellDelegate <NSObject>

-(void)clickComment:(NSInteger)row  cell:(ZFDouYinCell *)cell;

-(void)clickLike:(NSInteger)row cell:(ZFDouYinCell *)cell;

-(void)clickShare:(NSInteger)row;

@end

@interface ZFDouYinCell : UITableViewCell 

@property (nonatomic,weak) id<ZFDouYinCellDelegate>delegate;

@property (nonatomic, strong) ZFTableData *data;


-(void)refreshLike:(BOOL)isLike count:(NSString *)count;

-(void)refreshComment;

-(void)refreshCommentCount:(NSInteger)count;
@end
