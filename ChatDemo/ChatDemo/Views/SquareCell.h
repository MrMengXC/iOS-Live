//
//  SquareCell.h
//  ChatDemo
//
//  Created by ios on 17/5/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProductModel.h"

@protocol SquareCellDelegate <NSObject>

/**
    进入用户信息页面
 */
- (void)intoUserInfo:(UserProductModel *)model;

/**
 点赞
 */
- (void)goods:(UserProductModel *)model;

/**
 取消点赞
 */
- (void)cancelgoods:(UserProductModel *)model;

@end

@interface SquareCell : UITableViewCell
@property (nonatomic ,strong)UIImageView *productView;          //作品试图
@property (nonatomic ,strong)UIImageView *userPhoto;                //用户头像
@property (nonatomic ,strong)UILabel *userName;                          //用户名
@property (nonatomic ,strong)UILabel *time;                                     //创建时间
@property (nonatomic ,strong)UIButton *faceButton;          //点赞

- (void)viewWithModel:(UserProductModel *)model delegate:(id)delegate;


@end
