//
//  API.h
//  ChatDemo
//
//  Created by ios on 17/5/15.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#ifndef API_h
#define API_h
#define FF_API_IP @"http://192.168.0.104:8080"

#define FF_USER_LOGIN FF_API_IP@"/TestWeb1/user/login?utoken=%@"            //用户登陆
#define FF_USER_REGIST FF_API_IP@"/TestWeb1/user/regist"                                    //新用户注册
#define FF_USER_SETINFO FF_API_IP@"/TestWeb1/user/setinfo?uid=%@"                                    //修改用户信息

//获取用户信息
#define FF_PRODUCT_UPTOKEN FF_API_IP@"/TestWeb1/product/uptoken"        //获取七牛上传token
#define FF_PRODUCT_UPLOAD FF_API_IP@"/TestWeb1/product/upload"        //上传用户作品
#define FF_PRODUCT_LIST FF_API_IP@"/TestWeb1/square/productlist?page=%d&limit=%d"            //获取广场所有用户作品列表

#define FF_USER_PRODUCT_LIST FF_API_IP@"/TestWeb1/user/productlist?page=%d&limit=%d&uid=%@"            //获取用户作品列表

#define FF_PRODUCT_GOOD FF_API_IP@"/TestWeb1/product/good"            //作品点赞
#define FF_PRODUCT_CANCEL_GOOD FF_API_IP@"/TestWeb1/product/cancel/good"            //作品取消点赞


#define FF_LIVE_CREATE FF_API_IP@"/TestWeb1/live/create"            //创建

#endif /* API_h */
