

//
//  SquareViewController.m
//  ChatDemo
//
//  Created by ios on 17/5/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "SquareViewController.h"
#import "UserProductModel.h"
#import "SquareCell.h"
#import "UserChatViewController.h"
#import "ProductDetailViewController.h"

@interface SquareViewController ()<UITableViewDataSource ,UITableViewDelegate,SquareCellDelegate>
{
    int page;
}
@property (nonatomic ,strong)UITableView *productTableVIew;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@end

@implementation SquareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    page = 0;
    [self.dataArray removeAllObjects];
    
    [self requestSquareDataResult:^{
    }];

}

- (void)createUI
{
    self.dataArray = [[NSMutableArray alloc]init];
    self.productTableVIew = [[UITableView alloc]init];
    self.productTableVIew.translatesAutoresizingMaskIntoConstraints = NO;
    self.productTableVIew.delegate = self;
    self.productTableVIew.dataSource = self;
    self.productTableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.productTableVIew.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [UIManager clearFooterView:self.productTableVIew];
    [self.view addSubview:self.productTableVIew];
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_productTableVIew);
    [UIManager addConstraintWithFormat:@"|[_productTableVIew]|" viewDict:dict superView:self.view];
    [UIManager addConstraintWithFormat:@"V:|[_productTableVIew]-44-|" viewDict:dict superView:self.view];
    
}
//下拉刷新
- (void)refresh
{
    page = 0;
    [self.dataArray removeAllObjects];
    [self requestSquareDataResult:^{
        [self.productTableVIew.mj_header endRefreshing];
    }];
    
}
//上拉加载
- (void)loadMore
{
    page++;
    [self requestSquareDataResult:^{
        [self.productTableVIew.mj_footer endRefreshing];
    }];
}

//请求广场信息
- (void)requestSquareDataResult:(ResultBlock)resultBlock
{
    
    NSString *url = [NSString stringWithFormat:FF_PRODUCT_LIST,page,1];
    if([UserSelfInfoModel shareModel].uid)
    {
        url = [url stringByAppendingFormat:@"&uid=%@",[UserSelfInfoModel shareModel].uid];
    }

    [RequestData getDataWithUrl: url dataDict:nil ResultBlock:^(NSDictionary *result) {
        NSLog(@"%@",result);
        //添加作品数组
        NSArray *products = result[@"data"];
        for(NSDictionary *dict in products)
        {
            UserProductModel *product = [UserProductModel shareModelWithDict:dict];
            [self.dataArray addObject:product];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.productTableVIew reloadData];
            resultBlock();
        });
    }];
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"productlist";
    SquareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    for(id sub in cell.contentView.subviews){
//        [sub removeFromSuperview];
//    }
    
    if(!cell)
    {
        cell = [[SquareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UserProductModel *product = self.dataArray[indexPath.row];
    [cell viewWithModel:product delegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserProductModel *product = self.dataArray[indexPath.row];
    
    ProductDetailViewController *controller = [[ProductDetailViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
    
//    [self intoUserInfo:product];
}

#pragma mark - SquareCellDelegate
//进入用户详情页面
- (void)intoUserInfo:(UserProductModel *)model
{
    
    if(![UserSelfInfoModel shareModel].uid ||
       [model.pauther isEqualToString:[UserSelfInfoModel shareModel].uid])
    {
        return;
    }
    
    UserChatViewController *chatViewController = [[UserChatViewController alloc]initWithTargetId:model.pauther];
    [self.navigationController pushViewController:chatViewController animated:YES];
    
}

- (void)goods:(UserProductModel *)model
{
    
    
}
- (void)cancelgoods:(UserProductModel *)model
{
    
    
}
@end
