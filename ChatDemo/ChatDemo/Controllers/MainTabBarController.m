//
//  MainTabBarController.m
//  ChatDemo
//
//  Created by ios on 17/5/4.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "MainTabBarController.h"
#import "ChatListViewController.h"
#import "SelfInfoViewController.h"
#import "SquareViewController.h"
#import "FiveRowView.h"
#import <QiniuSDK.h>
#import "NSString+Category.h"
#import "LiveStreamViewController.h"
@interface MainTabBarController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@end
@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *square = [self setTabBarItemTitle:@"广场" itemImage:@"square_tab" itemSelectImage:@"square_tab_s" controller:@"SquareViewController"];
    UIViewController *chatList = [self setTabBarItemTitle:@"消息" itemImage:@"chat_tab" itemSelectImage:@"chat_tab_s" controller:@"ChatListViewController"];
    UIViewController *selfController = [self setTabBarItemTitle:@"个人" itemImage:@"self_tab" itemSelectImage:@"self_tab_s" controller:@"SelfInfoViewController"];
    self.viewControllers = @[square,chatList,selfController];
    
    
    //uploadpicture
    
    UIButton *uploadButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    uploadButton.backgroundColor = [UIColor blueColor];
    [uploadButton addTarget:self action:@selector(uploadProduct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem  = [[UIBarButtonItem alloc]initWithCustomView:uploadButton];
    self.navigationItem.rightBarButtonItems = @[buttonItem];
    
}
- (void)uploadProduct:(UIButton *)button
{
    LiveStreamViewController *con = [[LiveStreamViewController alloc]init];
    
    [self presentViewController:con animated:YES completion:^{
        
    }];
    
    return;
    if([UserSelfInfoModel shareModel].uid == NULL)
    {
        [UIManager addMessage:@"请先前往登陆"];
        return;
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
        
        
        
    }];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    [RequestData getDataWithUrl:FF_PRODUCT_UPTOKEN dataDict:nil ResultBlock:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        NSString *token = result[@"data"][@"token"];
        NSString *url = result[@"data"][@"url"];
        
        QNUploadManager *upmanager = [[QNUploadManager alloc]init];
        NSData *data =  UIImagePNGRepresentation(image);
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:@{ @"x:foo":@"fooval" } checkCrc:YES cancellationSignal:nil];
        
        
        
        
        NSString *key = [NSString stringWithFormat:@"%@/%@.png",[UserSelfInfoModel shareModel].uid ,[[NSString stringWithFormat:@"%@",[NSDate date]]md5]];
        
        [upmanager putData:data key:[key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"%@",resp);
            NSLog(@"info:%@",info);
            //
            [self uploadProductWithOriUrl:[NSString stringWithFormat:@"%@%@",url,key]];
            [picker dismissViewControllerAnimated:YES completion:^{
            }];
        } option:opt];
        
    }];
    
}
- (void)uploadProductWithOriUrl:(NSString *)poriurl
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *dict = @{
                           @"poriurl":poriurl,
                           @"pauther":[UserSelfInfoModel shareModel].uid,
                           @"ptype":@0,
                           @"ptime":time,
                           @"uid":[UserSelfInfoModel shareModel].uid,
                           };
    
    [RequestData postDataWithUrl:FF_PRODUCT_UPLOAD dataDict:dict ResultBlock:^(NSDictionary *result) {
        NSLog(@"upload:%@",result);
    }];
    
    
    
}
- (UIViewController *)setTabBarItemTitle:(NSString *)title
                 itemImage:(NSString *)imageName
           itemSelectImage:(NSString *)selectImageName
                controller:(NSString *)className

{

    UIImage *itemImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *itemselecImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIViewController * controller =  (UIViewController *)([[NSClassFromString(className) alloc]init]);

    controller.view.backgroundColor = [UIColor whiteColor];
    controller.tabBarItem.image = itemImage;
    controller.tabBarItem.selectedImage = itemselecImage;
    controller.tabBarItem.title = title;
    return controller;
}

@end
