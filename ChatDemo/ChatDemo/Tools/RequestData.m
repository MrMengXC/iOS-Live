//
//  RequestData.m
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "RequestData.h"
#import <AFNetworking.h>
@implementation RequestData

+ (AFHTTPSessionManager *)manager
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
    
    
    
}

+ (void)getDataWithUrl:(NSString *)url dataDict:(NSDictionary *)dict ResultBlock:(RequestDataSuccessBlock)result
{
    
    NSString *root = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cache"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:root])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:root withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *cache = [root stringByAppendingPathComponent:url.md5];
    NSDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile:cache];
    
    
    NSString *newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[RequestData manager]GET:newUrl parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        
       NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [dict writeToFile:cache atomically:YES];
        result(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"erroe: %@",error);
        //读取缓存
        if(cacheDict)
        {
            result(cacheDict);
        }
    }];
}
+ (void)postDataWithUrl:(NSString *)url dataDict:(NSDictionary *)dict ResultBlock:(RequestDataSuccessBlock)result
{
    [[RequestData manager] POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        result(dict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
    }];
    
    
}
+ (void)deleteDataWithUrl:(NSString *)url dataDict:(NSDictionary *)dict resultBlock:(RequestDataSuccessBlock)result
{
    [[RequestData manager] DELETE:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        result(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
+ (void)putDataWithUrl:(NSString *)url
              dataDict:(NSDictionary *)dict
           resultBlock:(RequestDataSuccessBlock)result
{
    
    [[RequestData manager] PUT:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        result(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
@end
