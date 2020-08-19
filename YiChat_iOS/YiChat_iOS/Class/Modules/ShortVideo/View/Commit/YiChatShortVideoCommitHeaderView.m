//
//  YiChatShortVideoCommitHeaderView.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/16.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatShortVideoCommitHeaderView.h"
#import "YiChatShortVideoDataSource.h"
#import "YiChatCommitUI.h"
@interface YiChatShortVideoCommitHeaderView ()
@property (nonatomic,weak) YiChatCommitUI *commitUI;

@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *nick;
@property (nonatomic,strong) UIImageView *icon;

@property (nonatomic,strong) UIView *commitBack;

@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIButton *clickSubCommit;

@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UILabel *praiseLab;
@end

@implementation YiChatShortVideoCommitHeaderView

+ (id)initialWithReuseIdentifier:(NSString *)reuseIdentifier type:(NSNumber *)type{
    return [[self alloc] initWithReuseIdentifier:reuseIdentifier type:type.integerValue];
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        _commitUI = [YiChatCommitUI getUIConfig];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createUI{
   
    UIView *back = [[UIView alloc] initWithFrame:self.contentView.bounds];
    _commitBack = back;
    back.userInteractionEnabled = YES;
    [self.contentView addSubview:back];
    
    UIImageView *icon = [ProjectHelper helper_factoryMakeImageViewWithFrame:CGRectMake(_commitUI.horizontalBlankW, 5.0, _commitUI.commitListUserIconSize.width, _commitUI.commitListUserIconSize.height) andImg:nil];
    [back addSubview:icon];
    icon.layer.cornerRadius = _commitUI.commitListUserIconSize.height / 2;
    icon.clipsToBounds = YES;
    icon.userInteractionEnabled = NO;
    _icon = icon;
    
    UILabel *nick = [ProjectHelper helper_factoryMakeLabelWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + _commitUI.horizontalBlankW,5.0, 200.0, icon.frame.size.height) andfont:_commitUI.commitListUserNameFont textColor:_commitUI.commitListUserNameColor textAlignment:NSTextAlignmentLeft];
    [back addSubview:nick];
    _nick = nick;
    
    UILabel *content = [ProjectHelper helper_factoryMakeLabelWithFrame:CGRectMake(nick.frame.origin.x, nick.frame.origin.y + nick.frame.size.height, 0,0) andfont:_commitUI.commitListContentFont textColor:_commitUI.commitListContentColor textAlignment:NSTextAlignmentLeft];
    [back addSubview:content];
    content.numberOfLines = 0;
    _content = content;
    
    UIButton *clickSub = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clickSub setTitleColor:PROJECT_COLOR_TEXTCOLOR_BLACK forState:UIControlStateNormal];
    clickSub.tintColor = [UIColor clearColor];
    [self.contentView addSubview:clickSub];
    clickSub.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    clickSub.titleLabel.font = _commitUI.commitListContentFont;
    _clickSubCommit = clickSub;
    [clickSub addTarget:self action:@selector(clickSubMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.backgroundColor = [UIColor clearColor];
    clearBtn.frame = back.bounds;
    [clearBtn addTarget:self action:@selector(replyBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    _replyBtn = clearBtn;
    [self.contentView addSubview:clearBtn];
    
    UIButton *praiseIcon = [ProjectHelper helper_factoryMakeButtonWithFrame:CGRectMake(self.contentView.frame.size.width - _commitUI.horizontalBlankW - 40.0, 5.0 , 40.0, 40.0) andBtnType:UIButtonTypeCustom];
    praiseIcon.tintColor = [UIColor clearColor];
    [self.contentView addSubview:praiseIcon];
    _praiseBtn = praiseIcon;
    [praiseIcon addTarget:self action:@selector(praiseMethod:) forControlEvents:UIControlEventTouchUpInside];
           
    UILabel *praiseLab = [ProjectHelper helper_factoryMakeLabelWithFrame:CGRectMake(praiseIcon.frame.origin.x + praiseIcon.frame.size.width /2 - 60.0 / 2, praiseIcon.frame.origin.y + praiseIcon.frame.size.height, 60.0, 20.0) andfont:PROJECT_TEXT_FONT_COMMON(13) textColor:PROJECT_COLOR_TEXTCOLOR_BLACK textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:praiseLab];
    _praiseLab = praiseLab;
}

- (void)praiseMethod:(UIButton *)btn{
    if(self.yichatShortVideoClickPraise){
        self.yichatShortVideoClickPraise(_dataSource);
    }
}

- (void)replyBtnMethod:(UIButton *)btn{
    if(self.yichatShortVideoClickReply){
        self.yichatShortVideoClickReply(_dataSource);
    }
}

- (void)clickSubMethod:(UIButton *)btn{
    
    if(self.yichatShortVideoClickShowSubCommit){
        self.yichatShortVideoClickShowSubCommit(YES,_dataSource);
    }
}

- (void)setDataSource:(YiChatShortVideoDataSource *)dataSource{
    if(dataSource && [dataSource isKindOfClass:[YiChatShortVideoDataSource class]]){
        _dataSource = dataSource;
               YiChatShortVideoDataSource *data = dataSource;
        
        _commitBack.frame = CGRectMake(0, 0, PROJECT_SIZE_WIDTH, dataSource.getHeaderH);
        
        _content.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y, data.commitContentRect.size.width, data.commitContentRect.size.height);
        
        _replyBtn.frame = CGRectMake(_commitBack.frame.origin.x+_content.frame.origin.x, _content.frame.origin.y, _content.frame.size.width, _content.frame.size.height);
        
        if(dataSource.isShowClick){
            _clickSubCommit.hidden = NO;
            _clickSubCommit.frame = CGRectMake(_content.frame.origin.x + _commitBack.frame.origin.x, _content.frame.origin.y + _content.frame.size.height, _commitUI.commitListClickSublistSize.width, _commitUI.commitListClickSublistSize.height);
            
            [_clickSubCommit setTitle:[NSString stringWithFormat:@"查看%ld条回复",dataSource.replyNum] forState:UIControlStateNormal];
        }
        else{
            
            [_clickSubCommit setTitle:@"" forState:UIControlStateNormal];
            _clickSubCommit.hidden = YES;
            
        }
        _praiseBtn.frame = CGRectMake(_commitBack.frame.origin.x + _commitBack.frame.size.width - _commitUI.horizontalBlankW - 40.0, 5.0 , 40.0, 40.0);
        _praiseLab.frame = CGRectMake(_praiseBtn.frame.origin.x + _praiseBtn.frame.size.width /2 - 60.0 / 2, _praiseBtn.frame.origin.y + _praiseBtn.frame.size.height - 8.0, 60.0, 20.0);
        
        if(data.originData[@"praiseStatus"] && [data.originData[@"praiseStatus"] isKindOfClass:[NSNumber class]]){
            if([dataSource.originData[@"praiseStatus"] integerValue] == 1){
                       [_praiseBtn setImage:[UIImage imageNamed:@"news_dynamic_like@3x.png"] forState:UIControlStateNormal];
                   }
            else{
               [_praiseBtn setImage:[UIImage imageNamed:@"Like@3x.png"] forState:UIControlStateNormal];
            }
        }
       
        else{
             [_praiseBtn setImage:[UIImage imageNamed:@"Like@3x.png"] forState:UIControlStateNormal];
        }
        NSInteger praiseNum = dataSource.praiseNum;
        _praiseLab.text = [NSString stringWithFormat:@"%ld",praiseNum];
        
        
        _nick.text = data.appearUserName;
                      _content.attributedText = data.appearContent;
                      
        [_icon sd_setImageWithURL:[NSURL URLWithString:data.appearIconUrl] placeholderImage:[UIImage imageNamed:PROJECT_ICON_USERDEFAULT]];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
