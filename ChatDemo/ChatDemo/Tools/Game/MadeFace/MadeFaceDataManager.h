//
//  MadeFaceDataManager.h
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 拼脸数据管理类
 
 */
@interface MadeFaceDataManager : NSObject

/**
 单例方法
 */
+ (MadeFaceDataManager *)shareManager;

/**
 
 获取某部位某性别下所有部位数组
 */
- (NSArray *)getShapeArrayWithShape:(NSString *)shape gender:(NSString *)gender;

/**
 随机获取部位
 */
- (NSDictionary *)randomGetShapes;


/**
 获取所有显示部位数组
*/
- (NSArray *)getShapesLocation;

/**
 
 获取部位model
 */
- (PartModel *)getPartModelWithShape:(NSString *)shape
                              partId:(NSInteger)partId
                              gender:(NSString *)gender;

/**
 判断是否添加删除键
*/
- (BOOL)isAddDelete:(NSString *)shape;
@end
