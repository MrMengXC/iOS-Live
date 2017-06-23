//
//  SelfProductCell.h
//  ChatDemo
//
//  Created by ios on 17/6/1.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProductModel.h"
@interface SelfProductCell : UICollectionViewCell
@property (nonatomic ,strong)UIImageView *productView;          //作品试图


- (void)viewWithModel:(UserProductModel *)model;

@end
