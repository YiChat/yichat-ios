
//
//  ServiceGlobalDef.h
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/5/27.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#ifndef ServiceGlobalDef_h
#define ServiceGlobalDef_h

#import "ProjectUIHelper.h"
#import "ProjectDef.h"
#import "ProjectLauageManage.h"
#import "NSError+DefaultError.h"
//加密 0 不加 1加：返回的数据是加密的
#define YiChatProject_NetWork_IsNeedResponseDataAes 1
//ip配置,如果是域名需要加上WWW.
#define YiChatProject_NetWork_XMPPIP @"你的ip 比如xx.xxx.xxx.xx"
#define YiChatProject_NetWork_BaseUrl [NSString stringWithFormat:@"http://%@:端口号",YiChatProject_NetWork_XMPPIP]
//加密SecretKey 前后端必须一致
#define YiChatProject_NetWork_SecretKey @"你的SecretKey"
//oss相关配置
#define YiChatProject_NetWork_OSSAccessKey @"你的OSSAccessKey"
#define YiChatProject_NetWork_OSSSecretKey @"你的OSSSecretKey"
#define YiChatProject_NetWork_OSSEndPoint @"你的OSSEndPoint"
#define YiChatProject_NetWork_OSSBucket @"你的OSSBucket"
#define YiChatProject_NetWork_ChatFileHost [NSString stringWithFormat:@"http://%@.%@/",YiChatProject_NetWork_OSSBucket,YiChatProject_NetWork_OSSEndPoint]

#define YiChatProject_Map_Key @""
//红包消息能否撤回 0 不 1 可以
#define YiChatProject_IsBackRedPackge 0

//微信appkey等
#define YiChatProject_WeiChat_AppKey @"你的微信AppKey"
#define YiChatProject_WeiChat_WechatSecrectKey   @"你的微信SecrectKey"
//qq
#define YiChatProject_QQ_AppId @"你的QQ_AppId"
//极光
#define YiChatProject_JGPUSH_AppKey @"你的极光AppKey"
//是否需要微信支付 0 不 1 要
#define YiChatProjext_IsNeedWeChat 0
//是否需要支付宝支付 0 不 1 要
#define YiChatProjext_IsNeedAliPay 1
//红包数量限制
#define RedPacketNum 100
//红包金额限制
#define RedPacketMoney 20000
//是否需要上线 0 不需要 1 需要：某些界面会有投诉等按钮
#define YiChatProject_IsUpAppStore 0
//群人数设置
#define YiChatProject_CreateGroupNum 1500
//短信验证权限
#define YiChatProjext_CertifyPower 0
//红包，钱包权限
#define YiChatProject_IsNeedRedPackge 1
//0 不能添加  1 添加群主 2 添加群主+管理员 3 添加全部
#define YiChatProject_IsAddGroupMember 1

//是否控制建群权限
#define YiChatProject_IsControlCreatGroupPower 0
//是否需要显示被移除群聊提示
#define YiChatProject_IsNeedAppearMemberRemovedAlert 1
//是否需要qq登录 1 需要 0 不需要
#define YiChatProject_IsNeedQQLogin 1
//是否需要微信登录 1 需要 0 不需要
#define YiChatProject_IsNeedWeChatLogin 1
//钱包界面是否需要签到功能 0 不 1 要
#define YiChatProject_IsNeedQianDao 0

//聊天也主动刷新数据按钮
#define YiChatProject_IsNeedRefreshChatListBtn 1
#define YiChatProject_IsNeedRefreshGroupChatListBtn 1
#define YiChatProject_IsNeedRefreshSingleChatListBtn 1


#define YiChatProject_Group_GroupNameLimitLength 22

#define PROJECT_COLOR_NAVBACKCOLOR [UIColor whiteColor]
#define PROJECT_COLOR_STATUSBACKCOLOR [UIColor whiteColor]
#define PROJECT_COLOR_NAVTEXTCOLOR  [UIColor whiteColor]

#define PROJECT_COLOR_APPBACKCOLOR [UIColor whiteColor]
#define PROJECT_COLOR_APPMAINCOLOR PROJECT_COLOR_BlLUE

#define PROJECT_COLOR_APPTEXT_MAINCOLOR PROJECT_COLOR_TEXTCOLOR_BLACK
#define PROJECT_COLOR_APPTEXT_SUBCOLOR PROJECT_COLOR_TEXTGRAY

#define PROJECT_COLOR_TABBARBACKCOLOR  [UIColor whiteColor]
#define PROJECT_COLOR_TABBARTEXTCOLOR_SELECTE PROJECT_COLOR_APPMAINCOLOR
#define PROJECT_COLOR_TABBARTEXTCOLOR_UNSELECTE PROJECT_COLOR_TEXTGRAY


#define PROJECT_TEXT_FONT_COMMON(a)  [ProjectUIHelper helper_getCommonFontWithSize:a]

#define PROJECT_TEXT_LOCALIZE_NAME(a) [[ProjectLauageManage sharedLanguage] getAppearWordWithKey:a]

#define PROJECT_TEXT_APPNAME PROJECT_TEXT_LOCALIZE_NAME(@"appName")

#define PROJECT_SIZE_CLICKBTN_H 45.0f
#define PROJECT_SIZE_INPUT_CELLH 45.0f
#define PROJECT_SIZE_COMMON_CELLH 55.0f

#define PROJECT_SIZE_CONVERSATION_CELLH 60.0f

#define PROJECT_SIZE_FRIENDCARD_COMMON_CELLH 45.0f
#define PROJECT_SIZE_FRIENDCARD_INFO_H 90.0f

#define PROJECT_ICON_USERDEFAULT @"fx_default_useravatar.png"
#define PROJECT_ICON_GROUPDEFAULT @"group_avatar.png"
#define PROJECT_ICON_LOADEEROR @""

#define  PROJECT_GLOBALNODISTURB [NSString stringWithFormat:@"GlobalNoDisturb%@",[[YiChatUserManager defaultManagaer] getUserIdStr]]
#define TableViewRectMake CGRectMake(0, PROJECT_SIZE_STATUSH + PROJECT_SIZE_NAVH, self.view.frame.size.width, PROJECT_SIZE_HEIGHT - (PROJECT_SIZE_STATUSH + PROJECT_SIZE_NAVH) - PROJECT_SIZE_SafeAreaInset.bottom)
#endif /* ServiceGlobalDef_h */





