

#import "ZFDouYinViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFTableData.h"
#import "ZFDouYinCell.h"
#import "ZFDouYinControlView.h"
#import <MJRefresh/MJRefresh.h>
#import "YiChatPersonalCentorModel.h"
#import "YiChatShortVideoCommitView.h"
#import "YiChatSendShortVideoVC.h"
static NSString *kIdentifier = @"kIdentifier";

@interface ZFDouYinViewController ()  <UITableViewDelegate,UITableViewDataSource,ZFDouYinCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic,strong) YiChatShortVideoCommitView *commitView;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic,strong) KLCPopup *bgview;

@property (nonatomic,strong) UIView *alert;

@property (nonatomic,strong) ZFDouYinCell *visibleCell;

@property (nonatomic,assign) NSInteger cellRow;

@property (nonatomic,strong) NSString *vID;

@property (nonatomic,strong) NSIndexPath *path;

@property (nonatomic,assign) BOOL isScroll;

@property (nonatomic,assign) BOOL isFirst;
@end

@implementation ZFDouYinViewController

+ (id)initialVC{

    ZFDouYinViewController*shortVideo = [self initialVCWithNavBarStyle:ProjectNavBarStyleCommon_12 centeritem:@"YiChat" leftItem:@"奖励规则" rightItem:[UIImage imageNamed:@"拍照.png"]];
    shortVideo.type = YiChatShortVideoListTypeViewList;
    shortVideo.sType = 1;
    return shortVideo;
}

+ (id)initialVCSearchVCType:(YiChatShortVideoListType)type dataSource:(NSArray *)data{
    ZFDouYinViewController*shortVideo = [self initialVCWithNavBarStyle:ProjectNavBarStyleCommon_14 centeritem:@"YiChat" leftItem:nil rightItem:nil];
    shortVideo.type = type;
    shortVideo.viewDataList = data;
    return shortVideo;
}

- (YiChatShortVideoCommitView *)commitView{
    if(!_commitView){
        _commitView = [YiChatShortVideoCommitView createWithFrame];
    }
    return _commitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.isFirst = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    self.dataList = [NSMutableArray new];
    if (self.type == YiChatShortVideoListTypeViewList) {
        [self requestData];
    }
    
//    [self shortInfo:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendVidioBack) name:@"SENDVIDIO" object:nil];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [app.window addSubview:self.commitView];
    WS(weakSelf);
    self.commitView.refeshCommit = ^(NSInteger count) {
        ZFTableData *model = weakSelf.dataSource[weakSelf.cellRow];
        
        model.commentCount = [NSString stringWithFormat:@"%ld",model.commentCount.intValue - count];
        
        [ProjectHelper helper_getMainThread:^{
            
            [weakSelf.visibleCell refreshCommentCount:count];
        }];
    };
    [self.commitView initialText];
    [self.commitView deactiveHidden];
    if (self.type == YiChatShortVideoListTypeViewList) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.mj_header = header;
    }
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.assetURLs = self.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
//    WS(weakSelf);
    self.controlView.playBlock = ^(NSString *videoId) {
        if ([weakSelf.vID isEqualToString:videoId]) {
            return;
        }
        weakSelf.vID = videoId;
        [weakSelf uploadPlayStateWithVideoId:videoId.intValue];
    };
//    [self.player seekToTime:1 completionHandler:^(BOOL finished) {
        
//    }];
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 0;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    
    self.player.presentationSizeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
        @strongify(self)
        if (size.width >= size.height) {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
        } else {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
        }
    };
    
    /// 停止的时候找出最合适的播放
    self.player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.player.playingIndexPath) return;
        if (indexPath.row == self.dataSource.count - 3) {
            /// 加载下一页数据
            if (self.type == YiChatShortVideoListTypeViewList) {
                [self requestData];
            }
            
//            self.player.assetURLs = self.urls;
            
//            [UIView performWithoutAnimation:^{
//                [self.tableView reloadData];
//            }];
            
        }
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTab) name:@"SELECTETAB" object:nil];
}

-(void)selectedTab{
    [self loadNewData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    self.backBtn.frame = CGRectMake(15, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), 36, 36);
}

- (void)loadNewData {
    [self.dataSource removeAllObjects];
    [self.urls removeAllObjects];
    [self.dataList removeAllObjects];
    self.isFirst = YES;
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
        [self.player stopCurrentPlayingCell];
        [self requestData];
        [UIView performWithoutAnimation:^{
            [self.tableView reloadData];
        }];
        /// 找到可以播放的视频并播放
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    });
}

- (void)requestData {
    WS(weakSelf);
    NSDictionary *dic = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    [ProjectRequestHelper getShortVideoHeaderParameters:dic type:[NSString stringWithFormat:@"%ld",self.sType] progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
                
            weakSelf.isScroll = YES;
            [ProjectHelper helper_getMainThread:^{
                [self.tableView.mj_header endRefreshing];
            }];
            if([obj isKindOfClass:[NSDictionary class]] && obj){
                YiChatPersonalCentorModel *model = [YiChatPersonalCentorModel mj_objectWithKeyValues:obj];
                if(model.data && [model.data isKindOfClass:[NSArray class]]){
                    if(model.data.count == 0){
                        [ProjectHelper helper_getMainThread:^{
                            [weakSelf.tableView reloadData];
                        }];
                    }else{
                        
                        NSArray *dataD = REQUEST_DATA(obj);
                        NSMutableArray *oldArr = [NSMutableArray new];
                        for (ZFTableData *oldM in weakSelf.dataSource) {
                            [oldArr addObject:oldM.videoId];
                        }
                        for (int i = 0; i < model.data.count; i ++) {
                            YiChatPersonalCentorInfoModel *infoModel = model.data[i];

                            ZFTableData *data = [self changModel:infoModel];
                            NSDictionary *dic = dataD[i];
                            NSString *URLString = [data.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                            NSURL *url = [NSURL URLWithString:URLString];
                            if(infoModel.path && [infoModel.path isKindOfClass:[NSString class]]){
                                NSString *videoThumbUrl = [NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_0,f_jpg,ar_auto",infoModel.path];
                                [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:videoThumbUrl] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                }];
                            }
                            
                            
                            if (![oldArr containsObject:data.videoId]) {
                                [weakSelf.dataList addObject:dic];
                                [weakSelf.urls addObject:url];
                                [weakSelf.dataSource addObject:data];
                            }
                        }
                        
                        weakSelf.player.assetURLs = weakSelf.urls;
                        [ProjectHelper helper_getMainThread:^{
                            [weakSelf.tableView reloadData];
                            if (weakSelf.isFirst) {
                                [weakSelf playTheVideoAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] scrollToTop:NO];
                                weakSelf.isFirst = NO;
                            }
                        }];
                    }
                }
            }
            else if([obj isKindOfClass:[NSString class]]){
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
                [ProjectHelper helper_getMainThread:^{
                    [weakSelf.tableView reloadData];
                }];
            }
            else{
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"短视频获取出错"];
                [ProjectHelper helper_getMainThread:^{
                    [weakSelf.tableView reloadData];
                }];
            }
        }];
        
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
        weakSelf.isScroll = YES;
        [ProjectHelper helper_getMainThread:^{
            [weakSelf.tableView reloadData];
        }];
    }];
}

- (void)playTheIndex:(NSInteger)index {
    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    /// 如果是最后一行，去请求新数据
    if (index == self.dataSource.count - 2 && self.type == YiChatShortVideoListTypeViewList) {
        /// 加载下一页数据
        [self requestData];
        self.player.assetURLs = self.urls;
        [UIView performWithoutAnimation:^{
            [self.tableView reloadData];
        }];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];

}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFDouYinCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (cell == nil) {
        cell = [[ZFDouYinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
    cell.data = self.dataSource[indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - ZFTableViewCellDelegate

//- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
//
//    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
//}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    ZFTableData *data = self.dataSource[indexPath.row];
    self.controlView.videoId = data.videoId;
    [self.controlView showCoverViewWithUrl:data.thumbnail_url withImageMode:UIViewContentModeScaleAspectFill];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat w = PROJECT_SIZE_WIDTH;
        CGFloat h = PROJECT_SIZE_HEIGHT - PROJECT_SIZE_TABH - PROJECT_SIZE_SafeAreaInset.bottom;
        CGRect rect = CGRectMake(0, 0, w, h);
        if(_type != YiChatShortVideoListTypeViewList){
            h =  PROJECT_SIZE_HEIGHT - (PROJECT_SIZE_NAVH + PROJECT_SIZE_STATUSH  + PROJECT_SIZE_SafeAreaInset.bottom);
            rect = CGRectMake(0, PROJECT_SIZE_NAVH + PROJECT_SIZE_STATUSH, w, h);
        }
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
//        [_tableView registerClass:[ZFDouYinCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.frame = rect;
        _tableView.rowHeight = h;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
    }
    return _controlView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = @[].mutableCopy;
    }
    return _urls;
}

//- (UIButton *)backBtn {
//    if (!_backBtn) {
//        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_backBtn setImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
//        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backBtn;
//}

-(void)clickShare:(NSInteger)row{
    ZFTableData *data = self.dataSource[row];
    WS(weakSelf);
    [ProjectUIHelper ProjectUIHelper_getAlertWithAlertMessage:@"分享至好友圈？" clickBtns:@[@"取消",@"确定"] invocation:^(NSInteger row) {
        if(row == 1){
            NSString *videoUrl = data.video_url;
            NSString *content = @"我分享了一个有意思的短视频，快来围观～";
            if(videoUrl && [videoUrl isKindOfClass:[NSString class]]){
                [weakSelf sendDynamicsWithResourceStr:videoUrl content:content location:nil type:1];
            }
        }
    }];
}

- (void)sendDynamicsWithResourceStr:(NSString *)resource content:(NSString *)content location:(NSString *)location type:(NSInteger)type{
    NSString *videoUrl = nil;
    NSString *imgsUrl = nil;
    if(type == 0){
        imgsUrl = resource;
    }
    else{
        videoUrl = resource;
    }
    NSDictionary *param = [ProjectRequestParameterModel sendDynamicWithimgs:imgsUrl videos:videoUrl content:content location:location];
    
    id progress = [ProjectUIHelper ProjectUIHelper_getProgressWithText:@""];
    
    [ProjectRequestHelper sendDynamicWithParameters:param headerParameters:[ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token] progress:progress isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
        
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
            if([obj isKindOfClass:[NSDictionary class]] && obj){
                [ProjectHelper helper_getMainThread:^{
                    
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"分享短视频成功"];
                    
                }];
            }
            else if([obj isKindOfClass:[NSString class]]){
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
            }
            else{
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"分享短视频出错"];
            }
        }];
        
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
        [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:error];
    }];
    
}

-(void)clickComment:(NSInteger)row cell:(ZFDouYinCell *)cell{
    WS(weakSelf);
    ZFTableData *model = self.dataSource[row];
    self.visibleCell = cell;
    self.cellRow = row;
    if(weakSelf.dataList.count - 1 >= row){
        [weakSelf.commitView activeshowWithData:weakSelf.dataList[row] backBlocked:^(BOOL isNeedRefeshCommit) {
            if(isNeedRefeshCommit){
                [ProjectHelper helper_getMainThread:^{
                    [cell refreshComment];
                    model.commentCount = [NSString stringWithFormat:@"%d",model.commentCount.intValue + 1];
                }];
            }
        }];
    }
}

-(void)clickLike:(NSInteger)row cell:(ZFDouYinCell *)cell{
    ZFTableData *model = self.dataSource[row];
    NSDictionary *token = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    [ProjectRequestHelper praiseShortVideoWithVideoId:model.videoId.intValue headerParameters:token progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
        
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
         [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
                   
             if([obj isKindOfClass:[NSDictionary class]] && obj){
                 if (model.praiseStatus) {
                     model.praiseStatus = NO;
                     model.praseCount = [NSString stringWithFormat:@"%d",model.praseCount.intValue - 1];
                 }else{
                     model.praiseStatus = YES;
                     model.praseCount = [NSString stringWithFormat:@"%d",model.praseCount.intValue + 1];
                 }
                   
                 [ProjectHelper helper_getMainThread:^{
                     [cell refreshLike:model.praiseStatus count:model.praseCount];
                 }];
                 
                 NSString *res_data = obj[@"msg"];
                 if(res_data && [res_data isKindOfClass:[NSString class]]){
                     if(res_data.length > 0){
                         [ProjectHelper helper_getMainThread:^{
                                                
                             [ProjectUIHelper showActiveAlertUIWithAlertText:res_data blocked:^(KLCPopup * _Nonnull bg, UIView * _Nonnull showView) {
                                 if(_bgview){
                                     [_bgview dismiss:YES];
                                 }
                                 _bgview = bg;
                                                    
                                 [self performSelector:@selector(removeActive:) withObject:bg afterDelay:1];
                             }];
                         }];
                     }
                 }
                 
             }else if([obj isKindOfClass:[NSString class]]){
                       
                 [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
                   
             }
                   
             else{
                       
                 [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"短视频点赞出错"];
                   
             }

                    
             return ;
               
         }];
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {

    }];
}

- (void)removeActive:(KLCPopup *)bg{
    [bg dismiss:YES];
}

- (void)uploadPlayStateWithVideoId:(NSInteger)videoId{
    
    NSDictionary *dic = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    
    [ProjectRequestHelper playVideoWithVideoId:videoId headerParameters:dic progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
        
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
            if(obj && [obj isKindOfClass:[NSDictionary class]]){
                NSString *res_data = obj[@"msg"];
                if(res_data && [res_data isKindOfClass:[NSString class]]){
                    if(res_data.length > 0){
                        [ProjectHelper helper_getMainThread:^{
                                               
                            [ProjectUIHelper showActiveAlertUIWithAlertText:res_data blocked:^(KLCPopup * _Nonnull bg, UIView * _Nonnull showView) {
                                if(_bgview){
                                    [_bgview dismiss:YES];
                                }
                                _bgview = bg;
                                                   
                                [self performSelector:@selector(removeActive:) withObject:bg afterDelay:1];
                            }];
                        }];
                    }
                }
            }
        }];
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
        
    }];
}

-(void)setViewDataList:(NSArray *)viewDataList{
    _viewDataList = viewDataList;

    WS(weakSelf);
    for (int i = 0; i < viewDataList.count; i ++) {
        NSDictionary *dic = viewDataList[i];
        YiChatPersonalCentorInfoModel *infoModel = [YiChatPersonalCentorInfoModel mj_objectWithKeyValues:dic];
        ZFTableData *data = [self changModel:infoModel];
        NSString *URLString = [data.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:URLString];
        [weakSelf.urls addObject:url];
        [self.dataSource addObject:data];
        
        if(infoModel.path && [infoModel.path isKindOfClass:[NSString class]]){
            NSString *videoThumbUrl = [NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_0,f_jpg,ar_auto",infoModel.path];
            [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:videoThumbUrl] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            }];
        }
    }
    [weakSelf.dataList addObjectsFromArray:viewDataList];
    [ProjectHelper helper_getMainThread:^{
        [weakSelf.tableView reloadData];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.controlView stop];
}

-(void)sendVidioBack{
    WS(weakSelf);
    NSArray *arr = self.tableView.visibleCells;
    NSIndexPath *path = [self.tableView indexPathForCell:arr.firstObject];
    
    YiChatSendShortVideoVC *vc = [YiChatSendShortVideoVC initialVC];
    vc.hidesBottomBarWhenPushed = YES;
    vc.yichatSendShortVideoSuccess = ^(NSDictionary * _Nonnull dic) {
        if (self.type == YiChatShortVideoListTypeViewList) {
            if(dic && [dic isKindOfClass:[NSDictionary class]]){
                NSDictionary *dataDic = dic[@"data"];
                if (!dataDic) {
                    return;
                }
                
                YiChatPersonalCentorInfoModel *infoModel = [YiChatPersonalCentorInfoModel mj_objectWithKeyValues:dataDic];
                ZFTableData *data = [self changModel:infoModel];
                if(weakSelf.dataList.count == 0){
                    [weakSelf.dataList addObject:dic];
                    [weakSelf.dataSource addObject:data];
                    [weakSelf.urls addObject:data.video_url];
                }
                else{
                    [weakSelf.dataList insertObject:dic atIndex:path.row];
                    [weakSelf.dataSource insertObject:data atIndex:path.row];
                    [weakSelf.urls insertObject:data.video_url atIndex:path.row];
                }
                
                [ProjectHelper helper_getMainThread:^{
                    [weakSelf.tableView reloadData];
                    CGPoint point = weakSelf.tableView.contentOffset;
                    [weakSelf.tableView setContentOffset:CGPointMake(point.x, point.y - 1)];
                    [UIView animateWithDuration:0.1 animations:^{
                        [weakSelf.tableView setContentOffset:point];
                    }];
                    
                }];
            }
        }
        
    };
    vc.modalPresentationStyle = 0;
    if(vc){
        [self presentViewController:vc animated:YES completion:^{

        }];
    }
}

-(ZFTableData *)changModel:(YiChatPersonalCentorInfoModel *)infoModel{
    CGFloat w = PROJECT_SIZE_WIDTH;
    CGFloat h = PROJECT_SIZE_HEIGHT - PROJECT_SIZE_TABH - PROJECT_SIZE_SafeAreaInset.bottom;
    CGRect rect = CGRectMake(0, 0, w, h);
    if(_type != YiChatShortVideoListTypeViewList){
        h =  PROJECT_SIZE_HEIGHT - (PROJECT_SIZE_NAVH + PROJECT_SIZE_STATUSH  + PROJECT_SIZE_SafeAreaInset.bottom);
        rect = CGRectMake(0, PROJECT_SIZE_NAVH + PROJECT_SIZE_STATUSH, w, h);
    }
    ZFTableData *data = [ZFTableData new];
    data.video_width = w;
    data.video_height = h;
    data.thumbnail_url = [NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_0,f_jpg,ar_auto",infoModel.path];
    data.title = infoModel.content;
    data.nick_name = infoModel.nick;
    data.thumbnail_width = w;
    data.thumbnail_height = h;
    data.commentCount = infoModel.commentCount;
    data.praseCount = infoModel.praseCount;
    data.avatar = infoModel.avatar;
    data.praiseStatus = infoModel.praiseStatus;
    data.userId = infoModel.userId;
    data.videoId = infoModel.videoId;
    data.video_url = infoModel.path;
    return data;
}

@end
