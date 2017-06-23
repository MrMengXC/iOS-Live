//
//  AppDelegate.m
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "API.h"
#import "UserDefaultsManage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    [RequestData getDataWithUrl:FF_LIVE_CREATE dataDict:nil ResultBlock:^(NSDictionary *result) {
        NSLog(@"%@",result);
    }];

    [MadeFaceDataManager shareManager];
    [self thirdRigest];
    
    MainTabBarController *tabBarController = [[MainTabBarController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabBarController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    //保存当前用户信息
    NSString *uid = [UserDefaultsManage getUserId];
    if(uid == NULL || [uid isEqualToString:@""]){
        return YES;
    }
    NSString * url = [NSString stringWithFormat:FF_USER_LOGIN,uid];
    [RequestData getDataWithUrl:url dataDict:nil ResultBlock:^(NSDictionary *result) {
        
//        NSLog(@"%@",result);
        if([result[@"code"] integerValue] == 100)
        {
            //获取user信息
            //赋值单利用户model / 链接容云服务器
            NSDictionary *userDict = result[@"data"];
            [UserSelfInfoModel shareModelWithDict:userDict];
            [ChatManager shareManager];
            
        }else{          //用户不存
        }
    }];
    
    
    return YES;
}

#pragma mark - 三方登陆／分享注册
- (void)thirdRigest
{

//
//    
//    [ShareSDK registerApp:@"1d696f0a24a80" activePlatforms:@[@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
//        
//        switch (platformType) {
//            case SSDKPlatformTypeQQ:
//            {
//                
//                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        
//        
//    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//        switch (platformType) {
//            case SSDKPlatformTypeQQ:
//            {
//                
//                [appInfo SSDKSetupQQByAppId:@"101400348" appKey:@"cb69c5f6e1e55cfa6ddd52249054083d" authType:SSDKAuthTypeBoth];
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
