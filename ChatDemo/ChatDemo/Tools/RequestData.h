//
//  RequestData.h
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject

+ (void)getDataWithUrl:(NSString *)url
              dataDict:(NSDictionary *)dict
           ResultBlock:(RequestDataSuccessBlock)result;

+ (void)postDataWithUrl:(NSString *)url
               dataDict:(NSDictionary *)dict
            ResultBlock:(RequestDataSuccessBlock)result;

+ (void)deleteDataWithUrl:(NSString *)url
                 dataDict:(NSDictionary *)dict
              resultBlock:(RequestDataSuccessBlock)result;

+ (void)putDataWithUrl:(NSString *)url
              dataDict:(NSDictionary *)dict
           resultBlock:(RequestDataSuccessBlock)result;
@end
