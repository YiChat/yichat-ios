//
//  YiChatInviteListCell.m
//  YiChat_iOS
//
//  Created by mac on 2020/5/6.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatInviteListCell.h"

@interface YiChatInviteListCell ()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *name;
@end

@implementation YiChatInviteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = PROJECT_COLOR_APPBACKCOLOR;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.icon.layer.cornerRadius = 5;
        self.icon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];
    }
    
    return self;
}

-(void)setModel:(YiChatInviteInfoModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@""]];
    self.name.text = model.nick;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
