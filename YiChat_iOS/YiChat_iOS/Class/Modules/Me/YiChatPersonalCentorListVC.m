//
//  YiChatPersonalCentorListVC.m
//  YiChat_iOS
//
//  Created by mac on 2020/4/20.
//  Copyright © 2020 ZhangFengTechnology. All rights reserved.
//

#import "YiChatPersonalCentorListVC.h"
#import "HMSegmentedControl.h"
#import "YiChatPersonalCentorVC.h"
@interface YiChatPersonalCentorListVC ()
@property (strong, nonatomic) UIPageViewController* pages;
@property (nonatomic, strong) HMSegmentedControl* segmentedControl;
@property (nonatomic, strong) NSMutableArray* viewControllerArray;
@property (assign, nonatomic) NSInteger currentPageIndex;
@end

@implementation YiChatPersonalCentorListVC

+ (id)initialVC{
    YiChatPersonalCentorListVC *me = [YiChatPersonalCentorListVC initialVCWithNavBarStyle:ProjectNavBarStyleCommon_13 centeritem:PROJECT_TEXT_LOCALIZE_NAME(@"个人中心") leftItem:nil rightItem:nil];
    return me;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerArray = [NSMutableArray new];
    self.view.backgroundColor = PROJECT_COLOR_APPBACKCOLOR;
    self.currentPageIndex = 0;
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"作品",@"喜欢"]];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.frame = CGRectMake(0, PROJECT_SIZE_STATUSH + PROJECT_SIZE_NAVH, self.view.frame.size.width, 40);
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.verticalDividerEnabled = NO;
    self.segmentedControl.selectionIndicatorHeight = 1.5f;
    self.segmentedControl.selectionIndicatorColor = PROJECT_COLOR_APPBACKCOLOR;
    self.segmentedControl.backgroundColor = PROJECT_COLOR_APPBACKCOLOR;
    [self.segmentedControl setTitleFormatter:^NSAttributedString*(HMSegmentedControl* segmentedControl, NSString* title, NSUInteger index, BOOL selected) {
        NSAttributedString* attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? PROJECT_COLOR_APPMAINCOLOR : [UIColor darkGrayColor],                                                                                                                                                                                                    NSFontAttributeName : [UIFont systemFontOfSize:14] }];
        return attString;
    }];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    
    
    YiChatPersonalCentorVC* v1 = [[YiChatPersonalCentorVC alloc]init];
   
    v1.type = @"0";
   YiChatPersonalCentorVC* v2 = [[YiChatPersonalCentorVC alloc]init];
   v2.type = @"2";

   [self.viewControllerArray addObjectsFromArray:@[v1,v2]];
   
   self.pages = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
   [self.pages.view setFrame:CGRectZero];
   [self.pages setViewControllers:@[[self.viewControllerArray objectAtIndex:0] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
   [self addChildViewController:self.pages];
   [self.view addSubview:self.pages.view];
   [self.pages.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.segmentedControl.mas_bottom).offset(2);
       make.left.and.right.and.bottom.mas_equalTo(0);
   }];
    
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
