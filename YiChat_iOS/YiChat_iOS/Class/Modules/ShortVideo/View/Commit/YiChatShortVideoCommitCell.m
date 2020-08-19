//
//  YiChatShortVideoCommitCell.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatShortVideoCommitCell.h"
#import "YiChatShortVideoSubCommitDataSource.h"
#import "YiChatCommitUI.h"

@interface YiChatShortVideoCommitCell ()

@property (nonatomic,weak) YiChatCommitUI *commitUI;

@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *nick;
@property (nonatomic,strong) UIImageView *icon;

@property (nonatomic,strong) UIView *commitBack;

@property (nonatomic,strong) UIButton *clickSubCommit;

@end

@implementation YiChatShortVideoCommitCell

+ (id)initialWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath cellHeight:(NSNumber *)cellHeight cellWidth:(nonnull NSNumber *)cellWidth isHasDownLine:(nonnull NSNumber *)isHasDownLine isHasRightArrow:(nonnull NSNumber *)isHasRightArrow type:(NSInteger)type{
    return [[self alloc] initWithStyle:style reuseIdentifier:reuseIdentifier indexPath:indexPath cellHeight:cellHeight cellWidth:cellWidth isHasDownLine:isHasDownLine isHasRightArrow:isHasRightArrow  type:type];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath cellHeight:(NSNumber *)cellHeight cellWidth:(NSNumber *)cellWidth isHasDownLine:(nonnull NSNumber *)isHasDownLine isHasRightArrow:(nonnull NSNumber *)isHasRightArrow type:(NSInteger)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier indexPath:indexPath cellHeight:cellHeight cellWidth:cellWidth];
    if(self){
        _commitUI = [YiChatCommitUI getUIConfig];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(_commitUI.commitListUserIconSize.width + _commitUI.horizontalBlankW * 2, 0, self.sCellWidth - _commitUI.commitListUserIconSize.width + _commitUI.horizontalBlankW * 3 , _commitUI.commitListUserIconSize.height)];
    _commitBack = back;
    [self.contentView addSubview:back];
    
    UIImageView *icon = [ProjectHelper helper_factoryMakeImageViewWithFrame:CGRectMake(0, 0.0, _commitUI.subCommitListUserIconSize.width, _commitUI.subCommitListUserIconSize.height) andImg:nil];
    [back addSubview:icon];
    icon.layer.cornerRadius = _commitUI.subCommitListUserIconSize.height / 2;
    icon.clipsToBounds = YES;
    _icon = icon;
    
    UILabel *nick = [ProjectHelper helper_factoryMakeLabelWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + _commitUI.horizontalBlankW, icon.frame.origin.y + icon.frame.size.height /2 - icon.frame.size.height / 2, 150.0, icon.frame.size.height) andfont:_commitUI.commitListUserNameFont textColor:_commitUI.commitListUserNameColor textAlignment:NSTextAlignmentLeft];
    [back addSubview:nick];
    _nick = nick;
    
    UILabel *content = [ProjectHelper helper_factoryMakeLabelWithFrame:CGRectMake(nick.frame.origin.x, nick.frame.origin.y + nick.frame.size.height, 0,0) andfont:_commitUI.commitListContentFont textColor:_commitUI.commitListContentColor textAlignment:NSTextAlignmentLeft];
    [back addSubview:content];
    content.numberOfLines = 0;
    _content = content;
    
    UIButton *clickSub = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickSub setTitleColor:PROJECT_COLOR_TEXTCOLOR_BLACK forState:UIControlStateNormal];
    clickSub.tintColor = [UIColor clearColor];
    [self.contentView addSubview:clickSub];
    _clickSubCommit = clickSub;
    [clickSub addTarget:self action:@selector(clickReply:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickReply:(UIButton *)btn{
    if(self.yichatshortVideoReply){
        self.yichatshortVideoReply(_dataSource);
    }
}

- (void)setDataSource:(YiChatShortVideoSubCommitDataSource *)dataSource{
    if(dataSource && [dataSource isKindOfClass:[YiChatShortVideoSubCommitDataSource class]]){
        _dataSource = dataSource;
        
        
        _commitBack.frame = CGRectMake(_commitBack.frame.origin.x, _commitBack.frame.origin.y, _commitBack.frame.size.width, dataSource.getCellH);
        
        
        _dataSource = dataSource;
        YiChatShortVideoSubCommitDataSource *data = dataSource;
        _content.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y, data.commitContentRect.size.width, data.commitContentRect.size.height);
        
        _clickSubCommit.frame = CGRectMake(_commitBack.frame.origin.x + _content.frame.origin.x, _content.frame.origin.y, _content.frame.size.width, _content.frame.size.height);
        
        _nick.text = data.appearUserName;
        _content.attributedText = data.appearContent;
        
        [_icon sd_setImageWithURL:[NSURL URLWithString:data.appearIconUrl] placeholderImage:[UIImage imageNamed:PROJECT_ICON_USERDEFAULT]];
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
