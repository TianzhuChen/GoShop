//
//  CTZBasicAnimation.h
//  GoShop
//
//  Created by iwinad2 on 13-8-21.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void (^completeBlock)(int tag);
@interface CTZBasicAnimation : NSObject
@property (nonatomic) NSInteger tag;
@end
