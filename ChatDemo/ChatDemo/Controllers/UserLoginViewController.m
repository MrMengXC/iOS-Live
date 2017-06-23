//
//  UserLoginViewController.m
//  ChatDemo
//
//  Created by ios on 17/5/15.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UserLoginViewController.h"
@interface UserLoginViewController ()

@property (nonatomic ,strong)NSMutableDictionary *userdict;

@end

@implementation UserLoginViewController
- (instancetype)initWithUserDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.userdict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self createUI];
}
- (void)createUI
{
    

    
    //昵称
    
    
    //头像链接
    
    
    //性别
    
    UISegmentedControl *segcontrol = [[UISegmentedControl alloc]initWithItems:@[@"girl",@"boy"]];
    segcontrol.selectedSegmentIndex = 0;
    segcontrol.translatesAutoresizingMaskIntoConstraints = NO;
    [segcontrol addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segcontrol];
    
    UIButton *finish = [[UIButton alloc]init];
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    finish.backgroundColor = [UIColor blueColor];
    finish.translatesAutoresizingMaskIntoConstraints = NO;
    [finish addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finish];
    
    //
    NSDictionary *dict  = NSDictionaryOfVariableBindings(segcontrol,finish);
    [UIManager addConstraintWithFormat:@"V:|-100-[segcontrol]" viewDict:dict superView:self.view];
    [UIManager addConstraintWithFormat:@"V:[finish]-100-|" viewDict:dict superView:self.view];
    [UIManager addConstraintWithFormat:@"[finish(100)]" viewDict:dict superView:self.view];
    
    NSLayoutConstraint *seg_X = [NSLayoutConstraint constraintWithItem:segcontrol attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *finish_X = [NSLayoutConstraint constraintWithItem:finish attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    [self.view addConstraints:@[seg_X,finish_X]];
    
    self.userdict[@"ugender"] = @(0);

    
    

}

//选择性别
- (void)selectGender:(UISegmentedControl *)control
{
    
    self.userdict[@"ugender"] = @(control.selectedSegmentIndex);
    
}

- (void)finishButtonClick:(UIButton *)button
{
    //进行用户注册
    [RequestData postDataWithUrl:FF_USER_REGIST dataDict:self.userdict ResultBlock:^(NSDictionary *result)
    {
        
        if([result[@"code"] intValue] == 100)
        {
            NSDictionary *userDict = result[@"data"];
            [UserSelfInfoModel shareModelWithDict:userDict];
            [ChatManager shareManager];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}
@end
