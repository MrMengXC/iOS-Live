//
//  SelfInfoView.m
//  ChatDemo
//
//  Created by ios on 17/5/15.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "SelfInfoView.h"
#import "SettingView.h"
#import "SelfProductListView.h"
#import "UserInfoManage.h"
typedef NS_ENUM(NSInteger,BUTTONTAG) {
    
    BUTTON_PRODUCT,
    BUTTON_DRAFT,
    BUTTON_SETTING = 1000,
    
    
    
};

@interface SelfInfoView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic ,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UIImageView *userPhoto;                 //用户头像
@end

@implementation SelfInfoView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    
    //UIImage *originalImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];

    
    UserSelfInfoModel *userModel = [UserSelfInfoModel shareModel];
    //bg
    UIImageView *titleBg = [[UIImageView alloc]initWithFrame:CGRectZero];
    titleBg.translatesAutoresizingMaskIntoConstraints = NO;
    titleBg.backgroundColor = [UIColor yellowColor];
    titleBg.userInteractionEnabled = YES;
    [self addSubview:titleBg];
    
    //UserPhoto
    self.userPhoto = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.userPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    self.userPhoto.backgroundColor = [UIColor greenColor];
    self.userPhoto.userInteractionEnabled = YES;
    [titleBg addSubview:self.userPhoto];
    UITapGestureRecognizer *setUserPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingSelfUserPhoto:)];

    [self.userPhoto addGestureRecognizer:setUserPhoto];
    
    //UserName
    UILabel *userNmae = [[UILabel alloc]init];
    userNmae.translatesAutoresizingMaskIntoConstraints = NO;
    userNmae.textColor = [UIColor blackColor];
    userNmae.text = userModel.uname;
    [titleBg addSubview:userNmae];
    
    //性别
    UIImageView *userGender = [[UIImageView alloc]init];
    userGender.translatesAutoresizingMaskIntoConstraints = NO;
    userGender.image = [UIImage imageNamed:[userModel.ugender isEqualToNumber:@0]?@"icon_male":@"icon_female"];
    [titleBg addSubview:userGender];
    
    //money
    UILabel *moneyNum = [[UILabel alloc]init];
    moneyNum.translatesAutoresizingMaskIntoConstraints = NO;
    moneyNum.textColor = [UIColor blackColor];
    moneyNum.text = [NSString stringWithFormat:@"%@",userModel.umoney];
    [titleBg addSubview:moneyNum];
    
    //money icon
    UIImageView *moneyicon = [[UIImageView alloc]init];
    moneyicon.translatesAutoresizingMaskIntoConstraints = NO;
    moneyicon.image = [UIImage imageNamed:@"icon_coin"];
    [titleBg addSubview:moneyicon];
    
    
    
    //Product
    UIButton *product = [[UIButton alloc]initWithFrame:CGRectZero];
    product.translatesAutoresizingMaskIntoConstraints = NO;
    [product setTitle:@"作品" forState:UIControlStateNormal];
    product.backgroundColor = [UIColor blueColor];
    product.tag = BUTTON_PRODUCT;
    [product addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:product];
    
    
    //draft (草稿)
    UIButton *draft = [[UIButton alloc]initWithFrame:CGRectZero];
    draft.translatesAutoresizingMaskIntoConstraints = NO;
    [draft setTitle:@"草稿" forState:UIControlStateNormal];
    draft.backgroundColor = [UIColor blueColor];
    draft.tag = BUTTON_DRAFT;
    [draft addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:draft];
    
    //Setting
    UIButton *setting = [[UIButton alloc]initWithFrame:CGRectZero];
    setting.translatesAutoresizingMaskIntoConstraints = NO;
    [setting setTitle:@"设置" forState:UIControlStateNormal];
    setting.backgroundColor = [UIColor blueColor];
    setting.tag = BUTTON_SETTING;
    [setting addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setting];
    
    //ScrollView
    self.baseScrollView = [[UIScrollView alloc]init];
    self.baseScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseScrollView.backgroundColor =[UIColor redColor];
    self.baseScrollView.bounces = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.scrollEnabled = YES;
    self.baseScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, 0);
    [self addSubview:self.baseScrollView];
    
    //SettingView
    SettingView *settingView = [[SettingView alloc]init];
    settingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.baseScrollView addSubview:settingView];
    
    //作品列表
    SelfProductListView *productView = [[SelfProductListView alloc]init];
    productView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.baseScrollView addSubview:productView];
    
    CGFloat btn_w = SCREEN_WIDTH/3;
    NSDictionary *dict = NSDictionaryOfVariableBindings(titleBg,_userPhoto,product,draft,setting,_baseScrollView,settingView,userNmae,userGender,moneyNum,moneyicon,productView);
    
    [UIManager addConstraintWithFormat:@"|[titleBg]|" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"|[_baseScrollView]|" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"V:|[titleBg(200)][product(30)][_baseScrollView]|" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"V:[draft(==product)]" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"V:[setting(==product)]" viewDict:dict superView:self];
    NSString *format = [NSString stringWithFormat:@"|[product(%f)][draft(==product)][setting(==product)]",btn_w];
    [UIManager addConstraintWithFormat:format viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"[_userPhoto(80)]" viewDict:dict superView:titleBg];
    [UIManager addConstraintWithFormat:@"V:|-30-[_userPhoto(80)]-10-[userNmae]" viewDict:dict superView:titleBg];
    [UIManager addConstraintWithFormat:@"[userNmae]-8-[userGender]" viewDict:dict superView:titleBg];
    [UIManager addConstraintWithFormat:@"[moneyicon]-5-[moneyNum]-10-|" viewDict:dict superView:titleBg];
    [UIManager addConstraintWithFormat:@"V:|-12-[moneyNum]" viewDict:dict superView:titleBg];
    
    
    NSLayoutConstraint *photo_X = [NSLayoutConstraint constraintWithItem:self.userPhoto attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *userName_X = [NSLayoutConstraint constraintWithItem:userNmae attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titleBg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *userGender_Y = [NSLayoutConstraint constraintWithItem:userGender attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:userNmae attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *moneyicon_Y = [NSLayoutConstraint constraintWithItem:moneyicon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:moneyNum attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [titleBg addConstraints:@[photo_X,userName_X,userGender_Y,moneyicon_Y]];
    
    NSLayoutConstraint *dratf_Y = [NSLayoutConstraint constraintWithItem:draft attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:product attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *setting_Y = [NSLayoutConstraint constraintWithItem:setting attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:product attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraints:@[dratf_Y,setting_Y]];
    
    [self layoutIfNeeded];
    format = [NSString stringWithFormat:@"|-%f-[settingView(%f)]|",2*SCREEN_WIDTH,SCREEN_WIDTH];
    [UIManager addConstraintWithFormat:format viewDict:dict superView:self.baseScrollView];
    format = [NSString stringWithFormat:@"V:|[settingView(%f)]|",CGRectGetHeight(self.baseScrollView.frame)];
    [UIManager addConstraintWithFormat:format viewDict:dict superView:self.baseScrollView];
    
    //作品列表约束
    format = [NSString stringWithFormat:@"|[productView(%f)]",SCREEN_WIDTH];
    [UIManager addConstraintWithFormat:format viewDict:dict superView:self.baseScrollView];
    format = [NSString stringWithFormat:@"V:|[productView(%f)]|",CGRectGetHeight(self.baseScrollView.frame)];
    [UIManager addConstraintWithFormat:format viewDict:dict superView:self.baseScrollView];
    
    
    //设置头像
    self.userPhoto.layer.cornerRadius = self.userPhoto.width/2;
    self.userPhoto.clipsToBounds = YES;
//    NSString *url = [[UserSelfInfoModel shareModel].uimg stringByAppendingFormat:@"?imageView2/0/w/%.0f",userPhoto.width];
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:[UserSelfInfoModel shareModel].uimg]];
    

}


- (void)functionButtonClick:(UIButton *)button
{
    
    switch (button.tag)
    {
        case BUTTON_PRODUCT:
            self.baseScrollView.contentOffset = CGPointMake(0, 0);
            break;
        case BUTTON_DRAFT:
        {
            
            self.baseScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            
        }
            break;
        case BUTTON_SETTING:
            self.baseScrollView.contentOffset = CGPointMake(2*SCREEN_WIDTH, 0);
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - 修改自己的头像
- (void)settingSelfUserPhoto:(UITapGestureRecognizer *)tap
{
    
    UIViewController *infoController = (UIViewController*)self.nextResponder.nextResponder;
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.delegate = self;
    controller.allowsEditing = YES;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [infoController presentViewController:controller animated:YES completion:^{
        
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *userPhoto = info[UIImagePickerControllerEditedImage];
   
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [UserInfoManage setUserPhotoWithImage:userPhoto successBlock:^(NSString *upurl) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新url
                [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:upurl]];
                [UserSelfInfoModel shareModel].uimg = upurl;
            });
            
        } faileBlock:^{
            
        }];
    }];
    
  
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
