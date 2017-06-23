//
//  SquareCell.m
//  ChatDemo
//
//  Created by ios on 17/5/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "SquareCell.h"

@interface SquareCell ()
@property (nonatomic ,strong)id delegate;
@property (nonatomic ,strong)UserProductModel * productModel;

@end

@implementation SquareCell


- (void)viewWithModel:(UserProductModel *)model delegate:(id)delegate
{
    self.delegate = delegate;
    self.productModel = model;
    
    if(!self.productView)
    {
        self.productView  = [[UIImageView alloc]init];
        self.productView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.productView];
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(_productView);
        [UIManager addConstraintWithFormat:@"|-8-[_productView]-8-|" viewDict:dict superView:self.contentView];
        [UIManager addConstraintWithFormat:@"V:|-8-[_productView]-8-|" viewDict:dict superView:self.contentView];
    }
    NSString *scaleUrl = [model.poriurl stringByAppendingFormat:@"?imageView2/0/w/%.0f",self.width];

    [self.productView sd_setImageWithURL:[NSURL URLWithString:scaleUrl]];

    if(!self.userPhoto)
    {
        self.userPhoto  = [[UIImageView alloc]init];
        self.userPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        self.userPhoto.backgroundColor = [UIColor blueColor];
        self.userPhoto.layer.cornerRadius = 22.0f;
        [self.contentView addSubview:self.userPhoto];
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(_userPhoto);
        [UIManager addConstraintWithFormat:@"|-16-[_userPhoto(44)]" viewDict:dict superView:self.contentView];
        [UIManager addConstraintWithFormat:@"V:[_userPhoto(44)]-16-|" viewDict:dict superView:self.contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoUserInfo:)];
        [self.userPhoto addGestureRecognizer:tap];
        
    }
//    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:[UserSelfInfoModel shareModel].uimg]];
    
    
    if(!self.faceButton)
    {
        self.faceButton = [[UIButton alloc]init];
        self.faceButton.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.faceButton setTitle:@"赏脸" forState:UIControlStateNormal];
//        self.faceButton.backgroundColor = [UIColor blueColor];
        [self.faceButton addTarget:self action:@selector(faceUserProduct:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.faceButton];
        NSDictionary *dict = NSDictionaryOfVariableBindings(_faceButton);
        [UIManager addConstraintWithFormat:@"[_faceButton(40)]-16-|" viewDict:dict superView:self.contentView];
        [UIManager addConstraintWithFormat:@"V:[_faceButton(25)]" viewDict:dict superView:self.contentView];
        NSLayoutConstraint *facebutton_Y = [NSLayoutConstraint constraintWithItem:self.faceButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.userPhoto attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.contentView addConstraint:facebutton_Y];
    }
    
    //进行赋值
    [self.faceButton setTitle:[NSString stringWithFormat:@"%@",model.goods] forState:UIControlStateNormal];
    if([model.isgood isEqualToNumber:@1])
    {
        self.faceButton.backgroundColor = [UIColor blueColor];
        
    }else{
        self.faceButton.backgroundColor = [UIColor grayColor];

    }
    
    
    
    //
}
#pragma mark - 进行点赞
- (void)faceUserProduct:(UIButton *)button
{
    
    
    if(![UserSelfInfoModel shareModel].uid)
    {
        return;
    }
    
    //取消点赞
    if([self.productModel.isgood isEqualToNumber:@1])
    {
        NSDictionary *dict = @{
                               
                               @"pid":self.productModel.pid,
                               @"sid":[UserSelfInfoModel shareModel].uid,
                               
                               };
        
        [RequestData deleteDataWithUrl:FF_PRODUCT_CANCEL_GOOD dataDict:dict resultBlock:^(NSDictionary *result) {
            NSLog(@"%@",result);
            //取消点赞成功，刷新视图
            if([result[@"code"] integerValue] == 100)
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                    self.productModel.isgood = @0;
                    self.productModel.goods = @(self.productModel.goods.intValue - 1);
                    self.faceButton.backgroundColor = [UIColor grayColor];
                    [self.faceButton setTitle:[NSString stringWithFormat:@"%@",self.productModel.goods] forState:UIControlStateNormal];
                    
                });
            }
            
        }];
        

    }else{      //点赞
        
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *timeString = [format stringFromDate:[NSDate date]];
        
        NSDictionary *dict = @{
                               
                               @"sid":[UserSelfInfoModel shareModel].uid,
                               @"ftime":timeString,
                               @"pid":self.productModel.pid,
                               @"rid":self.productModel.uid
        
                               };
        
        [RequestData postDataWithUrl:FF_PRODUCT_GOOD dataDict:dict ResultBlock:^(NSDictionary *result) {
            NSLog(@"%@",result);
            
            //点赞成功，刷新视图
            if([result[@"code"] integerValue] == 100)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    self.productModel.isgood = @1;
                    self.productModel.goods = @(self.productModel.goods.intValue + 1);
                    self.faceButton.backgroundColor = [UIColor blueColor];
                    [self.faceButton setTitle:[NSString stringWithFormat:@"%@",self.productModel.goods] forState:UIControlStateNormal];

                });
                
                
            
            }
        }];
    }
    
    
    
    
}
- (void)intoUserInfo:(UITapGestureRecognizer *)tap
{
    return;
    if([self.delegate respondsToSelector:@selector(intoUserInfo:)])
    {
        [self.delegate performSelector:@selector(intoUserInfo:) withObject:self.productModel];
    }
}
@end
