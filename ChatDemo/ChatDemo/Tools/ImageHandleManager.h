//
//  ImageHandleManager.h
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 图片处理类
 */
@interface ImageHandleManager : NSObject

/**
 文件名获取图片
 */
+ (UIImage *)getImageWithFileName:(NSString *)fileName;

/**
 改变图片新尺寸
 */
+ (UIImage *)scaleImageWithImage:(UIImage *)oriImage newSize:(CGSize)size;

@end
