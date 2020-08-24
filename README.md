# yichat-ios
###### profile 中 XMPPFramework千万不能动！XMPPFramework千万不能动！XMPPFramework千万不能动 ######

###### ServiceGlobalDef配置是核心、即时聊天主要功能都在这里配置，里面每个参数有详细说明 ######
###### 2-11可以根据自己的需求进行修改 ######

1.ServiceGlobalDef ：全局配置类，ip设置、一些功能的开启关闭等，配置都有相关的说明
2.ProjectConfigure :设置底部tabbar文字、图片的类
3.YiChatPersonalVC ：我的界面控制器
4.YiChatConnectionVC ：通讯录界面
5.ZFChatVC ：聊天的主要界面，红包点击等都在这里
6.ZFChatPresenter ： 主要使用的是mvp架构，这个是聊天数据处理类，数据处理界面刷新，某些事件的响应
7.YiChatConversationVC 会话界面
8.HTDBManager ：本地存储，封装的FMDB
9.ZFChatManage : 聊天相关管理类，自动登录、登出，监听
10.ProjectRequestParameterModel ：上传参数统一管理
11.ProjectRequestHelper ：网络请求管理
