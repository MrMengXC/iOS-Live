//
//  ChatViewManager.m
//  ChatDemo
//
//  Created by ios on 17/4/25.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ChatViewManager.h"
#import "UserChatCell.h"
#import "MadeFaceView.h"
#import "FiveRowView.h"
#import "FiveRowManager.h"

typedef NS_ENUM(NSInteger , Alert_Tag) {
    Alert_MadeFace_Invite = 2000,       //拼脸邀请
    Alert_MadeFace_EndInvite,       //拼脸结束邀请
    Alert_FiveRow_Invite,                           //五子棋邀请
};

@interface ChatViewManager ()<UITableViewDataSource , UITableViewDelegate,ChatBottomViewDelegate,ChatManagerDelegate,ChatFunctionViewDelegate>
{
    CGFloat _cellHeight;
}
@property (nonatomic ,strong)id delegate;
@property (nonatomic ,strong)ChatFunctionView *functionView;
@property (nonatomic ,strong)ChatBottomView *bottomView;
@property (nonatomic ,strong)MadeFaceView *madeFaceView;        //拼脸视图
@property (nonatomic ,strong)FiveRowView *fiveRowView;                    //五子棋视图

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray  *userChatList;
@property (nonatomic ,strong)NSString  *targetId;

@end
@implementation ChatViewManager

+ (ChatViewManager *)shareManagerWithDelegate:(id)delegate targetId:(NSString *)temtargetId
{
    //设置接收消息代理
    
    ChatViewManager *manager= [[ChatViewManager alloc]init];
    manager.userChatList = [[NSMutableArray alloc]init];
    manager.targetId = temtargetId;
    manager.delegate = delegate;
    [manager showBaseView];
    [ChatManager shareManager].delegate = manager;


    return manager;

}


- (void)showBaseView
{
    
    
    
    NSArray *array = [[ChatManager shareManager]getUserChatListWithTargetId:self.targetId];
    [self.userChatList addObjectsFromArray:array];
    UIViewController *controller = (UIViewController *)self.delegate;
 
    self.tableView = [[UITableView alloc]init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [controller.view addSubview:self.tableView];
    
    
    //输入框
    self.bottomView = [[ChatBottomView alloc]init];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    self.bottomView.tag = 1000;
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.delegate = self;
    [controller.view addSubview:self.bottomView];
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_bottomView,_tableView);
    
    [UIManager addConstraintWithFormat:@"|[_bottomView]|" viewDict:dict superView:controller.view];
    [UIManager addConstraintWithFormat:@"V:|[_tableView][_bottomView]" viewDict:dict superView:controller.view];
    [UIManager addConstraintWithFormat:@"|[_tableView]|" viewDict:dict superView:controller.view];
    
    self.bottomView.baseview_Y = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:controller.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [controller.view addConstraint:self.bottomView.baseview_Y];
    
    self.bottomView.baseview_H = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44.0f];
    [controller.view addConstraint:self.bottomView.baseview_H];
    [controller.view layoutIfNeeded];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
    //添加关闭键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard:)];
    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouches = 1;
    [self.tableView addGestureRecognizer:tap];
    
    
}

- (void)hiddenKeyBoard:(UITapGestureRecognizer *)tap
{

    [self.bottomView hidderKeyBoardWithIsBottom:YES];
    
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userChatList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *chatCell = @"ChatCellID";
    UserChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell];
    
    if(cell == nil){
        cell = [[UserChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCell];
    }
    cell.backgroundColor = [UIColor clearColor];
    //    for(id obj in cell.contentView.subviews){
    //        [obj removeFromSuperview];
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChatMessageModel *model = self.userChatList[indexPath.row];
    _cellHeight =  [cell initSubViewWithModel:model];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

#pragma mark - ChatBottomViewDelegate---------------

//发送消息
- (void)sendMessage
{
    //    NSDictionary *dict = [[MadeFaceDataManager shareManager] randomGetShapes];
    //
    //    NSArray *self_shapes = dict[@"self"];
    //    [self beginMadeFaceWithShapes:self_shapes];
    //    return;
    

    [[ChatManager shareManager] sendTextMessage:@"hhhh" targetId:self.targetId successBlock:^{
        
    } faileBlock:^{
        
    }];

    
//        if(![self.textField.text isEqualToString:@""])
//        {
//            [[ChatManager shareManager]sendTextMessage:self.textField.text targetId:targetId];
//        }
//    
    
}

#define View_Height 200
//显示其他功能View
- (void)showOtherFunction
{
    UIViewController *controller = (UIViewController *)self.delegate;

    if(!self.functionView)
    {
        self.functionView = [[ChatFunctionView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(controller.view.frame), SCREEN_WIDTH, View_Height)];
        self.functionView.delegate = self;
        [controller.view addSubview:self.functionView];
    }
    
    [self.bottomView hidderKeyBoardWithIsBottom:NO];
    __block CGRect frame = self.functionView.frame;
    //进行约束
    [UIView animateWithDuration:0.5f animations:^
    {
        self.bottomView.baseview_Y.constant = -View_Height;
        frame.origin.y -= View_Height;
        self.functionView.frame = frame;
        [controller.view layoutIfNeeded];

    
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark - ChatFunctionViewDelegate-------
-(void)selectChatFunction:(ChatFunctionType)type
{
    
    switch (type) {
        case CF_TakePicture:
            
            break;
        case CF_MadeFace:
            [[ChatManager shareManager] sendGameInviteMessage:GAME_MadeFace targetId:self.targetId successBlock:^{
                
                
            } faileBlock:^{
                
            }];
            break;
        case CF_FiveRow:
//            [self beginFiveRow];
            [[ChatManager shareManager] sendGameInviteMessage:GAME_FiveRow targetId:self.targetId successBlock:^{
                
                
            } faileBlock:^{
                
            }];
            break;
        default:
            break;
    }
 
}

#pragma mark - ChatManagerDelegate-------------
- (void)receveMessage:(ChatMessageModel *)model
{
    
    if(![model.sendUserId isEqualToString:self.targetId])
    {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userChatList addObject:model];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.userChatList.count - 1 inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
        
        [self scrollBottom];
        
    });
        
        
    
    NSLog(@"有新消息");
    
}

//接收游戏邀请回调
- (void)receveGameInviteMessage:(RCMessage *)message
{
    
    if([message.senderUserId isEqualToString:self.targetId])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            GameInviteMessageContent *content = (GameInviteMessageContent *)message.content;
            //拼脸游戏 && 对方时邀请者
            if(content.type == GAME_MadeFace && content.isInvitor == YES)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"邀请您一起拼脸" delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"接受", nil];
                alertView.tag = Alert_MadeFace_Invite;
                [alertView show];
                
            }
            //拼脸游戏 && 对方是接收者 && 接受游戏
            else if(content.type == GAME_MadeFace && content.isInvitor == NO && content.isAccept)
            {
                [self beginMadeFaceWithShapes:content.resultExtraData];
            }
            
            //五子棋游戏 && 对方时邀请者
            if(content.type == GAME_FiveRow && content.isInvitor == YES)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"邀请您一起玩五子棋" delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"接受", nil];
                alertView.tag = Alert_FiveRow_Invite;
                [alertView show];
            }
            
            //五子棋游戏 && 对方是接收者 && 接受游戏
            else if(content.type == GAME_FiveRow && content.isInvitor == NO && content.isAccept)
            {
                //
                
                NSLog(@"进入物资棋游戏");
                [self beginFiveRowWithIsFirst:YES];
            }
            
            
            
            
            
            
        });
    }
    
}
//接收到游戏数据
- (void)receveGameDataMessage:(RCMessage *)message
{
    
    if([message.senderUserId isEqualToString:self.targetId])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            GameDataMessageContent *content = (GameDataMessageContent *)message.content;
            
            //拼脸游戏
            if(content.type == GAME_MadeFace)
            {
                
                MadeFace_DATA_TYPE type = [content.contentDict[@"type"] integerValue];
                if(type == MADEFACE_DATA)       //拼脸部位数据
                {
                    [self madefaceDataWithContent:content];
                    
                }else if (type == MADEFACE_MESSAGE)     //拼脸信息
                {
                    
                    [[MadeFaceManager shareManager]receiveMadeFaceMessage:content.contentDict[@"data"]];
                    
                }else if (type == MADEFACE_RESULT)          //拼脸结果
                {
                    
                    [self madeFaceResultWithContent:content];
                }
                
                //五子棋游戏
            }else if (content.type == GAME_FiveRow)
            {
                FiveRow_DATA_TYPE type = [content.contentDict[@"type"] integerValue];
                if(type == FIVEROW_DATA)
                {
                    [[FiveRowManager shareManager] receiveOpposeChessLocation:content.contentDict[@"data"]];
                }
                
            }
            
            
        });
    }
    
}

#pragma mark - 拼脸游戏的数据
- (void)madefaceDataWithContent:(GameDataMessageContent *)content
{
    
    NSDictionary *shapeDict = content.contentDict[@"data"];
    //TODO:最好判断下是否改变
    for(NSString *shape in shapeDict.allKeys)
    {
        
        NSDictionary *part = shapeDict[shape];
        PartModel *model = [[MadeFaceDataManager shareManager]getPartModelWithShape:shape partId:[part[@"id"]integerValue]  gender:part[@"gender"]];
        
        [[MadeFaceManager shareManager] selectPartShowWithPartModel:model];
        
    }
}

#pragma mark - 拼脸结果
- (void)madeFaceResultWithContent:(GameDataMessageContent *)content
{
    
    MadeFace_RESULT_TYPE resultType = [content.contentDict[@"data"][@"type"] integerValue];
    
    switch (resultType)
    {
            
        case MADEFACE_RES_ENDINVITE:
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"对方决定完成作品" delegate:self cancelButtonTitle:@"再等等" otherButtonTitles:@"可以", nil];
            alertView.tag = Alert_MadeFace_EndInvite;
            [alertView show];
        }
            break;
        case MADEFACE_RES_ENDFAILE:
        {
            
            [UIManager addMessage:@"对方想要再等一会"];
        }
            break;
        case MADEFACE_RES_ENDSUCCESS:
        {
            //获取他的部分id
            NSDictionary *shapeDict = content.contentDict[@"data"][@"shape"];
            [self componseProductWithShapeDict:shapeDict];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}
//合成作品
- (void)componseProductWithShapeDict:(NSDictionary *)shapeDict
{
    UIImage *result = [MadeFaceManager componseProductWithShapeDict:shapeDict];
    UIViewController *controller = (UIViewController *)self.delegate;

    
    if(result)
    {
        NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/componse.png"];
        if([UIImagePNGRepresentation(result) writeToFile:savePath atomically:YES])
        {
            NSLog(@"Svae success %@",savePath);
        }
        
    }
    controller.navigationController.navigationBarHidden = NO;
    [[MadeFaceManager shareManager] backMadeFace];
}


#pragma mark  - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == Alert_MadeFace_Invite)
    {
        //接受
        NSDictionary *dict = [[MadeFaceDataManager shareManager] randomGetShapes];
        
        NSArray *self_shapes = dict[@"self"];
        NSArray *oppose_shapes = dict[@"oppose"];
        [[ChatManager shareManager] sendGameInviteResultMessage:GAME_MadeFace
                                                       isAccept:YES
                                                resultExtraData:oppose_shapes
                                                       targetId:self.targetId successBlock:^{
                                                           
                                                       } faileBlock:^{
                                                           
                                                       }];
        [self beginMadeFaceWithShapes:self_shapes];
        
        
        //不接受
    }
    else if (alertView.tag == Alert_MadeFace_EndInvite)
    {
        if(buttonIndex == 0){       //再等等
            
            NSDictionary *dataDcit = @{@"type":@(MADEFACE_RES_ENDFAILE)};
            [[ChatManager shareManager] sendGameDataMessage:GAME_MadeFace madeFaceType:MADEFACE_RESULT fiveRowType:FIVEROW_NONE dataDict:dataDcit targetId:[MadeFaceManager shareManager].targetId successBlock:^{
                
            } faileBlock:^{
                
            }];
            
        }else{                                  //确定
            
            //见当前所有部位的ID发过去
            NSDictionary *shapeDict = [self.madeFaceView getAllShapId];
            NSDictionary *dataDcit = @{@"type":@(MADEFACE_RES_ENDSUCCESS),@"shape":shapeDict};
            
            [[ChatManager shareManager] sendGameDataMessage:GAME_MadeFace madeFaceType:MADEFACE_RESULT fiveRowType:FIVEROW_NONE dataDict:dataDcit targetId:[MadeFaceManager shareManager].targetId successBlock:^{
                
            } faileBlock:^{
                
            }];
            [self componseProductWithShapeDict:shapeDict];
            
        }
    }
   else if(alertView.tag == Alert_FiveRow_Invite)
    {
        //接受
        
        [[ChatManager shareManager] sendGameInviteResultMessage:GAME_FiveRow
                                                       isAccept:YES
                                                resultExtraData:nil
                                                       targetId:self.targetId
                                                   successBlock:^{
                                                   
                                                       
                                                       } faileBlock:^{
                                                           
                                                       }];
        
        //开始进入五子棋界面
        [self beginFiveRowWithIsFirst:NO];
        
        
        //不接受
    }
    
    
    
    
    
}

#pragma mark - 开始进入拼脸界面
- (void)beginMadeFaceWithShapes:(NSArray *)shapes
{
    UIViewController *controller = (UIViewController *)self.delegate;
    controller.navigationController.navigationBarHidden = YES;
    if(self.madeFaceView == NULL && shapes != nil)
    {
        self.madeFaceView = [[MadeFaceView alloc]initWithFrame:controller.view.bounds targetId:self.targetId];
        [controller.view addSubview:self.madeFaceView];
        
        [[MadeFaceManager shareManager]setTargetId:self.targetId madeFaceView:self.madeFaceView madeFaceMessageView:self.madeFaceView.messageView];
    }
    [self.madeFaceView viewAssignWithArray:shapes];
}

#pragma mark - 开始进入五子棋界面
- (void)beginFiveRowWithIsFirst:(BOOL)isFirstMove
{
    UIViewController *controller = (UIViewController *)self.delegate;
    controller.navigationController.navigationBarHidden = YES;
    if(self.fiveRowView == NULL)
    {
        self.fiveRowView = [[FiveRowView alloc]initWithFrame:controller.view.bounds isFirstMove:isFirstMove];
        [controller.view addSubview:self.fiveRowView];
        [[FiveRowManager shareManager] setTargetId:self.targetId delegate:self.fiveRowView];
    }    
}

- (void)showKeyBoard:(NSNotification *)notification
{
    
    UIViewController *controller = (UIViewController *)self.delegate;
    
    if(self.functionView.bounds.origin.y != CGRectGetHeight(controller.view.frame)){
        CGRect frame = self.functionView.frame;
        frame.origin.y = CGRectGetHeight(controller.view.frame);
        self.functionView.frame = frame;
    }
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 滚入到最底下
- (void)scrollBottom
{
    
//    [self.view layoutIfNeeded];
//    [self.tableVIew scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.userChatList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

@end
