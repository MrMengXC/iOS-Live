//
//  ProductDetailViewController.m
//  ChatDemo
//
//  Created by ios on 17/6/11.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ProductDetailViewController.h"
@interface ProductDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *commentTableView;
@property (nonatomic,strong)UIView *bottomView;

@end
@implementation ProductDetailViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
 
    
    
}
- (void)createUI
{
    
    //Product
    UIImageView *product = [[UIImageView alloc]init];
    product.translatesAutoresizingMaskIntoConstraints = NO;
    product.backgroundColor = [UIColor redColor];
    [self.view addSubview:product];
    
    
    
    //评论
    self.commentTableView =[[UITableView alloc]init];
    self.commentTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    _commentTableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.commentTableView];
    
    //底部评论栏
    self.bottomView = [[UIView alloc]init];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.bottomView];
    
    //输入框
    UITextField *textField = [[UITextField alloc]init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = [UIColor redColor].CGColor;
    [self.bottomView addSubview:textField];
    //发送按钮
    UIButton *send = [[UIButton alloc]init];
    send.translatesAutoresizingMaskIntoConstraints = NO;
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:send];
    
    
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(product,_commentTableView,_bottomView,textField,send);
    [UIManager addConstraintWithFormat:@"|[product]|" viewDict:dict superView:self.view];
    
    [UIManager addConstraintWithFormat:@"|[_commentTableView]|" viewDict:dict superView:self.view];
    [UIManager addConstraintWithFormat:@"|[_bottomView]|" viewDict:dict superView:self.view];
    
    [UIManager addConstraintWithFormat:@"|-10-[textField]-5-[send(44)]-10-|" viewDict:dict superView:self.bottomView];
    
    [UIManager addConstraintWithFormat:@"V:|-5-[textField]-5-|" viewDict:dict superView:self.bottomView];
    
    [UIManager addConstraintWithFormat:@"V:|-5-[send]-5-|" viewDict:dict superView:self.bottomView];
    
    [UIManager addConstraintWithFormat:@"V:|-64-[product][_commentTableView][_bottomView(44)]|" viewDict:dict superView:self.view];

    NSLayoutConstraint *product_h = [NSLayoutConstraint constraintWithItem:product attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:product attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.view addConstraints:@[product_h]];
    
    
    
    
    
}
#pragma mark - UITableVIewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"commentlist";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - 发送评论
- (void)sendComment:(UIButton *)button
{
    //作品id 评论方 被回复方 时间
    
    
    
    
}

@end
