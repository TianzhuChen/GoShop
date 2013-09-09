//
//  NewsControl.m
//  GoShop
//
//  Created by iwinad2 on 13-9-4.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "NewsControl.h"

@implementation NewsControl
@synthesize weiboData;
-(id)init
{
    self=[super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(accountSwitch)
                                                     name:AccountSwitchWillFinishedNotification
                                                   object:nil];
        if(!weiboData)
        {
            weiboData=[[NSMutableArray alloc] init];
        }
    }
    return self;
}
-(void)updateWeiboData
{
    if([AccountControl sharedAccount].isLogined)
    {
        NSURLRequest *request=[[AccountControl sharedAccount].weiboControl getRequestWithWeiboFriends];
        request=nil;
        if(request)
        {
            [NSURLConnection connectionWithRequest:request
                                          delegate:self];
        }else
        {
            NSData *data=[NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"]];
            [self connection:nil didReceiveData:data];
        }
        
    }
}

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
   NSLog(@"NewsControl  didReceiveResponse>>%@",[response allHeaderFields]);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(![[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"]]){
            [data writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] atomically:NO];
        }
        
        NSArray *arr=[[data objectFromJSONData] objectForKey:@"statuses"];
        NSMutableArray *tempData=[[NSMutableArray alloc] initWithCapacity:arr.count];
        for(NSDictionary *dic in arr)
        {
            NewsWeiboData *weibo=[[NewsWeiboData alloc] init];
            weibo.screenName=[[dic objectForKey:@"user"] valueForKey:@"screen_name"];
            weibo.createTime=[dic objectForKey:@"created_at"];
            weibo.profileImageUrl=[[dic objectForKey:@"user"] objectForKey:@"profile_image_url"];
            weibo.weiboContent=[dic objectForKey:@"text"];
            [weibo updateFrameRefCache];
            [tempData addObject:weibo];
        }
        if(tempData.count>0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addWeiboData:tempData];
            });
        }
        tempData=nil;
        arr=nil;
    });
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}
#pragma mark -
//更新微博数据
-(void)addWeiboData:(NSArray *)friendsWeibos_
{
    [self willChangeValueForKey:@"weiboData"];
    [self.weiboData addObjectsFromArray:friendsWeibos_];
    [self didChangeValueForKey:@"weiboData"];
}
+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if([key isEqualToString:@"weiboData"])
    {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}
#pragma mark -
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AccountSwitchWillFinishedNotification
                                                  object:nil];
}
-(void)didReceiveMemeory
{
    [weiboData enumerateObjectsUsingBlock:^(NewsWeiboData *obj, NSUInteger idx, BOOL *stop) {
        [obj clearFrameRefCache];
    }];
}
-(void)accountSwitch
{
}
@end
