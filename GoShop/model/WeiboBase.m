//
//  WeiboBase.m
//  GoShop
//
//  Created by iwinad2 on 13-8-22.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "WeiboBase.h"

@implementation WeiboBase
@synthesize delegate,requestQueue,friendsWeibos;
-(void)login{};
-(void)clearUserInfo{};
-(void)getUserInfo{};
-(void)updateUserInfo{};
-(BOOL)checkUserHavedLogin{
    return NO;
};
@end
