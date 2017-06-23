//
//  UserChatViewController.m
//  DayPhoto
//
//  Created by Keyloft on 16/7/21.
//  Copyright © 2016年 YC_Z. All rights reserved.
//

#import "UserChatViewController.h"
#import "ChatViewManager.h"

@interface UserChatViewController ()
{
    
    NSString * targetId;
}
@property (nonatomic ,strong)ChatViewManager *chatViewManager;


@end


@implementation UserChatViewController
- (id)initWithTargetId:(NSString *)temTargetId
{
    
    if(self = [super init])
    {
        targetId = temTargetId;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.chatViewManager = [ChatViewManager shareManagerWithDelegate:self targetId:targetId];

}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
