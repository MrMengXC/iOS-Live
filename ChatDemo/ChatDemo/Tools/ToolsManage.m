//
//  ToolsManage.m
//  ChatDemo
//
//  Created by ios on 17/6/2.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ToolsManage.h"


@implementation ToolsManage
+ (void)uploadImageToQnWithImage:(UIImage *)image
                       photoType:(UPPhotoType)ptype
                    successBlock:(upSuccessBlock)successBlock
                      faileBlock:(ResultBlock)faileBlock

{
    //获取token
    [RequestData getDataWithUrl:FF_PRODUCT_UPTOKEN dataDict:nil ResultBlock:^(NSDictionary *result) {
        
        NSString *token = result[@"data"][@"token"];
        NSString *url = result[@"data"][@"url"];
        
        QNUploadManager *upmanager = [[QNUploadManager alloc]init];
        NSData *data =  UIImagePNGRepresentation(image);
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:@{ @"x:foo":@"fooval" } checkCrc:YES cancellationSignal:nil];
        
        NSString *type = @"";
        if(ptype == ProductPhoto){
            type = @"product";
            
        }else if(ptype == UserPhoto){
            type = @"userphoto";
        }
        
        NSString *key = [NSString stringWithFormat:@"%@/%@/%@.png",[UserSelfInfoModel shareModel].uid ,type,[[NSString stringWithFormat:@"%@",[NSDate date]]md5]];
        
        
        [upmanager putData:data key:[key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"%@",resp);
            NSLog(@"info:%@",info);
            //
            NSString *purl = [NSString stringWithFormat:@"%@%@",url,key];
            successBlock(purl);
        } option:opt];
        
    }];
}
@end
