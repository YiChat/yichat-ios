//
//  YiChatPersonalCentorCellCollectionViewCell.m
//  YiChat_iOS
//
//  Created by mac on 2020/4/19.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatPersonalCentorCell.h"

@interface YiChatPersonalCentorCell ()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *praiseLa;
@end

@implementation YiChatPersonalCentorCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        icon.image = [UIImage imageNamed:@"AlbumLike@3x"];
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.praiseLa = [[UILabel alloc] initWithFrame:CGRectZero];
        self.praiseLa.textColor = [UIColor whiteColor];
        self.praiseLa.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.praiseLa];
        [self.praiseLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(icon.mas_centerY).offset(0);
            make.left.equalTo(icon.mas_right).offset(10);
            make.right.mas_equalTo(-10);
        }];
        
    }
    return self;
}

-(void)setModel:(YiChatPersonalCentorInfoModel *)model{
    _model = model;
    self.praiseLa.text = model.praseCount;
    CGFloat itemW = (PROJECT_SIZE_WIDTH - 1) / 3;
    CGFloat itemH = itemW * 256 / 180;
    NSString *thumb =  [NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_0,f_jpg,w_%.0f,h_%.0f,ar_auto",model.path,itemW,itemH];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage imageNamed:@""]];
}

@end
