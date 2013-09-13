//
//  CTZBasicAnimation.m
//  GoShop
//
//  Created by iwinad2 on 13-8-21.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "CTZBasicAnimation.h"

@implementation CTZBasicAnimation

+(id)animationWithKeyPath:(NSString *)path{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:path];
    animation.delegate=self;
    return animation;
}
@end
