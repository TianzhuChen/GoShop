//
//  RequestHelp.h
//  GoShop
//
//  Created by iwinad2 on 13-8-23.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHelp : NSObject
+(NSString *)getRequestWithData:(NSDictionary *)data baseUrl:(NSString *)baseUrl;
@end
