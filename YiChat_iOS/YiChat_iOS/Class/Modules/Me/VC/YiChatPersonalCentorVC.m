//
//  YiChatPersonalCentorVC.m
//  YiChat_iOS
//
//  Created by mac on 2020/4/19.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatPersonalCentorVC.h"
#import "YiChatPersonalCentorCell.h"
#import "HMSegmentedControl.h"
#import "YiChatPersonalCentorModel.h"
#import "ZFDouYinViewController.h"
@interface YiChatPersonalCentorVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSInteger page;

@property (nonatomic,assign) BOOL isNoData;
@end

@implementation YiChatPersonalCentorVC

+ (id)initialVC{
    YiChatPersonalCentorVC *me = [YiChatPersonalCentorVC initialVCWithNavBarStyle:ProjectNavBarStyleCommon_13 centeritem:PROJECT_TEXT_LOCALIZE_NAME(@"视频管理") leftItem:nil rightItem:nil];
    return me;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.page = 1;
    [self setUI];
    [self loadData:self.type];
}

-(void)setUI{
    self.dataArr = [NSMutableArray new];
    self.dataList = [NSMutableArray new];
    [self.view addSubview:self.collectionView];
//    self.collectionView.mj_header = [MJRefreshHeader ];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerFooterRefresh)];
    UIView *view = [self navBarGetNavBar];
    [self.view bringSubviewToFront:view];
}

- (void)tableViewDidTriggerFooterRefresh {
    if (self.isNoData) {
        return;
    }
    self.page++;
    [self loadData:self.type];
}

-(void)tableViewDidTriggerHeaderRefresh{
    self.page = 1;
    [self.dataArr removeAllObjects];
    [self loadData:self.type];
}

- (void)loadData:(NSString *)type{
    WS(weakSelf);
    NSDictionary *dic = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token page:[NSString stringWithFormat:@"%ld",(long)self.page] pageSize:@"10"];
//     NSDictionary *dic = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    
    
//    0我创建 1好友动态 2我点赞 默认0
    [ProjectRequestHelper getMyListHeaderParameters:dic type:type progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
        
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
            if([obj isKindOfClass:[NSDictionary class]] && obj){
                YiChatPersonalCentorModel *model = [YiChatPersonalCentorModel mj_objectWithKeyValues:obj];
                NSArray *data = REQUEST_DATA(obj);
                [ProjectHelper helper_getMainThread:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.collectionView .mj_footer endRefreshing];
                        if (weakSelf.dataArr.count == model.count) {
                            weakSelf.isNoData = YES;
                            weakSelf.collectionView .mj_footer.hidden = YES;
//                            return;
                            
                        }else{
                            if (model.data.count > 0) {
                                [weakSelf.dataArr addObjectsFromArray:model.data];
                                [weakSelf.dataList addObjectsFromArray:data];
                            }
                        }
                        
                        [weakSelf.collectionView .mj_header endRefreshing];
                        [weakSelf.collectionView  reloadData];
                    });
                }];
//                }
            }
            else if([obj isKindOfClass:[NSString class]]){
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
            }
            else{
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"短视频获取出错"];
            }
        }];
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
//        weakSelf.isLoadingData = NO;
    }];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (PROJECT_SIZE_WIDTH - 1) / 3;
        CGFloat itemH = itemW * 256 / 180;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = 0.1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = PROJECT_COLOR_APPBACKCOLOR;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YiChatPersonalCentorCell class] forCellWithReuseIdentifier:@"YiChatPersonalCentorCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YiChatPersonalCentorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YiChatPersonalCentorCell" forIndexPath:indexPath];
    YiChatPersonalCentorInfoModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZFDouYinViewController *vc = [ZFDouYinViewController initialVCSearchVCType:YiChatShortVideoListTypeMyVideo dataSource:self.dataList];
    [vc playTheIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
