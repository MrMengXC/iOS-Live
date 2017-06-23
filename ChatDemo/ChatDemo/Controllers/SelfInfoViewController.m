//
//  SelfInfoViewController.m
//  ChatDemo
//
//  Created by ios on 17/5/5.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "SelfInfoViewController.h"
#import "SelfInfoView.h"
#import "UserLoginView.h"
#import "UserLoginViewController.h"

@interface SelfInfoViewController ()<UserLoginViewDelegate>
@property (nonatomic ,strong)SelfInfoView *infoView ;

@end
@implementation SelfInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UserLoginView *loginView = [[UserLoginView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-44)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //判断UserSelfModel
    if([UserSelfInfoModel shareModel].uid != NULL && self.infoView == NULL)
    {
        self.infoView = [[SelfInfoView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-44)];
        [self.view addSubview:self.infoView];
    }
}


#pragma mark - UserLoginViewDelegate
- (void)intoUserInfoView
{
        SelfInfoView *infoView = [[SelfInfoView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-44)];
        [self.view addSubview:infoView];

}
- (void)intoLoginController:(NSDictionary *)userDict
{
    //进入登陆／注册页面
    UserLoginViewController *controller = [[UserLoginViewController alloc]initWithUserDict:userDict];
    [self.navigationController pushViewController:controller animated:YES];

}
@end
