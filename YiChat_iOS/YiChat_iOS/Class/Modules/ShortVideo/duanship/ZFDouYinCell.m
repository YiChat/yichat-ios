

#import "ZFDouYinCell.h"
#import "UIImageView+ZFCache.h"
#import "UIView+ZFFrame.h"
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "ZFLoadingView.h"
@interface ZFDouYinCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nickLabel;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;


@property (nonatomic,strong) UILabel *likeLa;
@property (nonatomic,strong) UILabel *commentLa;

@property (nonatomic, strong) UIImageView *avatarImageView;
@end

@implementation ZFDouYinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.shareBtn];
        
        WS(weakSelf);
        self.nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nickLabel.textColor = [UIColor whiteColor];
        self.nickLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [self.contentView addSubview:self.nickLabel];
        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel.mas_left).offset(0);
            make.bottom.equalTo(weakSelf.titleLabel.mas_top).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.avatarImageView.layer.cornerRadius = 18;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.likeBtn).offset(0);
            make.bottom.equalTo(weakSelf.likeBtn.mas_top).offset(-30);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        self.likeLa = [self setLa];
        [self.contentView addSubview:self.likeLa];
        [self.likeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.likeBtn).offset(0);
            make.top.equalTo(weakSelf.likeBtn.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
        }];
        
        self.commentLa = [self setLa];
        [self.contentView addSubview:self.commentLa];
        [self.commentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.commentBtn).offset(0);
            make.top.equalTo(weakSelf.commentBtn.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

-(UILabel *)setLa{
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectZero];
    la.textAlignment = NSTextAlignmentCenter;
    la.font = [UIFont systemFontOfSize:12];
    la.textColor = [UIColor whiteColor];
    return la;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
    self.bgImgView.frame = self.contentView.bounds;
    self.effectView.frame = self.bgImgView.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.zf_width;
    CGFloat min_view_h = self.zf_height;
    CGFloat margin = 30;
    
    min_w = 30;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
    min_y = min_view_h - min_h - 80;
    self.shareBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = CGRectGetWidth(self.shareBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.shareBtn.frame);
    min_y = CGRectGetMinY(self.shareBtn.frame) - min_h - margin;
    self.commentBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = CGRectGetWidth(self.shareBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.commentBtn.frame);
    min_y = CGRectGetMinY(self.commentBtn.frame) - min_h - margin;
    self.likeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 20;
    min_h = 50;
    min_y = min_view_h - min_h - 50;
    min_w = self.likeBtn.zf_left - margin;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"shortLikeNo.png"] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

-(void)likeAction{
    if ([self.delegate respondsToSelector:@selector(clickLike:cell:)]) {
        [self.delegate clickLike:self.tag cell:self];
    }
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"评论.png"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

-(void)commentAction{
    if ([self.delegate respondsToSelector:@selector(clickComment:cell:)]) {
        [self.delegate clickComment:self.tag cell:self];
    }
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

-(void)shareAction{
    if ([self.delegate respondsToSelector:@selector(clickShare:)]) {
        [self.delegate clickShare:self.tag];
    }
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
    }
    return _placeholderImage;
}

- (void)setData:(ZFTableData *)data {
    _data = data;
    if (data.thumbnail_width >= data.thumbnail_height) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.coverImageView.clipsToBounds = NO;
    } else {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
    }
    
    self.likeLa.text = data.praseCount;
    self.commentLa.text = data.commentCount;
    [self.coverImageView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"img_video_loading"]];
    [self.bgImgView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"img_video_loading"]];
    self.titleLabel.text = [NSString stringWithFormat:@" #%@",data.title];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:PROJECT_ICON_USERDEFAULT]];
    self.nickLabel.text = [NSString stringWithFormat:@"@%@",data.nick_name];
    
    NSString *likeStr = @"shortLikeNo.png";
    if (data.praiseStatus) {
        likeStr = @"shortLike.png";
    }else{
        likeStr = @"shortLikeNo.png";
    }
    [_likeBtn setImage:[UIImage imageNamed:likeStr] forState:UIControlStateNormal];
}

-(void)refreshComment{
    self.commentLa.text = [NSString stringWithFormat:@"%d",self.commentLa.text.intValue + 1];
}

-(void)refreshCommentCount:(NSInteger)count{
    NSInteger oldCount = self.commentLa.text.intValue;
    if (oldCount == 0) {
        return;
    }

    if (count > oldCount) {
        self.commentLa.text = @"0";
        return;
    }
    [ProjectHelper helper_getMainThread:^{
        self.commentLa.text = [NSString stringWithFormat:@"%ld",oldCount - count];
    }];
}

-(void)refreshLike:(BOOL)isLike count:(NSString *)count{
    self.likeLa.text = count;
    NSString *likeStr = @"shortLikeNo.png";
    if (isLike) {
        likeStr = @"shortLike.png";
    }else{
        likeStr = @"shortLikeNo.png";
    }
    [_likeBtn setImage:[UIImage imageNamed:likeStr] forState:UIControlStateNormal];
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

@end
