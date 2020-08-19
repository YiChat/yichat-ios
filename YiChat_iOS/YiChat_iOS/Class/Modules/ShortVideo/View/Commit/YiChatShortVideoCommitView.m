//
//  YiChatShortVideoCommitView.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/15.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatShortVideoCommitView.h"
#import "YiChatDynamicCommitView.h"
#import "YiChatShortVideoDataSource.h"
#import "YiChatShortVideoSubCommitDataSource.h"
#import "YiChatCommitUI.h"
#import "YiChatShortVideoCommitCell.h"
#import "UIButton+BtnCategory.h"
#import "YiChatShortVideoCommitHeaderView.h"
#import <MJRefresh/MJRefresh.h>



@interface YiChatShortVideoCommitView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UITableView *table;

@property (nonatomic,strong) id videoDic;

@property (nonatomic,strong) KLCPopup *bgview;

@property (nonatomic,strong) YiChatDynamicCommitView *commitView;
@property (nonatomic,assign) NSInteger videoId;
@property (nonatomic,assign) NSInteger pageNo;
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,weak) YiChatCommitUI* commitUI;

@property (nonatomic,strong) NSMutableArray <YiChatShortVideoDataSource *>*commitlist;

@property (nonatomic,copy) void(^commitCallBack)(BOOL isNeedRefeshCommit);

@property (nonatomic,assign) BOOL isLoadingCommitList;


@end

@implementation YiChatShortVideoCommitView

+ (id)createWithFrame{
    return [self appearWithControlUIFrame:CGRectMake(0, PROJECT_SIZE_HEIGHT * 0.4, PROJECT_SIZE_WIDTH, PROJECT_SIZE_HEIGHT * 0.6 - PROJECT_SIZE_SafeAreaInset.bottom)];
}

- (void)makeUI{
    
    _isLoadingCommitList = NO;
    
    self.controlUIBackView.backgroundColor = [UIColor whiteColor];
    self.commitlist = [NSMutableArray arrayWithCapacity:0];
    self.commitUI = [YiChatCommitUI getUIConfig];
    
    UILabel *title = [ProjectHelper helper_factoryMakeLabelWithFrame:CGRectMake(0, 0, self.frame.size.width, 30.0) andfont:PROJECT_TEXT_FONT_COMMON(13) textColor:PROJECT_COLOR_TEXTCOLOR_BLACK textAlignment:NSTextAlignmentCenter];
    self.addSubView(title);
    _title = title;
    title.text = @"评论列表";
    
    self.addSubView(self.table);
    
    UIView *commit = [[UIView alloc] initWithFrame:CGRectMake(0, self.table.frame.origin.y + self.table.frame.size.height, self.table.frame.size.width, 50.0)];
    self.addSubView(commit);
    commit.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(PROJECT_SIZE_NAV_BLANK, 10, 300.0, commit.frame.size.height - 20.0)];
    la.text = @"有爱评论,说点儿好听的吧...";
    la.font = [UIFont systemFontOfSize:14];
    [commit addSubview:la];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setTitle:@"有爱评论,说点儿好听的吧..." forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commit addSubview:btn];
    btn.tintColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, self.table.frame.size.width, 50.0);
    [btn addTarget:self action:@selector(commitMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line = [ProjectHelper helper_factoryMakeHorizontalLineWithPoint:CGPointMake(0, self.table.frame.origin.y + self.table.frame.size.height) width:self.table.frame.size.width];
    
    self.addSubView(line);
    
    
}

- (void)activeshowWithData:(NSDictionary *)videoDic backBlocked:(void(^)(BOOL isNeedRefeshCommit))blocked{
    _commitCallBack = blocked;
    
    _videoId = [videoDic[@"videoId"] integerValue];
    _pageNo = 1;
    _pageSize = 20;
    _videoDic = videoDic;
    [self.commitlist removeAllObjects];
    [self.table reloadData];
    
    [self loadData];
    
    [self showAnimateCompletionHandle:^{
        
    }];
}

- (void)loadData{
    if(_isLoadingCommitList == YES){
        return;
    }
    _isLoadingCommitList = YES;
    NSDictionary *token = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    
    [ProjectRequestHelper shortVideoCommitListVideoId:self.videoId pageNo:self.pageNo pageSize:self.pageSize headerParameters:token progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
        
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
            _isLoadingCommitList = NO;
            if([obj isKindOfClass:[NSDictionary class]] && obj){
                NSArray *data = REQUEST_DATA(obj);
                if(data && [data isKindOfClass:[NSArray class]]){
                   
                    [ProjectHelper helper_getMainThread:^{
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                        for (int i = 0; i < data.count; i ++) {
                            YiChatShortVideoDataSource *commitSource = [[YiChatShortVideoDataSource alloc] initWithData:data[i]];
                            [arr addObject:commitSource];
                        }
                        [self.commitlist addObjectsFromArray:arr];
                        
                        self.pageNo ++;
                        
                        [self.table reloadData];
                    }];
                    
                }
            }
            else if([obj isKindOfClass:[NSString class]]){
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
            }
            else{
                if(self.pageNo == 1){
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"短视频评论列表出错"];
                }
            }
        }];
        
        
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
        _isLoadingCommitList = NO;
    }];
}

- (void)initialText{
    [self.superview addSubview:self.commitView];
}

- (void)commitMethod:(UIButton *)btn{
    
    [self.commitView beginActive:nil subCommitId:nil];
    
}

- (UITableView *)table{
    if(!_table){
        _table = [ProjectHelper helper_factoryMakeTableViewWithFrame:CGRectMake(0, 30.0, self.controlUIBackView.frame.size.width, self.controlUIBackView.frame.size.height - 20.0 - 50.0 - 10.0) backgroundColor:[UIColor whiteColor] style:UITableViewStyleGrouped bounces:YES pageEnabled:NO superView:self object:self];
        WS(weakSelf);
        self.table.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
    }
    return _table;
}

- (YiChatDynamicCommitView *)commitView{
    if(!_commitView){
        WS(weakSelf);
        _commitView = [YiChatDynamicCommitView create];
        
        _commitView.YiChatDynamicCommitViewSendFull = ^(NSString * _Nonnull text, NSString * _Nonnull trendId, NSString * _Nonnull subcommitId) {
            NSInteger commitid_value = 0;
            NSInteger subCommitId_value = 0;
            if(trendId && ([trendId isKindOfClass:[NSString class]] || [trendId isKindOfClass:[NSNumber class]])){
                commitid_value = [trendId integerValue];
            }
            if(subcommitId && ([subcommitId isKindOfClass:[NSString class]] || [subcommitId isKindOfClass:[NSNumber class]])){
                subCommitId_value = [subcommitId integerValue];
            }
            [weakSelf sendCommit:text commitId:commitid_value subCommitId:subCommitId_value];
        };
        _commitView.YiChatDynamicCommitViewKeyBoardShow = ^(CGSize keyBoard) {
            
        };
        _commitView.hidden = YES;
    }
    return _commitView;
}

- (void)sendCommit:(NSString *)content commitId:(NSInteger)commitid subCommitId:(NSInteger)subCommitId{
    WS(weakSelf);
    NSDictionary *token = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    NSInteger videoId = [_videoDic[@"videoId"] integerValue];
    [ProjectRequestHelper shortVideoCommitVideoId:videoId content:content commentId:commitid srcCommentId:subCommitId headerParameters:token progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
        
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
            if(obj && [obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *commitData = REQUEST_DATA(obj);
                weakSelf.commitCallBack(YES);
                NSString *alert = obj[@"msg"];
                if(alert && [alert isKindOfClass:[NSString class]]){
                    if(alert.length > 0){
                        [ProjectHelper helper_getMainThread:^{
                            [ProjectUIHelper showActiveAlertUIWithAlertText:alert blocked:^(KLCPopup * _Nonnull bg, UIView * _Nonnull showView) {
                                
                                if(_bgview){
                                    [_bgview dismiss:YES];
                                }
                                _bgview = bg;
                                [self performSelector:@selector(removeActive:) withObject:bg afterDelay:1];
                            }];
                        }];
                    }
                }
                
                if(commitData && [commitData isKindOfClass:[NSDictionary class]]){
                    NSInteger num =[_videoDic[@"commentCount"] intValue] + 1;
                    self.videoDic[@"commentCount"] = [NSString stringWithFormat:@"%ld",num];
                    
                    
                    
                    if(subCommitId == 0 && commitid ==0){
                        [ProjectHelper helper_getMainThread:^{
                                                   YiChatShortVideoDataSource *dataSource = [[YiChatShortVideoDataSource alloc] initWithData:commitData];
                                                   if(self.commitlist.count == 0){
                                                       [self.commitlist addObject:dataSource];
                                                   }else{
                                                       [self.commitlist insertObject:dataSource atIndex:0];
                                                   }
                                                   [self.table reloadData];
                                               }];
                    }
                    else if(subCommitId != 0){
                        self.videoDic[@"replyCount"] = [NSString stringWithFormat:@"%ld",[_videoDic[@"replyCount"] intValue] + 1];
                        
                        for (int i =0; i < self.commitlist.count; i ++) {
                            YiChatShortVideoDataSource *data = self.commitlist[i];
                            data.isShowClick = NO;
                            if([data.originData[@"commentId"] integerValue] == subCommitId){
                                
                               
                                [ProjectHelper helper_getMainThread:^{
                                    YiChatShortVideoSubCommitDataSource *subcomit = [[YiChatShortVideoSubCommitDataSource alloc] initWithData:commitData];
                                    if(data.appearSubCommitList.count != 0){
                                        [data.appearSubCommitList insertObject:subcomit atIndex:0];
                                    }
                                    else{
                                         [data.appearSubCommitList addObject:subcomit];
                                    }
                                    [data update];
                                    [self.table reloadData];
                                }];
                            }
                        }
                    }
                    
                    
                }
               
            }
            else if(obj && [obj isKindOfClass:[NSString class]]){
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
            }
            else{
                [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"评论出错"];
            }
        }];
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
        [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:error];
    }];
}

- (void)removeActive:(KLCPopup *)bg{
    [bg dismiss:YES];
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _commitlist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_commitlist.count - 1 >= section){
        return _commitlist[section].appearSubCommitList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_commitlist.count - 1 >= indexPath.section){
        NSArray <YiChatShortVideoSubCommitDataSource *>*sub = _commitlist[indexPath.section].appearSubCommitList;
        if(sub.count - 1 >= indexPath.row){
            return [sub[indexPath.row] getCellH];
        }
    }
       return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _commitlist[section].getHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _commitlist[section].getFooterH;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YiChatShortVideoCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subcell"];
    CGFloat cellH = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if(!cell){
        
        cell = [YiChatShortVideoCommitCell initialWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subcell" indexPath:indexPath cellHeight:[NSNumber numberWithFloat:cellH] cellWidth:[NSNumber numberWithFloat:self.table.frame.size.width] isHasDownLine:[NSNumber numberWithBool:NO] isHasRightArrow:[NSNumber numberWithBool:NO] type:0];
    }
    [cell updateSystemConfigWithIndexPath:indexPath arrow:[NSNumber numberWithBool:NO] downLine:[NSNumber numberWithBool:NO] cellHeight:[NSNumber numberWithFloat:cellH]];
    WS(weakSelf);
    cell.yichatshortVideoReply = ^(YiChatShortVideoSubCommitDataSource * _Nonnull cellDataSource) {
        
        NSInteger commentId = [cellDataSource.originData[@"commentId"] integerValue];
        
        if ([cellDataSource.userId isEqualToString:YiChatUserInfo_UserIdStr]) {
            [ProjectUIHelper projectActionSheetWithListArr:@[@"评论",@"删除"] click:^(NSInteger row) {
                if (row == 0) {
                    if(weakSelf.commitlist.count- 1 >= indexPath.section){
                        NSString *trendId = cellDataSource.originData[@"commentId"];
                        NSString *topId = weakSelf.commitlist[indexPath.section].originData[@"commentId"];
                          [weakSelf.commitView beginActive:trendId subCommitId:topId];
                    }
                }
             
                if (row == 1) {
                    [weakSelf deleteCommit:commentId dataSource:weakSelf.commitlist[indexPath.section] row:indexPath.row];
                }
             
            }];
        }else{
             if(weakSelf.commitlist.count- 1 >= indexPath.section){
                 NSString *trendId = cellDataSource.originData[@"commentId"];
                 NSString *topId = weakSelf.commitlist[indexPath.section].originData[@"commentId"];
                   [weakSelf.commitView beginActive:trendId subCommitId:topId];
             }
        }
      
    };
     if(_commitlist.count - 1 >= indexPath.section){
           NSArray <YiChatShortVideoSubCommitDataSource *>*sub = _commitlist[indexPath.section].appearSubCommitList;
           if(sub.count - 1 >= indexPath.row){
               cell.dataSource = sub[indexPath.row];
           }
       }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YiChatShortVideoCommitHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if(!header){
        header = [YiChatShortVideoCommitHeaderView  initialWithReuseIdentifier:@"header" type:[NSNumber numberWithInt:0]];
        [header createUI];
    }
    WS(weakSelf);
    header.yichatShortVideoClickPraise = ^(YiChatShortVideoDataSource * _Nonnull dataSource) {
        [weakSelf praiseCommit:[dataSource.originData[@"commentId"] integerValue] dataSource:dataSource];
    };
    header.yichatShortVideoClickReply = ^(YiChatShortVideoDataSource * _Nonnull dataSource) {
        
        NSInteger commentId = [dataSource.originData[@"commentId"] integerValue];
        if ([dataSource.userId isEqualToString:YiChatUserInfo_UserIdStr]) {
            [ProjectUIHelper projectActionSheetWithListArr:@[@"评论",@"删除"] click:^(NSInteger row) {
                if (row == 0) {
                        
                    [weakSelf.commitView beginActive:[NSString stringWithFormat:@"%ld",commentId] subCommitId:[NSString stringWithFormat:@"%ld",commentId]];
                 
                }
             
                if (row == 1) {
                    [weakSelf deleteCommit:commentId dataSource:dataSource row:-1];
                }
             
            }];
        }else{
             [weakSelf.commitView beginActive:[NSString stringWithFormat:@"%ld",commentId] subCommitId:[NSString stringWithFormat:@"%ld",commentId]];
        }
    };
    header.yichatShortVideoClickShowSubCommit = ^(BOOL isShow, YiChatShortVideoDataSource * _Nonnull dataSource) {
       //获取子评论列表
        dataSource.subCommitPageNo = 1;
        [self loadSubCommitListWithDataSource:dataSource];
        
    };
    if(self.commitlist.count -1 >= section){
        header.dataSource = self.commitlist[section];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CGFloat footer = [self tableView:tableView heightForFooterInSection:section];
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, footer)];
    
    if(self.commitlist.count -1 >= section){
        YiChatShortVideoDataSource *dataSource = self.commitlist[section];
        
        if(dataSource.isShowMoreSubCommit){
            UIButton *clickSub = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                 [clickSub setTitleColor:PROJECT_COLOR_TEXTCOLOR_BLACK forState:UIControlStateNormal];
                 clickSub.tintColor = [UIColor clearColor];
                 [back addSubview:clickSub];
              clickSub.frame = CGRectMake(_commitUI.commitListUserIconSize.width + _commitUI.horizontalBlankW * 2, 5, back.frame.size.width - (_commitUI.commitListUserIconSize.width + _commitUI.horizontalBlankW * 2), footer - 10.0);
              [clickSub setTitle:@"查看更多回复" forState:UIControlStateNormal];
              [clickSub addTarget:self action:@selector(searchSubCommitMore:) forControlEvents:UIControlEventTouchUpInside];
              clickSub.titleLabel.textAlignment = NSTextAlignmentLeft;
              clickSub.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
              clickSub.btnIdentifier = [NSString stringWithFormat:@"%ld",section];
              clickSub.titleLabel.font = _commitUI.commitListContentFont;
        }
    }
    
    return back;
}

- (void)searchSubCommitMore:(UIButton *)btn{
    NSInteger section = [btn.btnIdentifier integerValue];
    if(_commitlist.count - 1 >= section){
        YiChatShortVideoDataSource *data = _commitlist[section];
        [self loadSubCommitListWithDataSource:data];
    }
}


             
-(void)deleteCommit:(NSInteger)commentId dataSource:(YiChatShortVideoDataSource *)dataSource row:(NSInteger)row{
    NSDictionary *token = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    WS(weakSelf);
    if(dataSource.isPraseing == NO){
        dataSource.isPraseing = YES;
        [ProjectRequestHelper shortVideoCommitDeleteWithcommentId:commentId headerParameters:token progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
            
        } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
            [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
                dataSource.isPraseing = NO;
                if(obj && [obj isKindOfClass:[NSDictionary class]]){
                    id commitData = dataSource.originData;
                    
                    NSInteger num = dataSource.replyNum;
                    if(num > 0){
                        num -= 1;
                    }
                    
                    commitData[@"replyCount"] =  [NSNumber numberWithInteger:num];
                    dataSource.replyNum = num;
//                    dataSource.praseState = 0;
                    NSInteger commetCount = 0;
                    if (row == -1) {
                        for (NSInteger i = 0; i < weakSelf.commitlist.count; i++) {
                            YiChatShortVideoDataSource *m = weakSelf.commitlist[i];
                            if ([m.originData[@"commentId"] integerValue] == [dataSource.originData[@"commentId"] integerValue]) {
                                [weakSelf.commitlist removeObjectAtIndex:i];
                                commetCount = m.appearSubCommitList.count + 1;
                                break;
                            }
                        }
                    }else{
                        [dataSource.appearSubCommitList removeObjectAtIndex:row];
                        commetCount = 1;
                    }
                    
                    weakSelf.refeshCommit(commetCount);
                    
                    [ProjectHelper helper_getMainThread:^{
                        [UIView performWithoutAnimation:^{
                            [self.table reloadData];
                        }];

                    }];
                }
                else if([obj isKindOfClass:[NSString class]]){
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
                }
                else{
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"点赞出错"];
                }
            }];
            
            
        } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
            dataSource.isPraseing = NO;
            [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:error];
        }];
        
    }
}

- (void)praiseCommit:(NSInteger)commentId dataSource:(YiChatShortVideoDataSource *)dataSource{
    NSDictionary *token = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    if(dataSource.isPraseing == NO){
        dataSource.isPraseing = YES;
        [ProjectRequestHelper shortVideoCommitPraiseWithcommentId:commentId headerParameters:token progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
            
        } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
            [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
                dataSource.isPraseing = NO;
                if(obj && [obj isKindOfClass:[NSDictionary class]]){
                    id commitData = dataSource.originData;
                    
                    NSInteger state = dataSource.praseState;
                    if(state == 1){
                        NSInteger num = dataSource.praiseNum;
                        if(num > 0){
                            num -= 1;
                        }
                        
                        commitData[@"praiseStatus"] = [NSNumber numberWithInteger:0];
                        commitData[@"praiseCount"] =  [NSNumber numberWithInteger:num];
                        dataSource.praiseNum = num;
                        dataSource.praseState = 0;
                    }
                    else{
                        commitData[@"praiseStatus"] = [NSNumber numberWithInteger:1];
                        
                        NSInteger num = dataSource.praiseNum + 1;
                        commitData[@"praiseCount"] =  [NSNumber numberWithInteger:num];
                        
                        dataSource.praiseNum = num;
                        dataSource.praseState = 1;
                    }
                    
                    [ProjectHelper helper_getMainThread:^{
                        [UIView performWithoutAnimation:^{
                            [self.table reloadData];
                        }];

                    }];
                   
                    
                }
                else if([obj isKindOfClass:[NSString class]]){
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
                }
                else{
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"点赞出错"];
                }
            }];
            
            
        } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
            dataSource.isPraseing = NO;
            [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:error];
        }];
        
    }
}

- (void)loadSubCommitListWithDataSource:(YiChatShortVideoDataSource *)dataSource{
    
    NSDictionary *token = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    
    if(dataSource.isLoadingSubCommit == NO){
        dataSource.isLoadingSubCommit = YES;
        
        [ProjectRequestHelper shortvideoCommitReplyListWithcommentId:[dataSource.originData[@"commentId"] integerValue] pageNo:dataSource.subCommitPageNo pageSize:dataSource.subCommitPageSize headerParameters:token progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
            
        } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
            dataSource.isLoadingSubCommit = NO;
            [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
                if(obj && [obj isKindOfClass:[NSDictionary class]]){
                    NSArray *subComitList = REQUEST_DATA(obj);
                    if(subComitList && [subComitList isKindOfClass:[NSArray class]]){
                        
                        dataSource.isShowClick = NO;
                        if(subComitList.count > 0){
                            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                            
                             [ProjectHelper helper_getMainThread:^{
                            
                                for (int i = 0; i < subComitList.count;i ++) {
                                    YiChatShortVideoSubCommitDataSource *subCommit = [[YiChatShortVideoSubCommitDataSource alloc] initWithData:subComitList[i]];
                                    [arr addObject:subCommit];
                                }
                                 if(dataSource.subCommitPageNo == 1){
                                                                                            [dataSource.appearSubCommitList removeAllObjects];
                                                                                               [dataSource.appearSubCommitList addObjectsFromArray:arr];
                                     [dataSource update];
                                    }
                                    else{
                                                                                               [dataSource.appearSubCommitList addObjectsFromArray:arr];
                                        }
                                                                                           dataSource.subCommitPageNo ++;
                                                            
                                                           
                                                                [self.table reloadData];
                            }];
                        }
                        else{
                          
                        }
                    }
                    return ;
                }
                else if(obj && [obj isKindOfClass:[NSString class]]){
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
                }
                else{
                    [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"获取评论列表出错"];
                }
            }];
        } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
           
            dataSource.isLoadingSubCommit = NO;
        }];
    }
    
    
}

- (void)activeshowWithData:(NSArray *)commitList{
     WS(weakSelf);
    [self showAnimateCompletionHandle:^{
        [weakSelf.commitlist removeAllObjects];
        
        for (int i = 0; i < commitList.count; i ++) {
            YiChatShortVideoDataSource *data = [[YiChatShortVideoDataSource alloc] initWithData:commitList[i]];
            [weakSelf.commitlist addObject:data];
            
            [weakSelf.table reloadData];
        }
    }];
}



- (void)deactiveHidden{
   
   
    [self disappearAnimateCompletionHandle:^{
        
    }];
//    if(self.commitCallBack){
//        self.commitCallBack(YES);
//    }
    [self.commitView removeActive];
    
}

- (void)disappear{
    [super disappear];
    
//    if(self.commitCallBack){
//          self.commitCallBack(YES);
//
//    }
    
    [self.commitView removeActive];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
    [self.commitView removeActive];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
