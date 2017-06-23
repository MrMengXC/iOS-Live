//
//  MadeFaceDataManager.m
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "MadeFaceDataManager.h"
static MadeFaceDataManager *_manager = NULL;
static dispatch_once_t once;

@interface MadeFaceDataManager ()

@property (nonatomic ,strong)NSMutableDictionary *shapeDict;
@property (nonatomic ,strong)NSMutableArray *basicShapeSelectArray;     //基础部位选单数组

@property (nonatomic ,strong)NSMutableArray *shapelocation;                      //部位位置数组
@property (nonatomic ,strong)NSMutableArray *deleteShapeArray;              //需要删除健位的部位数组

@property (nonatomic ,strong)NSMutableDictionary *shapeExtra;                   //部位额外字典

@end
@implementation MadeFaceDataManager
+ (MadeFaceDataManager *)shareManager
{
    dispatch_once(&once
                  , ^{
                      _manager = [[MadeFaceDataManager alloc]init];
                      
                      [_manager loadPartData];
                      [_manager loadDataConfig];
                  });
    
    
    return _manager;
}

- (void)loadPartData
{

    self.shapeDict = [[NSMutableDictionary alloc]init];
    
    NSString *locPath = [[NSBundle mainBundle]pathForResource:@"Basic_loc.json" ofType:@""];
    NSDictionary *locData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:locPath] options:NSJSONReadingMutableLeaves error:nil];
    
    for(NSString *shape in locData.allKeys)
    {
        NSMutableDictionary *tem_shape = [[NSMutableDictionary alloc]init];
        
        
        NSMutableDictionary *m_shape = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *w_shape = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *g_shape = [[NSMutableDictionary alloc]init];

        NSArray *parts = locData[shape][@"data"];
        for(NSDictionary *partDict in parts)
        {
            
            PartModel *partModel = [[PartModel alloc]initWithValue:partDict partType:shape];
            if([partModel.gender isEqualToString:@"m"])
            {
                m_shape[@(partModel.partId)] = partModel;
                
            }else if ([partModel.gender isEqualToString:@"w"])
            {
                w_shape[@(partModel.partId)] = partModel;
            }
            else if ([partModel.gender isEqualToString:@"g"])
            {
                g_shape[@(partModel.partId)] = partModel;
            }

            
        }
        
        if(m_shape.count > 0)
        {
            tem_shape[@"m"] = m_shape;
        
        }else if(w_shape.count > 0)
        {
            tem_shape[@"w"] = w_shape;
        
        }else if (g_shape.count > 0)
        {
            tem_shape[@"g"] = g_shape;
        }
        self.shapeDict[shape] = tem_shape;
    }

}
- (void)loadDataConfig
{
    
    
    NSString *dataconfg = [[NSBundle mainBundle]pathForResource:@"dataConfig.json" ofType:@""];
    NSDictionary *dataconfgDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataconfg] options:NSJSONReadingMutableLeaves error:nil];
    self.basicShapeSelectArray = [[NSMutableArray alloc]initWithArray:dataconfgDict[@"basic_shape_select"]];
    self.shapelocation = [[NSMutableArray alloc]initWithArray:dataconfgDict[@"shapes_location"]];
    self.deleteShapeArray = [[NSMutableArray alloc]initWithArray:dataconfgDict[@"delete_shape"]];

    self.shapeExtra = [[NSMutableDictionary alloc]initWithDictionary:dataconfgDict[@"shapeExtId"]];
}

#pragma mark - 获取部位数组
- (NSArray *)getShapeArrayWithShape:(NSString *)shape gender:(NSString *)gender
{
    
    NSArray *array =[ self.shapeDict[shape][gender] allValues];
    NSArray *res = [array sortedArrayUsingComparator:^NSComparisonResult(PartModel * obj1, PartModel * obj2)
    {
        return obj1.locId > obj2.locId;
    }];
    
    return res;
}

#pragma mark - 随即获取拼脸的部位
- (NSDictionary *)randomGetShapes
{
    
    NSMutableArray *tem = [[NSMutableArray alloc]initWithArray:self.basicShapeSelectArray];
    
    NSMutableArray *tem2 = [[NSMutableArray alloc]initWithArray:self.basicShapeSelectArray];

    for(int i = 0 ;i < self.basicShapeSelectArray.count/2;i++)
    {
        
        NSString *shape = tem[arc4random()%tem.count];
        [tem removeObject:shape];
        [tem2 addObject:shape];
    }
    
    NSMutableArray *self_shape = [[NSMutableArray alloc]init];
    NSMutableArray *oppose_shape = [[NSMutableArray alloc]init];
    
    for(NSString *shape in self.basicShapeSelectArray)
    {
        if([tem containsObject:shape])
        {
            [self_shape addObject:shape];
            
        }
        else{
            [oppose_shape addObject:shape];

            
        }
    }
    
    return @{@"self":self_shape,@"oppose":oppose_shape};

}

- (PartModel *)getPartModelWithShape:(NSString *)shape
                                  partId:(NSInteger)partId
                              gender:(NSString *)gender
{
    if([gender isEqualToString:@""] || partId == -1)
    {
    
       
        PartModel *model = [[PartModel alloc]init];
        model.partId = -1;
        model.partType = shape;
        model.gender = @"";
        model.imgPath = @"";
        model.iconPath = @"";
        return model;
    
    }else{
        
        NSDictionary *partDict =self.shapeDict[shape][gender];
        return partDict[@(partId)];
    }
  
    
}
#pragma mark - 获取所有显示部位数组
- (NSArray *)getShapesLocation
{
    
    return self.shapelocation;
    
}

//判断是否添加删除键
- (BOOL)isAddDelete:(NSString *)shape
{
    return [self.deleteShapeArray containsObject:shape];
}
@end
