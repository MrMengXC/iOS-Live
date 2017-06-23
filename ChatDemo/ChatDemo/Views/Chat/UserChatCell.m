//
//  UserChatCell.m
//  ChatDemo
//
//  Created by ios on 17/4/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UserChatCell.h"

@interface UserChatCell ()

@property (nonatomic,strong)UILabel *message;
@property (nonatomic,strong)UIImageView *userPhoto;

@end
@implementation UserChatCell


#pragma mark - 初始化子视图
- (CGFloat)initSubViewWithModel:(ChatMessageModel *)model
{
   
    
    for(UIView * sub in self.contentView.subviews){
        [sub removeFromSuperview];
    }
    //文本信息
    
    self.message = [[UILabel alloc]init];
    self.message.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.message];

    
    
    
    //用户头像
    
    self.userPhoto = [[UIImageView alloc]init];
    self.userPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    self.userPhoto.backgroundColor =[UIColor redColor];
    [self.contentView addSubview:self.userPhoto];

    
   
    self.message.text = model.message;

    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_userPhoto,_message);
    
    UserSelfInfoModel *infoModel = [UserSelfInfoModel shareModel];
    
    if([model.sendUserId isEqualToString:infoModel.uid])
    {
        [UIManager addConstraintWithFormat:@"[_message]-10-[_userPhoto(44)]-10-|" viewDict:dict superView:self.contentView];
    }
    else{
        [UIManager addConstraintWithFormat:@"|-10-[_userPhoto(44)]-10-[_message]" viewDict:dict superView:self.contentView];
    }
    
    
    [UIManager addConstraintWithFormat:@"V:|-10-[_userPhoto(44)]" viewDict:dict superView:self.contentView];
    [UIManager addConstraintWithFormat:@"V:|-10-[_message]" viewDict:dict superView:self.contentView];

    
    [self.contentView layoutIfNeeded];
    
    
    
    
    return MAX(CGRectGetMaxY(_userPhoto.frame), CGRectGetMaxY(_message.frame)) + 10;
    

}


@end
