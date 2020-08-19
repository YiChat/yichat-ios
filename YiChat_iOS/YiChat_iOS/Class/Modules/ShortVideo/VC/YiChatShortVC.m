//
//  YiChatShortVC.m
//  YiChat_iOS
//
//  Created by mac on 2020/5/8.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatShortVC.h"
#import "HMSegmentedControl.h"
#import "ZFDouYinViewController.h"
#import "YiChatSendShortVideoVC.h"
@interface YiChatShortVC ()
@property (strong, nonatomic) UIPageViewController* pages;
@property (nonatomic, strong) HMSegmentedControl* segmentedControl;
@property (nonatomic, strong) NSMutableArray* viewControllerArray;
@property (assign, nonatomic) NSInteger currentPageIndex;
@end

@implementation YiChatShortVC

+ (id)initialVC{
    YiChatShortVC*shortVideo = [self initialVCWithNavBarStyle:ProjectNavBarStyleCommon_12 centeritem:@"" leftItem:@"奖励规则" rightItem:[UIImage imageNamed:@"拍照.png"]];
    return shortVideo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerArray = [NSMutableArray new];
    self.view.backgroundColor = PROJECT_COLOR_APPBACKCOLOR;
    self.currentPageIndex = 0;
    [self setUI];
    [self setupContainerView];
    [self shortInfo:YES];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"最新", @"最热",@"关注"]];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    self.segmentedControl.frame = CGRectMake(0, PROJECT_SIZE_STATUSH + PROJECT_SIZE_NAVH, self.view.frame.size.width, 40);
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedControl.verticalDividerEnabled = NO;
    self.segmentedControl.selectionIndicatorHeight = CGFLOAT_MIN;
    self.segmentedControl.selectionIndicatorColor = [UIColor clearColor];
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    [self.segmentedControl setTitleFormatter:^NSAttributedString*(HMSegmentedControl* segmentedControl, NSString* title, NSUInteger index, BOOL selected) {
        NSAttributedString* attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? [UIColor whiteColor] : [UIColor darkGrayColor],                                                                                                                                                                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:16] }];
        return attString;
    }];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.segmentedControl];
}

- (void)navBarButtonLeftItemMethod:(UIButton *)btn{
    [self shortInfo:NO];
}

-(void)shortInfo:(BOOL)isShow{
    WS(weakSelf);
    NSDictionary *token = [ProjectRequestParameterModel getTokenParamWithToken:YiChatUserInfo_Token];
    [ProjectRequestHelper videoRewardMemoWithHeaderParameters:token progress:nil isScrete:YES isAsyn:YES identider:^(NSString * _Nonnull identify) {
    } successHandle:^(NSData * _Nonnull data, NSHTTPURLResponse * _Nonnull response) {
        [ProjectRequestHelper requestHelper_feltRequestData:data response:response handle:^(id  _Nonnull obj, BOOL isNeedLogin) {
    //             if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *objData = (NSDictionary *)obj;
            if (objData) {
                NSDictionary *dataDic = objData[@"data"];
                if (dataDic) {
                    NSString *data = [NSString stringWithFormat:@"%@",dataDic[@"content"]];
                    NSString *contentID = [NSString stringWithFormat:@"%@",dataDic[@"id"]];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:data preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    
                    if (isShow) {
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ContentID"]) {
                            NSString *oldID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ContentID"];
                            if (contentID.intValue > oldID.intValue) {
                                [ProjectHelper helper_getMainThread:^{
                                    [weakSelf presentViewController:alert animated:YES completion:nil];
                                }];
                            }
                        }else{
                            [ProjectHelper helper_getMainThread:^{
                                [weakSelf presentViewController:alert animated:YES completion:nil];
                            }];
                        }
                    }else{
                        [ProjectHelper helper_getMainThread:^{
                            [weakSelf presentViewController:alert animated:YES completion:nil];
                        }];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:contentID forKey:@"ContentID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }];
    } fail:^(NSString * _Nonnull error, NSString * _Nonnull identify) {
    }];
}


- (void)setupContainerView{
    ZFDouYinViewController* v1 = [[ZFDouYinViewController alloc]init];
    v1.sType = 1;
    ZFDouYinViewController* v2 = [[ZFDouYinViewController alloc]init];
    v2.sType = 2;
    ZFDouYinViewController* v3 = [[ZFDouYinViewController alloc]init];
    v3.sType = 3;
    [self.viewControllerArray addObjectsFromArray:@[v1,v2,v3]];
    
    self.pages = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pages.view setFrame:CGRectZero];
    [self.pages setViewControllers:@[ [self.viewControllerArray objectAtIndex:0] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:self.pages];
    [self.view addSubview:self.pages.view];
    CGFloat h = PROJECT_SIZE_HEIGHT - PROJECT_SIZE_TABH - PROJECT_SIZE_SafeAreaInset.bottom;
    [self.pages.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(h);
    }];
    
    UIView *navBg = [self navBarGetNavBar];
    navBg.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:navBg];
    [navBg addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 40));
    }];
    [self changeWhiteNavStyle];
}



#pragma Segment Delegate
- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    __weak typeof(self) weakSelf = self;
    
    if (index > self.currentPageIndex) {
        [self.pages setViewControllers:@[ [self.viewControllerArray objectAtIndex:segmentedControl.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
        }];
    }
    else {
        [self.pages setViewControllers:@[ [self.viewControllerArray objectAtIndex:segmentedControl.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
        }];
    }
}

- (void)navBarButtonRightItemMethod:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDVIDIO" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
