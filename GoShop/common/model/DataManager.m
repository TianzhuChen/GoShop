//
//  DataManager.m
//  GoShop
//
//  Created by iwinad2 on 13-8-22.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize accountControl;


+(id)sharedManager
{
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[DataManager alloc] init];
    });
    return instance;
}
-(id)init{
    self=[super init];
    if(self)
    {
        
    }
    return self;
}
-(void)initGlobalData
{
    accountControl=[AccountControl sharedAccount];
}
@end
