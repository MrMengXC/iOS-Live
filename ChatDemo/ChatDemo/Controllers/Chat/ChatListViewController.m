//
//  ChatListViewController.m
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ChatListViewController.h"
#import "UserChatViewController.h"

@interface ChatListViewController()<UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, strong)UITableView *chatListTableVIew;
@property (nonatomic, strong)NSMutableArray *chatlistArray;

@end
@implementation ChatListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.chatlistArray removeAllObjects];
    NSArray *chatlist = [[ChatManager shareManager]getChatList];
    [self.chatlistArray addObjectsFromArray:chatlist];

    [self.chatListTableVIew reloadData];
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.chatlistArray = [[NSMutableArray alloc]init];
    [self createUI];
}
- (void)createUI
{
    self.chatListTableVIew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
//    self.chatListTableVIew.translatesAutoresizingMaskIntoConstraints = NO;
    self.chatListTableVIew.delegate = self;
    self.chatListTableVIew.dataSource = self;
    [self.view addSubview:self.chatListTableVIew];
    [UIManager clearFooterView:self.chatListTableVIew];
    [self.chatListTableVIew reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.chatlistArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ChatList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == NULL)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    ChatListModel *model = self.chatlistArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld 个未读",model.unreadMessageCount];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
    ChatListModel *model = self.chatlistArray[indexPath.row];
    UserChatViewController *chatViewController = [[UserChatViewController alloc]initWithTargetId:model.targetId];
    [self.navigationController pushViewController:chatViewController animated:YES];
    
}
@end
