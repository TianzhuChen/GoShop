//
//  MBBHelp.h
//  HuaweiMbb
//
//  Created by iwinad2 on 13-9-12.
//  Copyright (c) 2013年 Iwinad. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Reachability.h"

extern CGFloat ScreenWidth;
extern CGFloat ScrrenHeight;
extern CGFloat systemVersion;
@interface GoShopHelp : NSObject
//+(NetworkStatus)getNetworkStatus;
+ (BOOL) IsEnableWIFI;
+ (BOOL) IsEnable3G;
+ (BOOL) IsEnableNetwork;
@end
