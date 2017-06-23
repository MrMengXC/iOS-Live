//
//  OtherFunctionView.m
//  ChatDemo
//
//  Created by ios on 17/4/25.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ChatFunctionView.h"

@interface ChatFunctionView ()<UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong)UICollectionView *baseView;
@property (nonatomic ,strong)NSMutableArray *dataSource;

@end

static NSString *cellID = @"OtherFunction";

@implementation ChatFunctionView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = [UIColor whiteColor];
    [self createUI];

}
- (void)createUI
{
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@"拍照",@"拼脸",@"五子棋"]];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame)/4, CGRectGetHeight(self.frame)/2);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.baseView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.delegate = self;
    self.baseView.dataSource = self;
    [self.baseView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];

    [self addSubview:self.baseView];
    
    
    
}
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    for(UIView *obj in cell.contentView.subviews)
    {
        [obj removeFromSuperview];
    }
    
    UILabel *message = [[UILabel alloc]init];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.text = self.dataSource[indexPath.item];
    message.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:message];
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(message);
    [UIManager addConstraintWithFormat:@"|[message]|" viewDict:dict superView:cell.contentView];
    [UIManager addConstraintWithFormat:@"V:|[message]|" viewDict:dict superView:cell.contentView];

    return cell;
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    ChatFunctionType type = indexPath.row + 1000;
    //
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectChatFunction:)]){
        [self.delegate selectChatFunction:type];
    
    }
    

}



@end
