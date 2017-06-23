//
//  UIManager.h
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIManager : NSObject

+ (void)addConstraintWithFormat:(NSString *)format
                       viewDict:(NSDictionary *)viewDict
                      superView:(UIView *)superView;

+ (void)clearFooterView:(UITableView *)tableView;

/**
 添加提示信息
 */
+ (void)addMessage:(NSString *)message;

@end
