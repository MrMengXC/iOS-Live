//
//  SelfProductListView.m
//  ChatDemo
//
//  Created by ios on 17/6/1.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "SelfProductListView.h"
#import "UserProductModel.h"
#import "SelfProductCell.h"

@interface SelfProductListView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    int page;
}
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UICollectionView *productCollectionView;

@end

static NSString *cellId = @"SelfProduct";

@implementation SelfProductListView
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self createUI];
    
}
- (void)createUI
{
    [self layoutIfNeeded];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.productCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.productCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.productCollectionView.backgroundColor = [UIColor blackColor];
    self.productCollectionView.delegate = self;
    self.productCollectionView.dataSource = self;
    [self.productCollectionView registerClass:[SelfProductCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:self.productCollectionView];
    self.productCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.productCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    
    
    //
    page = 0;
    self.dataArray = [[NSMutableArray alloc]init];
    [self requestUserProductDataResult:^{
        
    }];


}
- (void)refresh
{
    page = 0;
    [self.dataArray removeAllObjects];
    [self requestUserProductDataResult:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.productCollectionView.mj_header endRefreshing];

        });
        
    }];
}
- (void)loadMore
{
    page ++;
    [self requestUserProductDataResult:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.productCollectionView.mj_footer endRefreshing];
        });
        
    }];
    
}
//请求用户作品信息
- (void)requestUserProductDataResult:(ResultBlock)resultBlock
{
    
    NSString *url = [NSString stringWithFormat:FF_USER_PRODUCT_LIST,page,1,[UserSelfInfoModel shareModel].uid];
    
    [RequestData getDataWithUrl: url dataDict:nil ResultBlock:^(NSDictionary *result) {
        //添加作品数组
        NSArray *products = result[@"data"];
        for(NSDictionary *dict in products)
        {
            UserProductModel *product = [UserProductModel shareModelWithDict:dict];
            [self.dataArray addObject:product];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.productCollectionView reloadData];
            resultBlock();
        });
    }];
    
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelfProductCell *cell  = [self.productCollectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    UserProductModel *model = self.dataArray[indexPath.item];
    [cell viewWithModel:model];
    return cell;
    
}
@end
