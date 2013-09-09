//
//  WeiboControl.h
//  GoShop
//
//  Created by iwinad2 on 13-8-22.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboBase.h"
#import "WeiboSDK.h"

#define keySinaUserOAuthInfo @"keySinaUserOAuthInfo"

@interface SinaWeiboControl : WeiboBase<WeiboSDKDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    
}


@end
