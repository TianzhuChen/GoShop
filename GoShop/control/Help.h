//
//  Help.h
//  GoShop
//
//  Created by Tianzhu on 13-6-15.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define angleToRadian(angle) (M_PI/180)*(angle)

@interface Help : NSObject

+(Help *)sharedInstance;

@property (nonatomic) int screenWidth;
@property (nonatomic) int screenHeight;

+(NSString *)formatSecondsToTime:(float)seconds;
+(CGFloat)getContentHeightWithFont:(UIFont *)font;
@end
