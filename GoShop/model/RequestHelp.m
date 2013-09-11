//
//  RequestHelp.m
//  GoShop
//
//  Created by iwinad2 on 13-8-23.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "RequestHelp.h"

@implementation RequestHelp
+(NSString *)getRequestUrlWithParams:(NSDictionary *)data baseUrl:(NSString *)baseUrl
{
    NSMutableArray *paramsArr=[NSMutableArray arrayWithCapacity:data.count];
    for(NSString *key in [data keyEnumerator]){
        NSString *escaped_value=CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                    (CFStringRef)[data objectForKey:key],
                                                                                    NULL,
                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                    kCFStringEncodingUTF8));
        [paramsArr addObject:[NSString stringWithFormat:@"%@=%@",key,escaped_value]];
    }
    NSString *paramsUrl=[paramsArr componentsJoinedByString:@"&"];
    return [NSString stringWithFormat:@"%@?%@",baseUrl,paramsUrl];
}
@end
