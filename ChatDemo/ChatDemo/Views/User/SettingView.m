//
//  SettingView.m
//  ChatDemo
//
//  Created by ios on 17/5/5.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "SettingView.h"
@interface SettingView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *settingTableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;

@end


@implementation SettingView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self createUI];
}
- (void)createUI
{
    [self layoutIfNeeded];
    self.dataArray = [[NSMutableArray alloc]initWithArray:@[@[@"修改信息"],@[@"清理缓存",@"反馈"]]];
    self.settingTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self addSubview:self.settingTableView];

}



#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"settingID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
