//
//  ImageHandleManager.m
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ImageHandleManager.h"
#import <AES.h>
#import "NSString+Category.h"

#define Image_Secret_Key [@"dadsdasdaq32323dsa" md5]

@implementation ImageHandleManager
/**
 * Json/图片 文件一般会传Path
 */
+ (UIImage *)getImageWithFileName:(NSString *)fileName
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = nil;
    NSArray *array = [fileName componentsSeparatedByString:@"_"];
    NSString *suffix = @"";
    
    if(array.count >2)
    {
        NSString *rootFile =  [NSHomeDirectory() stringByAppendingFormat:@"/Documents/SourceFile"];
        if([array[0] isEqualToString:@"s"])     //小图标
        {
            
            CGFloat scale_screen = [UIScreen mainScreen].scale;
            if(scale_screen == 3){      //三倍图   imfp
                suffix = @"@3x.imfp";
            }
            else{
                suffix = @".imfp";
            }
        }
        
        else{           //大图标
            suffix = @".imfp";
        }
        
        if([manager fileExistsAtPath:rootFile]){
            filePath = [rootFile stringByAppendingFormat:@"/%@%@",fileName,suffix];
            
        }
    }
    
    //------------------------
    if([manager fileExistsAtPath:filePath]){
        //下载资源
        NSData *data = [[NSMutableData dataWithContentsOfFile:filePath] AES128DecryptWithKey:Image_Secret_Key];
        return [UIImage imageWithData:data];
    }
    else{       //基础资源
        if([[fileName componentsSeparatedByString:@"_"][0] isEqualToString:@"s"])
        {
            
            NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@%@",fileName,suffix] ofType:@""];
            NSData *data = [[NSMutableData dataWithContentsOfFile:path]AES128DecryptWithKey:Image_Secret_Key];
            return [UIImage imageWithData:data];
        }
        else{
            
            NSString *path = [[NSBundle mainBundle]pathForResource:[fileName stringByAppendingString:@".imfp"] ofType:nil];
            NSData *data = [[NSMutableData dataWithContentsOfFile:path]AES128DecryptWithKey:Image_Secret_Key];
            return [UIImage imageWithData:data];
        }
        
    }
}

+ (UIImage *)scaleImageWithImage:(UIImage *)oriImage newSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [oriImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

@end
