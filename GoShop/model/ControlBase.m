//
//  ControlBase.m
//  GoShop
//
//  Created by iwinad2 on 13-8-26.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "ControlBase.h"

@implementation ControlBase
-(id)init
{
    self=[super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemeory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    
    return self;
}
-(void)didReceiveMemeory{};
-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
}
-(void)dealloc{
    [self deallocSelf];
}
-(void)deallocSelf{
    [self removeNotification];
};
@end
