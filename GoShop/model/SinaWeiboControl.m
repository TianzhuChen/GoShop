//
//  WeiboControl.m
//  GoShop
//
//  Created by iwinad2 on 13-8-22.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "SinaWeiboControl.h"
#import <objc/runtime.h>

#define keySinaAccessToken @"access_token"
#define keySinaUserUID @"uid"
#define keySinaUserExpireTime @"expireTime"

NSDictionary *userOAuthorInfo;
NSDictionary *userInfo;
@implementation SinaWeiboControl
@synthesize requestQueue,friendsWeibos,userHavedLogin;
-(id)init
{
    self=[super init];
    if(self)
    {
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:sina_weibo_appKEY];
        
        self.friendsWeibos=[[NSMutableArray alloc] init];
    }
    return self;
}
#pragma mark 登录、检查用户是否已经登录、获取用户信息、清除用户信息
-(void)login
{
    if([self checkUserHavedLogin])
    {
        [self updateUserInfo];
        if([self.delegate respondsToSelector:@selector(loginSuccess)])
        {
            [self.delegate loginSuccess];
        }
    }else
    {
        //
        WBAuthorizeRequest *authorizeRequest=[WBAuthorizeRequest request];
        authorizeRequest.redirectURI=sina_weibo_redirectURI;
        authorizeRequest.userInfo=@{@"SSO_from":@"sendmessage"};
        [WeiboSDK sendRequest:authorizeRequest];
    }

}
-(BOOL)checkUserHavedLogin
{
    userOAuthorInfo=[[NSUserDefaults standardUserDefaults] objectForKey:keySinaUserOAuthInfo];
    NSLog(@"userOAuthorInfo>>%@",userOAuthorInfo);
    if(userOAuthorInfo)
    {
        userHavedLogin=YES;
    }else
    {
        userHavedLogin=NO;
    }
    return userHavedLogin;
}
-(void)updateUserInfo
{
    if(userHavedLogin)
    {
        NSString *str;
        NSDictionary *dic=@{keySinaAccessToken:[userOAuthorInfo objectForKey:keySinaAccessToken],
                            keySinaUserUID:[userOAuthorInfo objectForKey:keySinaUserUID]};
        str=[RequestHelp getRequestWithData:dic baseUrl:@"https://api.weibo.com/2/users/show.json"];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
        [NSURLConnection sendAsynchronousRequest:request queue:requestQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        }];
    }
}
-(void)clearUserInfo
{
    
}
#pragma mark 获取用户关注用户最新微博
long long int since_i=0;//比since_id时间晚的微博），默认为0
-(NSURLRequest *)getRequestWithWeiboFriends
{
    NSString *str;
    NSDictionary *dic=@{keySinaAccessToken:[userOAuthorInfo objectForKey:keySinaAccessToken],
                        keySinaUserUID:[userOAuthorInfo objectForKey:keySinaUserUID],
                        @"since_i":[NSString stringWithFormat:@"%lld",since_i]};
    str=[RequestHelp getRequestWithData:dic baseUrl:@"https://api.weibo.com/2/statuses/friends_timeline.json"];

    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    return request;
}

#pragma mark WeiboSDKDelegate
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"rerequestspons>>>%@",request.userInfo);
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"respons>>>%@",response.userInfo);
    if([response isKindOfClass:WBAuthorizeResponse.class])//登录成功
    {
//        NSString *title = @"认证结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
//                             response.statusCode, [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
//       [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
        
        if(response.statusCode==WeiboSDKResponseStatusCodeSuccess)
        {
            WBAuthorizeResponse *tempResponse=(WBAuthorizeResponse *)response;
            
            userOAuthorInfo=@{keySinaAccessToken: tempResponse.accessToken,
                              keySinaUserExpireTime:tempResponse.expirationDate,
                              keySinaUserUID:tempResponse.userID};
            [[NSUserDefaults standardUserDefaults] setObject:userOAuthorInfo forKey:keySinaUserOAuthInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            userHavedLogin=YES;
            
            [self updateUserInfo];
            
            if([self.delegate respondsToSelector:@selector(loginSuccess)])
            {
                [self.delegate loginSuccess];
            }
        }
    }else
    {
        NSLog(@"用户信息返回结果>>>%@",response.userInfo);
    }
}

@end
