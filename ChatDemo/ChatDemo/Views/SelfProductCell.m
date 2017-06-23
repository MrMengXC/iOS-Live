//
//  SelfProductCell.m
//  ChatDemo
//
//  Created by ios on 17/6/1.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "SelfProductCell.h"
@interface SelfProductCell()
@property (nonatomic ,strong)UserProductModel * productModel;

@end
@implementation SelfProductCell

- (void)viewWithModel:(UserProductModel *)model
{
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
}
@end
