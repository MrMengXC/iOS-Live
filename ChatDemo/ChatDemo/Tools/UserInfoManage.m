//
//  UserInfoManage.m
//  ChatDemo
//
//  Created by ios on 17/6/2.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UserInfoManage.h"

@implementation UserInfoManage

//设置用户头像
+ (void)setUserPhotoWithImage:(UIImage *)userPhoto
                 successBlock:(upSuccessBlock)successBlock
                   faileBlock:(ResultBlock)faileBlock
{
    
    UIImage *scaleImage = [ImageHandleManager scaleImageWithImage:userPhoto newSize:CGSizeMake(100, 100) ];
    
    //上传七牛
    [ToolsManage uploadImageToQnWithImage:scaleImage photoType:UserPhoto successBlock:^(NSString *upurl) {

        //上传服务器修改用户信息
        NSDictionary *newInfo  = @{@"uimg":upurl};
        NSString *url = [NSString stringWithFormat:FF_USER_SETINFO,[UserSelfInfoModel shareModel].uid];
        
        [RequestData postDataWithUrl:url dataDict:newInfo ResultBlock:^(NSDictionary *result) {
            NSLog(@"%@",result);
            if([result[@"code"] integerValue] == 100){
                successBlock(upurl);
            }
            else{
                faileBlock();
            }
        }];

        
        
    } faileBlock:^{
        faileBlock();
    }];
    
    
    
    
}

@end
