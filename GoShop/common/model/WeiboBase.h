//
//  WeiboBase.h
//  GoShop
//
//  Created by iwinad2 on 13-8-22.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboKey.h"
#import "RequestHelp.h"
#import "JSONKit.h"

#define KEY_user_image @"userImage"
#define KEY_user_name @"userName"

extern NSDictionary *userOAuthorInfo;//用户认证信息包括access_token，uid等
extern NSDictionary *userInfo;//用户个人信息

@protocol WeiboAllDelegate;
@interface WeiboBase : NSObject
-(void)login;
-(void)clearUserInfo;
-(void)updateUserInfo;
-(BOOL)checkUserHavedLogin;

-(NSURLRequest *)getRequestWithWeiboFriends;

@property (nonatomic) id<WeiboAllDelegate> delegate;
@property (nonatomic) NSMutableArray *friendsWeibos;
@property (nonatomic) NSOperationQueue *requestQueue;
@property (nonatomic) BOOL userHavedLogin;//是否已经登录
@property (nonatomic) int tag;
@end
@protocol WeiboAllDelegate <NSObject>
-(void)loginSuccess;
-(void)loginFailed;
-(void)updateWeiboDataSuccess;
@end
