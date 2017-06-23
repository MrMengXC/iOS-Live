//
//  ToolsManage.h
//  ChatDemo
//
//  Created by ios on 17/6/2.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^upSuccessBlock) (NSString *);

typedef NS_ENUM(NSInteger, UPPhotoType)
{
    ProductPhoto = 0,       //作品图片
    UserPhoto,                      //头像
    
};

/**
 工具类
 */
@interface ToolsManage : NSObject
/**
 上传图片到七牛
 */
+ (void)uploadImageToQnWithImage:(UIImage *)image
                       photoType:(UPPhotoType)ptype
                    successBlock:(upSuccessBlock)successBlock
                      faileBlock:(ResultBlock)faileBlock;
@end
