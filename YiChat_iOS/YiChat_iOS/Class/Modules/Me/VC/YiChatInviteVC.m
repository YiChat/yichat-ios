//
//  YiChatInviteVC.m
//  YiChat_iOS
//
//  Created by mac on 2020/5/6.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatInviteVC.h"
#import "ProjectCommonCellModel.h"
#import "YiChatInviteListVC.h"

@interface YiChatInviteVC ()
@property (nonatomic,strong) NSString *ucode;
@end

@implementation YiChatInviteVC

+ (id)initialVC{
                
    YiChatInviteVC *walletVC = [YiChatInviteVC initialVCWithNavBarStyle:ProjectNavBarStyleCommon_1 centeritem:PROJECT_TEXT_LOCALIZE_NAME(@"") leftItem:nil rightItem:nil];
           walletVC.hidesBottomBarWhenPushed = YES;
    return walletVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImg.image = [UIImage imageNamed:@"bg_page_fulls"];
    [self.view addSubview:bgImg];
    
    [self setUI];
    
    // Do any additional setup after loading the view.
}


-(void)setUI{
//    PROJECT_SIZE_STATUSH + PROJECT_SIZE_NAVH
    CGFloat top = PROJECT_SIZE_STATUSH + PROJECT_SIZE_NAVH;
    
    UIView *wView = [[UIView alloc] initWithFrame:CGRectZero];
    wView.backgroundColor = [UIColor whiteColor];
    wView.layer.cornerRadius = 8;
    [self.view addSubview:wView];
    [wView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top + 20 + 40);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(370);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    icon.layer.borderColor = [UIColor whiteColor].CGColor;
    icon.layer.borderWidth = 3;
    icon.layer.cornerRadius = 40;
    icon.layer.masksToBounds = YES;
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top + 20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectZero];
    la.text = @"我的邀请码";
    la.textAlignment = NSTextAlignmentCenter;
    la.font = [UIFont systemFontOfSize:18];
    [wView addSubview:la];
    [la mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *ucode = [[UILabel alloc] initWithFrame:CGRectZero];
    ucode.textAlignment = NSTextAlignmentCenter;
    ucode.font = [UIFont fontWithName:@"Helvetica-Bold" size:45];
    [wView addSubview:ucode];
    [ucode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(la.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *cop = [[UIButton alloc] initWithFrame:CGRectZero];
    [cop setTitle:@"复制邀请码" forState:UIControlStateNormal];
    [cop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cop addTarget:self action:@selector(copyUcode) forControlEvents:UIControlEventTouchUpInside];
    cop.titleLabel.font = [UIFont systemFontOfSize:15];
    cop.backgroundColor = [UIColor colorWithRed:110 / 255.0 green:140 / 255.0 blue:222 / 255.0 alpha:1];
    cop.layer.cornerRadius = 8;
    cop.layer.masksToBounds = YES;
    [wView addSubview:cop];
    [cop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ucode.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(50);
    }];
    
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectZero];
    info.text = @"邀请码说明";
    info.textAlignment = NSTextAlignmentCenter;
    info.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [wView addSubview:info];
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cop.mas_bottom).offset(20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *info1 = [[UILabel alloc] initWithFrame:CGRectZero];
    info1.text = @"我邀请的朋友发消息获取奖励，我也能获取一定比例的收益。";
    info1.numberOfLines = 0;
    info1.textAlignment = NSTextAlignmentCenter;
    info1.font = [UIFont systemFontOfSize:14];
    [wView addSubview:info1];
    [info1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(info.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(50);
    }];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectZero];
    bg.layer.masksToBounds = YES;
    bg.layer.cornerRadius = 8;
    bg.layer.borderColor = [UIColor whiteColor].CGColor;
    bg.layer.borderWidth = 2;
    [self.view addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *la1 = [[UILabel alloc] initWithFrame:CGRectZero];
    la1.text = @"我邀请了";
    la1.textColor = [UIColor whiteColor];
    [bg addSubview:la1];
    [la1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *la2 = [[UILabel alloc] initWithFrame:CGRectZero];
    
    la2.textColor = [UIColor whiteColor];
    [bg addSubview:la2];
    [la2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(20);
    }];
    
    WS(weakSelf);
    [[YiChatUserManager defaultManagaer] fetchUserInfoWithUserId:YiChatUserInfo_UserIdStr invocation:^(YiChatUserModel * _Nonnull modelUser, NSString * _Nonnull error) {
        [ProjectHelper helper_getMainThread:^{
            [icon sd_setImageWithURL:[NSURL URLWithString:[modelUser userIcon]]];
            ucode.text =
            weakSelf.ucode = [modelUser ucodeStr];
            la2.text = [NSString stringWithFormat:@"%@人",[modelUser recommendCountStr]];
        }];
    }];
    
    UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow"]];
    [bg addSubview:im];
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIButton *jump = [[UIButton alloc] initWithFrame:CGRectZero];
    [jump addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:jump];
    [jump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *view = [self navBarGetNavBar];
    view.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:view];
}

-(void)jump{
    YiChatInviteListVC *vc = [YiChatInviteListVC initialVC];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)copyUcode{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.ucode;
    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"复制成功"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
