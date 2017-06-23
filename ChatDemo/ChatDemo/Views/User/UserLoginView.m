//
//  UserLoginView.m
//  ChatDemo
//
//  Created by ios on 17/5/15.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UserLoginView.h"
#import "UserLoginViewController.h"
#import "UserDefaultsManage.h"

@interface UserLoginView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation UserLoginView
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{

    
    //Product
    UIButton *login = [[UIButton alloc]initWithFrame:CGRectZero];
    login.translatesAutoresizingMaskIntoConstraints = NO;
    [login setTitle:@"QQ登录" forState:UIControlStateNormal];
    login.backgroundColor = [UIColor blueColor];
    [login addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:login];
    
    
    NSDictionary *dict =  NSDictionaryOfVariableBindings(login);
    
    [UIManager addConstraintWithFormat:@"V:|-20-[login]" viewDict:dict superView:self];
    
    NSLayoutConstraint *login_X = [NSLayoutConstraint constraintWithItem:login attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraints:@[login_X]];
    
    
}


//用户登录
- (void)userLogin:(UIButton *)button
{
    
    if([ShareSDK hasAuthorized:SSDKPlatformTypeQQ]){
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    }
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if(state == SSDKResponseStateSuccess)
        {
//            NSLog(@"%@---%@----%@",user.uid ,user.credential.token,user.nickname);
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc]init];
   
            userDict[@"utoken"] = user.uid;
            userDict[@"uname"] = user.nickname == NULL ? @"random":user.nickname;
            userDict[@"uimg"] = @"#img#";

            
            NSString * url = [NSString stringWithFormat:FF_USER_LOGIN,user.uid];
            [RequestData getDataWithUrl:url dataDict:nil ResultBlock:^(NSDictionary *result) {
                
//                NSLog(@"%@",result);
                if([result[@"code"] integerValue] == 100)
                {
                    
                    //获取user信息
                    //赋值单利用户model / 链接容云服务器
                    NSDictionary *userDict = result[@"data"];
                    
                    [UserSelfInfoModel shareModelWithDict:userDict];
                    [ChatManager shareManager];
                    
                    [UserDefaultsManage saveUserId:user.uid];
                    
                    
                    if([self.delegate respondsToSelector:@selector(intoUserInfoView)])
                    {
                        [self removeFromSuperview];
                        [self.delegate performSelector:@selector(intoUserInfoView)];
                    }
                    
                }else{          //用户不存
                    
                    if([self.delegate respondsToSelector:@selector(intoLoginController:)])
                    {
                        [self.delegate performSelector:@selector(intoLoginController:) withObject:userDict];
                    }
                    
                }
            }];
        }
        else{
            NSLog(@"%@",error);
        }
    }];

    
    
}


@end
