//
//  MadeFaceView.m
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "MadeFaceView.h"
#import "ImageHandleManager.h"
@interface MadeFaceView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    NSString *targetId;
    
}
@property (nonatomic ,strong)UIScrollView *shapeScr;        //部位选择
@property (nonatomic ,strong)UICollectionView *partSelectCollectionView;        //部位选择

@property (nonatomic ,strong)NSMutableArray *shapeSelects;        //部位选择
@property (nonatomic ,strong)NSMutableArray *currentParts;        //部位选择
@property (nonatomic ,strong)NSMutableDictionary *imageDict;        //部位选择
@property (nonatomic ,strong)NSMutableDictionary *shapeDict;        //部位字典


@end
static NSString * cellID = @"PartSelectCell";
static NSString * headerID = @"headerView";
@implementation MadeFaceView

- (id)initWithFrame:(CGRect)frame targetId:(NSString *)temtargetId
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        targetId = temtargetId;
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    
    self.shapeDict = [[NSMutableDictionary alloc]init];
    //添加一个NavgationBar
    UIView *navgationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navgationBar.backgroundColor = [UIColor blueColor];
    [self addSubview:navgationBar];
    
    UIButton *back = [[UIButton alloc]init];
    back.translatesAutoresizingMaskIntoConstraints = NO;
    [back setTitle:@"退出" forState:UIControlStateNormal];
    [navgationBar addSubview:back];
    [back addTarget:self action:@selector(backController:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *finish = [[UIButton alloc]init];
    finish.translatesAutoresizingMaskIntoConstraints = NO;
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [navgationBar addSubview:finish];
    [finish addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(finish,back);
    [UIManager addConstraintWithFormat:@"|-20-[back]" viewDict:dict superView:navgationBar];
    [UIManager addConstraintWithFormat:@"V:[back]-10-|" viewDict:dict superView:navgationBar];
    [UIManager addConstraintWithFormat:@"[finish]-20-|" viewDict:dict superView:navgationBar];
    [UIManager addConstraintWithFormat:@"V:[finish]-10-|" viewDict:dict superView:navgationBar];
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    baseView.center = self.center;
    baseView.userInteractionEnabled = YES;
    [self addSubview:baseView];
        

    if(self.imageDict == nil){
        self.imageDict = [[NSMutableDictionary alloc]init];
    }
    
    NSArray *shapes =  [[MadeFaceDataManager shareManager]getShapesLocation];
    
    
    for(NSString *shape in shapes)
    {
        UIImageView *shapeImageView = [[UIImageView alloc]init];
        [baseView insertSubview:shapeImageView atIndex:[shapes indexOfObject:shape]];
        self.imageDict[shape] = shapeImageView;
    }
    
    
    
    self.messageView = [[MadeFaceMessageView alloc]init];
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.messageView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/5, 80);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.partSelectCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.partSelectCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.partSelectCollectionView.backgroundColor = [UIColor blackColor];
    self.partSelectCollectionView.delegate = self;
    self.partSelectCollectionView.dataSource = self;
    [self.partSelectCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    [self.partSelectCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];

    [self addSubview:self.partSelectCollectionView];
    
    
    self.shapeScr = [[UIScrollView alloc]init];
    self.shapeScr.translatesAutoresizingMaskIntoConstraints = NO;
    self.shapeScr.backgroundColor = [UIColor blueColor];
    self.shapeScr.userInteractionEnabled = YES;
    [self addSubview:self.shapeScr];
    
    dict = NSDictionaryOfVariableBindings(_partSelectCollectionView,_shapeScr,_messageView);
    [UIManager addConstraintWithFormat:@"|[_shapeScr]|" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"|[_messageView]|" viewDict:dict superView:self];

    [UIManager addConstraintWithFormat:@"|[_partSelectCollectionView]|" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"V:|-64-[_messageView][_shapeScr(40)][_partSelectCollectionView(80)]|" viewDict:dict superView:self];
    
    [self layoutIfNeeded];
    [self.partSelectCollectionView reloadData];
    
    
    //默认第一个
}

#pragma mark - 视图进行赋值
- (void)viewAssignWithArray:(NSArray *)array
{
    self.shapeSelects = [[NSMutableArray alloc]initWithArray:array];
    self.currentParts = [[NSMutableArray alloc]init];
    
    for(UIView *subView in self.shapeScr.subviews){
        [subView removeFromSuperview];
    }
    
    CGFloat width = SCREEN_WIDTH/3;
    for(NSString *shape in array)
    {
    
        
        UIButton *shapeBtn = [[UIButton alloc]init];
        shapeBtn.tag = 2000 + [self.shapeSelects indexOfObject:shape];
        shapeBtn.translatesAutoresizingMaskIntoConstraints = NO;
        shapeBtn.userInteractionEnabled = YES;
        [shapeBtn setTitle:shape forState:UIControlStateNormal];
        [shapeBtn addTarget:self action:@selector(cutShapeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shapeScr addSubview:shapeBtn];
        
        

        NSDictionary *dict = NSDictionaryOfVariableBindings(shapeBtn);
        NSString *format;
        
        if([array indexOfObject:shape] == array.count - 1)
        {
            format = [NSString stringWithFormat:@"|-%f-[shapeBtn(%f)]|",width *[array indexOfObject:shape],width];
        }else{
            format = [NSString stringWithFormat:@"|-%f-[shapeBtn(%f)]",width *[array indexOfObject:shape],width];
        }
       
        [UIManager addConstraintWithFormat:format viewDict:dict superView:self.shapeScr];
        [UIManager addConstraintWithFormat:@"V:|[shapeBtn]|" viewDict:dict superView:self.shapeScr];

        
    }
    
    
    //获取当前部位选单Array
    NSArray *parts = [[MadeFaceDataManager shareManager]getShapeArrayWithShape:array[0] gender:@"m"];
    [self.currentParts addObjectsFromArray:parts];
    [self.partSelectCollectionView reloadData];
    
    
}
#pragma mark - 切换部位
- (void)cutShapeButtonClick:(UIButton *)button
{
    NSString *shape = self.shapeSelects[button.tag - 2000];
    [self.currentParts removeAllObjects];
    
    //获取当前部位选单Array
    NSArray *parts = [[MadeFaceDataManager shareManager]getShapeArrayWithShape:shape gender:@"m"];
    
    [self.currentParts addObjectsFromArray:parts];
    //判断部位是否添加删除键位
    BOOL isAdd = [[MadeFaceDataManager shareManager] isAddDelete:shape];
    if(isAdd)
    {
        PartModel *deletePartModel = [[PartModel alloc]init];
        deletePartModel.partId = -1;
        deletePartModel.partType = shape;
        deletePartModel.gender = @"";
        deletePartModel.imgPath = @"";
        deletePartModel.iconPath = @"";
        [self.currentParts insertObject:deletePartModel atIndex:0];
    }
    
    [self.partSelectCollectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentParts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell  = [self.partSelectCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    PartModel *model = self.currentParts[indexPath.item];
    UIImageView *icon = [cell.contentView viewWithTag:1000];
    UIImage *image = [ImageHandleManager getImageWithFileName:model.iconPath];
    if(icon == NULL)
    {
        icon= [[UIImageView alloc]init];
        icon.translatesAutoresizingMaskIntoConstraints = NO;
        icon.tag = 1000;
        [cell.contentView addSubview:icon];
        NSDictionary *dict = NSDictionaryOfVariableBindings(icon);
        [UIManager addConstraintWithFormat:@"[icon(40)]" viewDict:dict superView:cell.contentView];
        [UIManager addConstraintWithFormat:@"V:[icon(40)]" viewDict:dict superView:cell.contentView];
        
         NSLayoutConstraint *center_x = [NSLayoutConstraint constraintWithItem:icon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        
        NSLayoutConstraint *center_y = [NSLayoutConstraint constraintWithItem:icon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
         
         [cell.contentView addConstraints:@[center_x,center_y]];
        
    }
    if(image)
    {
        icon.image =  image;
    }
    else{
        icon.image =  NULL;
        icon.backgroundColor = [UIColor greenColor];
    }

    return cell;
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    PartModel *model = self.currentParts[indexPath.item];
    [self selectPartShowWithPartModel:model];
    
    //发送游戏数据
    [[ChatManager shareManager] sendGameDataMessage:GAME_MadeFace madeFaceType:MADEFACE_DATA fiveRowType:FIVEROW_NONE dataDict:self.shapeDict[@"self"] targetId:targetId successBlock:^{
        
    } faileBlock:^{
        
    }];
    
    
    
    
}
#pragma mark - MadeFaceDelegaet
//  选择部位进行显示
#define C_Size 1080
- (void)selectPartShowWithPartModel:(PartModel *)partModel
{
    
    NSMutableDictionary *oppose_dict = self.shapeDict[@"oppose"];

    if(oppose_dict != NULL && oppose_dict[partModel.partType] != NULL){
        
        NSInteger tem = [oppose_dict[partModel.partType][@"id"] integerValue];
        if(tem == partModel.partId){
            return;
        }
    }

    
    //装入字典
    if([self.shapeSelects containsObject:partModel.partType]){
        
        NSMutableDictionary *dict = self.shapeDict[@"self"];
        if(dict == NULL){
            dict = [[NSMutableDictionary alloc]init];
        }
        dict[partModel.partType] = @{@"id":@(partModel.partId),@"gender":partModel.gender};
        self.shapeDict[@"self"] = dict;
        
    }else{
        
        NSMutableDictionary *dict = self.shapeDict[@"oppose"];
        if(dict == NULL){
            dict = [[NSMutableDictionary alloc]init];
        }
        dict[partModel.partType] = @{@"id":@(partModel.partId),@"gender":partModel.gender};
        self.shapeDict[@"oppose"] = dict;
        
    }
    
    
    //显示部位
    UIImage *image = [ImageHandleManager getImageWithFileName:partModel.imgPath];
     float canScale = SCREEN_WIDTH / C_Size;
     CGRect frame;
     UIImageView *faceImg = self.imageDict[partModel.partType];
    
     faceImg.hidden = YES;
     
     if (!partModel.partType || !image)
     {
         faceImg.image = [UIImage imageNamed:@""];
        return;
     }
    
    faceImg.image =image;

//     if([partModel.partType isEqualToString:@"bgImg"])           //背景(iPhone /iPad)
//     {
//     CGFloat bit = kScreenWidth/image.size.width;//MAX(kScreenWidth/image.size.width,kScreenHeight/image.size.height);
//     frame = CGRectMake(0, 0, image.size.width *bit, image.size.height *bit);
//     }
//     else{
     frame = CGRectMake(partModel.location.x * canScale, partModel.location.y * canScale,(image.size.width/C_Size) * SCREEN_WIDTH, (image.size.height/C_Size) * SCREEN_WIDTH);
//     }
    
    faceImg.frame = frame;
     faceImg.hidden = NO;
     
    
   
    
    
}
//退出拼脸
- (void)backMadeFace
{
    
    [self removeFromSuperview];
}



///获取所有数据ID
- (NSDictionary *)getAllShapId
{
    NSMutableDictionary *shapeDcit = [[NSMutableDictionary alloc]init];
    
    for(NSDictionary *dict in self.shapeDict.allValues)
    {
        for(NSString  *part in dict.allKeys)
        {
            shapeDcit[part] = dict[part];
        }
        
    }
    
    return shapeDcit;
    
}


- (void)backController:(UIButton *)button
{
//    [self.navigationController popViewControllerAnimated:YES];
    
}
//完成
- (void)finishButtonClick:(UIButton *)button
{
    NSDictionary *dataDcit = @{@"type":@(MADEFACE_RES_ENDINVITE)};
    [[ChatManager shareManager] sendGameDataMessage:GAME_MadeFace madeFaceType:MADEFACE_RESULT fiveRowType:FIVEROW_NONE dataDict:dataDcit targetId:[MadeFaceManager shareManager].targetId successBlock:^{
        
    } faileBlock:^{
        
    }];
}
@end
