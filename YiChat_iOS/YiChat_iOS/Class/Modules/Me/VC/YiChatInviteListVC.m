//
//  YiChatInviteListVC.m
//  YiChat_iOS
//
//  Created by mac on 2020/5/6.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatInviteListVC.h"
#import "YiChatWalletRecordModel.h"
#import "YiChatInviteListCell.h"
#import "YiChatInviteModel.h"
#import "YiChatSearchFriendInfoVC.h"

@interface YiChatInviteListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation YiChatInviteListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray new];
    [self setUI];
    [self reloadata];
    // Do any additional setup after loading the view.
}

+ (id)initialVC{
    YiChatInviteListVC *walletVC = [YiChatInviteListVC initialVCWithNavBarStyle:ProjectNavBarStyleCommon_13 centeritem:PROJECT_TEXT_LOCALIZE_NAME(@"邀请人列表") leftItem:nil rightItem:nil];
    walletVC.hidesBottomBarWhenPushed = YES;
    return walletVC;
}

-(void)setUI{
    self.tableView = [[UITableView alloc]initWithFrame:TableViewRectMake style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.rowHeight = 70;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = PROJECT_COLOR_APPBACKCOLOR;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YiChatInviteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[YiChatInviteListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)reloadata{
    id progress = [ProjectUIHelper ProjectUIHelper_getProgressWithText:@""];
    
    [ProjectRequestHelper userRecommendListWithParameters:@{} headerParameters:[ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token] progress:progress isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
        
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
            if([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *dataDic = (NSDictionary *)obj;
                YiChatInviteModel *model = [YiChatInviteModel mj_objectWithKeyValues:dataDic];
                if (model.code == 0) {
                    [self.dataArray addObjectsFromArray:model.data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }else if([obj isKindOfClass:[NSString class]]){
                [ProjectRequestHelper progressHidden:progress];
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
            }
            [ProjectRequestHelper progressHidden:progress];
        }];
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
    
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YiChatInviteInfoModel *model = self.dataArray[indexPath.row];
    
    YiChatSearchFriendInfoVC *vc = [YiChatSearchFriendInfoVC initialVC];
    vc.userId = model.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
