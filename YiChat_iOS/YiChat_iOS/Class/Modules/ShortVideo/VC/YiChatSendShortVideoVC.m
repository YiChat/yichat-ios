//
//  YiChatSendShortVideoVC.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2020/4/14.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatSendShortVideoVC.h"
#import "YiChatSendDynamicToolBar.h"


@interface YiChatSendShortVideoVC ()
@property (nonatomic,strong) KLCPopup *bgview;
@end

@implementation YiChatSendShortVideoVC

+ (id)initialVC{
    YiChatSendShortVideoVC *shortVideo = [YiChatSendShortVideoVC initialVCWithNavBarStyle:ProjectNavBarStyleCommon_13 centeritem:@"短视频发布" leftItem:nil rightItem:@"发布"];
    return shortVideo;
}

- (void)navBarButtonRightItemMethod:(UIButton *)btn{
//    if(self.textView.text.length > 0){
        NSString *content = @"";
        if(self.textView.text.length > 0){
            content = self.textView.text;
        }
        
        [self.textView resignFirstResponder];
        
        NSMutableArray *str = [NSMutableArray arrayWithCapacity:0];
        NSString *uploadStr = nil;
        NSInteger type = 0;
        CGFloat dutation = 0;
        CGFloat scale = 0;
        for (int i = 0; i < self.uploadResourceList.count; i ++) {
            YiChatSendDynamicBarModel *model = self.uploadResourceList[i];
            if(model && [model isKindOfClass:[YiChatSendDynamicBarModel class]]){
                
                NSString *url = model.remoteUrl;
                if(url && [url isKindOfClass:[NSString class]]){
                    [str addObject:url];
                }
                if(i == 0){
                    if(model.type == YiChatSendDynamicBarModelTypeImage){
                        type = 0;
                    }
                    else if(model.type == YiChatSendDynamicBarModelTypeVideo){
                        type = 1;
                        scale = model.scale;
                        dutation = model.videoTime;
                    }
                }
            }
        }
        if(str.count > 0){
            if(str.count == 1){
                uploadStr = str.firstObject;
            }
            else{
                uploadStr = [str componentsJoinedByString:@","];
            }
        }
        NSDictionary *dic = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
        
        id progress = [ProjectUIHelper ProjectUIHelper_getProgressWithText:@""];
    WS(weakSelf);
    if (uploadStr.length == 0) {
        [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"请添加视频视频"];
        return;
    }
        
        [ProjectRequestHelper sendShortVideoWithPath:uploadStr thumbnail:@"" seconds:dutation rate:scale content:content headerParameters:dic progress:progress isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
            
        } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
            
            [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
                   if([obj isKindOfClass:[NSDictionary class]] && obj){
                       if(weakSelf.yichatSendShortVideoSuccess){
                           weakSelf.yichatSendShortVideoSuccess(obj);
                       }
                       
                       [ProjectHelper helper_getMainThread:^{
                           [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"短视频发布成功"];
                           [weakSelf dismissViewControllerAnimated:YES completion:nil];
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
                                                              
                                           
                                       [weakSelf performSelector:@selector(removeActive:) withObject:bg afterDelay:2];
                                       
                                   }];
                                   
                               }];
                               
                           }
                           
                       }else{
                       }
                   
                   }
                   else if([obj isKindOfClass:[NSString class]]){
                       [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:obj];
                   }
                   else{
                       [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"发布短视频出错"];
                   }
               }];
            
        } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
             [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:error];
        }];
        
//    }
//    else{
//        [ProjectUIHelper ProjectUIHelper_getAlertWithMsm:@"请输入内容"];
//    }
}

- (void)removeActive:(KLCPopup *)bg{
    [self dismissViewControllerAnimated:YES completion:nil];
    [bg dismiss:YES];
            
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendToolBar.isOnlyVideo = YES;
    // Do any additional setup after loading the view.
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
