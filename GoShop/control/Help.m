//
//  Help.m
//  GoShop
//
//  Created by Tianzhu on 13-6-15.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "Help.h"

@implementation Help

static Help *instance;

-(id)init{
    self=[super init];
    if(self){
        self.screenWidth=[UIScreen mainScreen].bounds.size.width;
        self.screenHeight=[UIScreen mainScreen].bounds.size.height;
    }
    return self;
}

+(Help *)sharedInstance{
    if(!instance){
        instance=[[Help alloc] init];
    }
    return instance;
}

+(NSString *)formatSecondsToTime:(float)seconds{
    
    int minutes=floor(seconds/60);
    int tempSeconds=floor((int)(seconds)%60);
    if(minutes<10 && tempSeconds<10)
    {
        return [NSString stringWithFormat:@"0%d:0%d",minutes,tempSeconds];
    }else if (minutes<10)
    {
        return [NSString stringWithFormat:@"0%d:%d",minutes,tempSeconds];
    }else if(tempSeconds<10)
    {
        return [NSString stringWithFormat:@"%d:0%d",minutes,tempSeconds];
    }
    return [NSString stringWithFormat:@"%d:%d",minutes,tempSeconds];
}

@end
