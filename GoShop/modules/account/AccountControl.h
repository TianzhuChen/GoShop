//
//  AccountData.h
//  GoShop
//
//  Created by iwinad2 on 13-7-10.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountData.h"
#import "SinaWeiboControl.h"
#import "ControlBase.h"

//#define KEY_LASTLOGIN_ACCOUNT_TYPE @"lastLoginAccountType"
extern NSString *const AccountSwitchWillFinishedNotification;


typedef enum {
    kAccountTypeNone=0,
    kAccountTypeDefault=10,
    kAccountTypeSina,
    kAccountTypeTencent,
}Account_Type;

@interface AccountControl : ControlBase<WeiboAllDelegate>{
    NSString *_userName;
    NSString *_password;
    NSOperationQueue *weiboQueue;
}
@property (nonatomic) AccountData *data;

@property (nonatomic,readonly) BOOL isLogined;
@property (nonatomic,readonly) NSMutableSet *userLists;//登录使用过的用户名称
@property (nonatomic,readonly) WeiboBase *weiboControl;
@property (nonatomic,readonly) Account_Type accountType;

+(AccountControl *)sharedAccount;
-(void)loginWithName:(NSString *)name password:(NSString *)password;
-(void)loginWithAccountType:(Account_Type)type;
-(void)logOut;
-(void)clearUserData;
-(BOOL)checkIsLogin;
-(WeiboBase *)getCurrentLoginWeibo;
-(BOOL)handleUrl:(NSURL *)url;
@end
