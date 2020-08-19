//
//  ProjectUIHelper.m
//  YiChat_iOS
//
//  Created by 你是我的小呀小苹果 on 2019/5/22.
//  Copyright © 2019年 ZhangFengTechnology. All rights reserved.
//

#import "ProjectUIHelper.h"
#import "ProjectDef.h"
#import "ProjectTextInputView.h"
#import "ProjectAlertView.h"
#import "YRProgressView.h"
#import "YRActionSheet.h"
#import "TabBarProjectVC.h"
#import "ProjectIconsNumView.h"

#define ProjectMaxPickerImageNum 9
#define ProjectMaxPickerVideoNum 1


@implementation ProjectUIHelper

+ (id)ProjectUIHelper_getInputControlViewWithFrame:(CGRect)frame inputStyle:(NSInteger)style{
    ProjectTextInputView *input = [[ProjectTextInputView alloc] initWithFrame:frame];
    input.inputStyle = style;
    return input;
}

+ (void)ProjectUIHelper_getAlertWithMsm:(NSString *)msg{
    if([msg isKindOfClass:[NSString class]]){
        [ProjectAlertView yrAlertViewAlertMessgae:msg];
    }
}

+ (void)ProjectUIHelper_getAlertNoShadowWithMsm:(NSString *)msg{
    if([msg isKindOfClass:[NSString class]]){
       ProjectAlertView *alert =  [ProjectAlertView appearAlertWithStyle:10 title:@"" content:msg buttonsDataSource:nil clickInvocation:nil];
        [alert show];
    }
}

+ (void)ProjectUIHelper_getAlertWithAlertMessage:(NSString *)message clickBtns:(NSArray *)arr invocation:(void(^)(NSInteger row))click{
    if([message isKindOfClass:[NSString class]] && arr.count != 0){
        [ProjectAlertView yrAlertWithAlertMessage:message clickBtns:arr invocation:click];
    }
}

+ (id)ProjectUIHelper_getProgressWithText:(NSString *)text{
    YRProgressView *progress = [YRProgressView showProgressViewWithProgressText:text];
    return progress;
}

+ (id)projectCreateNumIconWithPosition:(CGPoint)postion num:(NSInteger)num{
    CGSize size = CGSizeMake(20.0, 20.0);
    ProjectIconsNumView *numIcon = [ProjectIconsNumView createUIWithFrame:CGRectMake(postion.x - size.width / 2, postion.y, size.width, size.height) num:num];
    
    return numIcon;
}

+ (void)projectNumIcon:(UIView *)numIcon changeNum:(NSInteger)num{
    if([numIcon isKindOfClass:[ProjectIconsNumView class]] && numIcon){
        ProjectIconsNumView *numView = numIcon;
        [numView updateNum:num];
    }
}

+ (void)projectTabBar:(UITabBarController *)tabVC index:(NSInteger)index changeNum:(NSInteger)num{
    if([tabVC isKindOfClass:[TabBarProjectVC class]]){
        TabBarProjectVC *tab = (TabBarProjectVC *)tabVC;
        if(num == 0){
            [tab removeIconNumWithIndex:index];
        }
        else{
            [tab addIconNum:num index:index];
        }
    }
}

+ (id)ProjectUIHelper_getProgressValue:(double)value{
    YRProgressView *progress = [YRProgressView showProgressViewWithProgressValue:value];
    return progress;
}

+ (id)projectActionSheetWithListArr:(NSArray *)listArr click:(void(^)(NSInteger row))click{
    if([listArr isKindOfClass:[NSArray class]]){
        if(listArr.count != 0){
            YRActionSheet *action = [[YRActionSheet alloc] initWithListArr:listArr];
            action.click = ^(NSInteger row) {
                click(row);
            };
            return action;
        }
    }
    return nil;
}
/**
 *  可以拍照 可以选择图片 不能拍视频 不能选择视频
 *  用户只能拍视频或者选视频
 *  只能在相册选择图片
 *  只能在相册选择图片视频
 *  既能拍照选照片 又能录视频选视频
 *  只能拍照选照片
 */
+ (void)projectPhotoVideoPickerWWithType:(NSInteger)type invocation:(void(^)(YRPickerManager *manager,UINavigationController *nav))invocation{
    
    YRPickerManager *manager = [YRPickerManager defaultManager];
    UINavigationController *controller = nil;
    if(type == 0){
       controller =  [manager pickerImageWithMaxCount:ProjectMaxPickerImageNum delegate:manager];
    }
    else if(type == 1){
       controller = [manager pickerVideoWithMaxCount:ProjectMaxPickerVideoNum delegate:manager];
    }
    else if(type == 2){
       controller = [manager pickerImageFromAlumnWithMaxCount:ProjectMaxPickerImageNum delegate:manager];
    }
    else if(type == 3){
       controller = [manager pickerImageVideoFromAlumnWithMaxCount:ProjectMaxPickerImageNum delegate:manager];
    }
    else if(type == 4){
       controller = [manager pickerImageOrVideoWithMaxCount:ProjectMaxPickerImageNum delegate:manager];
    }
    else if(type == 5){
       controller = [manager pickerImageTakeWithMaxCount:ProjectMaxPickerImageNum delegate:manager];
    }
    else if(type == 6){
        controller = [manager pickerImageFromAlumnWithMaxCount:1 delegate:manager];
        if(controller && [controller isKindOfClass:[TZImagePickerController class]]){
            TZImagePickerController *tz = (TZImagePickerController *)controller;
            tz.allowCrop = YES;
        }
    }
    invocation(manager,controller);
}

+ (void)projectPhotoVideoPickerWWithType:(NSInteger)type pickNum:(NSInteger)num invocation:(void(^)(YRPickerManager *manager,UINavigationController *nav))invocation{
    YRPickerManager *manager = [YRPickerManager defaultManager];
    UINavigationController *controller = nil;
    if(num == 0){
        num = 1;
    }
    if(type == 0){
        controller =  [manager pickerImageWithMaxCount:num delegate:manager];
    }
    else if(type == 1){
        controller = [manager pickerVideoWithMaxCount:num delegate:manager];
    }
    else if(type == 2){
        controller = [manager pickerImageFromAlumnWithMaxCount:num delegate:manager];
    }
    else if(type == 3){
        controller = [manager pickerImageVideoFromAlumnWithMaxCount:num delegate:manager];
    }
    else if(type == 4){
        controller = [manager pickerImageOrVideoWithMaxCount:num delegate:manager];
    }
    else if(type == 5){
        controller = [manager pickerImageTakeWithMaxCount:num delegate:manager];
    }
    else if(type == 6){
        controller = [manager pickerImageFromAlumnWithMaxCount:num delegate:manager];
        if(controller && [controller isKindOfClass:[TZImagePickerController class]]){
            TZImagePickerController *tz = (TZImagePickerController *)controller;
            tz.allowCrop = YES;
        }
    }
    invocation(manager,controller);
}

+ (id)ProjectUIHelper_getClickBtnWithFrame:(CGRect)frame title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tintColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 5.0;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    return btn;
}

+ (UIFont *)helper_getCommonFontWithSize:(CGFloat)fontSize{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}


+ (void)helper_showImageBrowseWithDataSouce:(NSArray *)dataSource withSourceObjs:(NSArray *)objs currentIndex:(NSInteger)index{

    if(dataSource && [dataSource isKindOfClass:[NSArray class]] && objs && [objs isKindOfClass:[NSArray class]]){
        [[ProjectBrowseManager create] showImageBrowseWithDataSouce:dataSource withSourceObjs:objs currentIndex:index];
    }
}

+ (void)helper_showVideoBrowseWithDataSouce:(NSArray *)dataSource withSourceObjs:(NSArray *)objs currentIndex:(NSInteger)index{
    if(dataSource && [dataSource isKindOfClass:[NSArray class]] && objs && [objs isKindOfClass:[NSArray class]]){
        [[ProjectBrowseManager create] showVideoBrowseWithDataSouce:dataSource withSourceObjs:objs currentIndex:index];
    }
}

+ (void)helper_showVideoBrowseWithDataSouce:(NSArray *)dataSource withSourceObjs:(NSArray *)objs currentIndex:(NSInteger)index corverImage:(UIImage *)cover{
    if(dataSource && [dataSource isKindOfClass:[NSArray class]] && objs && [objs isKindOfClass:[NSArray class]]){
        [[ProjectBrowseManager create] showVideoBrowseWithDataSouce:dataSource withSourceObjs:objs currentIndex:index corverImage:cover];
    }
}

+ (UIView *)buildActiveAlertUIWithAlertText:(NSString *)alert{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(28, 0, PROJECT_SIZE_WIDTH - 28 * 2, 230)];
        bg.layer.cornerRadius = 8;
        bg.backgroundColor = [UIColor whiteColor];
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectZero];
        im.image = [UIImage imageNamed:@"pop_success"];
        [bg addSubview:im];
        [im mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        UILabel *sign = [[UILabel alloc] initWithFrame:CGRectZero];
        sign.text = @"恭喜";
        sign.textColor = [UIColor colorWithRed:67/255.0 green:65/255.0 blue:81/255.0 alpha:1.0];
        sign.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        sign.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:sign];
        [sign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(100);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
        UILabel *info = [[UILabel alloc] initWithFrame:CGRectZero];
        info.text = alert;
        info.textColor = [UIColor colorWithRed:67/255.0 green:65/255.0 blue:81/255.0 alpha:1.0];
        info.font = [UIFont systemFontOfSize:17];
        info.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:info];
        [info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(140);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
//        UIButton *jump = [[UIButton alloc] initWithFrame:CGRectZero];
//        jump.backgroundColor = [UIColor colorWithRed:48/255.0 green:203/255.0 blue:96/255.0 alpha:1.0];
//        [jump addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
//        jump.layer.cornerRadius = 8;
//        jump.tag = 0;
//        [jump setTitle:@"" forState:UIControlStateNormal];
//        jump.titleLabel.textColor = [UIColor whiteColor];
//        jump.titleLabel.font = [UIFont systemFontOfSize:17];
//        [bg addSubview:jump];
//        [jump mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(-79);
//            make.size.mas_equalTo(CGSizeMake(240, 44));
//            make.centerX.mas_equalTo(0);
//        }];
        
//        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectZero];
//        [cancel addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
//        cancel.tag = 1;
//        [cancel setTitle:@"" forState:UIControlStateNormal];
//        [cancel setTitleColor:[UIColor colorWithRed:67/255.0 green:65/255.0 blue:81/255.0 alpha:1.0] forState:UIControlStateNormal];
//    //    cancel.titleLabel.textColor = [UIColor colorWithRed:67/255.0 green:65/255.0 blue:81/255.0 alpha:1.0];
//        cancel.titleLabel.font = [UIFont systemFontOfSize:17];
//        [bg addSubview:cancel];
//        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(-30);
//            make.size.mas_equalTo(CGSizeMake(240, 44));
//            make.centerX.mas_equalTo(0);
//        }];
    
    return bg;
           
}

+ (void)showActiveAlertUIWithAlertText:(NSString *)alert blocked:(void(^)(KLCPopup *bg,UIView *showView))blocked{
    UIView *show = [self buildActiveAlertUIWithAlertText:alert];
    KLCPopup * bg =[KLCPopup popupWithContentView:show showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [bg show];
    if(blocked){
        blocked(bg,show);
    }

}

@end
