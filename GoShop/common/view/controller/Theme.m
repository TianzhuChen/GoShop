//
//  Theme.m
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "Theme.h"

@implementation Theme
static int themeIndex=0;
static int statusBarGap=3;

+(void)setStatusBarHidden:(BOOL)hide{
    if(hide){
        [[[UIApplication sharedApplication].keyWindow viewWithTag:100] removeFromSuperview];
    }else{
        [[self class] setStatusBarBackground];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:hide
                                            withAnimation:UIStatusBarAnimationSlide];
}
+(UIView *)getTitleViewWithTitle:(NSString *)title withBackgroundColor:(UIColor *)color{
    CGSize strSize=[title sizeWithFont:[UIFont systemFontOfSize:18]
                              constrainedToSize:CGSizeMake(320-5, 2000)
                         lineBreakMode:UILineBreakModeCharacterWrap];
    //标题文本框
    UILabel *label=[[UILabel alloc] init];
    if(strSize.height>44){
        strSize.height=44;
    }
    CGFloat width=strSize.width;
    width+=10;
    if(width>320){
        width=320;
    }
    label.frame=CGRectMake(0, 0, width, strSize.height);
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=title;
    label.backgroundColor=[UIColor clearColor];
    
    UIView *titleBg=[[UIView alloc] initWithFrame:CGRectMake(5, statusBarGap, width, strSize.height)];
    titleBg.backgroundColor=color;
    [titleBg addSubview:label];
    
    [titleBg addSubview:[Theme getStatusBarBackgroundImageWithBackgroundColor:color]];
    
    return titleBg;
}
+(UIImageView *)getStatusBarBackgroundImageWithBackgroundColor:(UIColor *)color{
    CGRect statusBgFrame=[UIApplication sharedApplication].statusBarFrame;
    
    statusBgFrame.size.height=statusBgFrame.size.height+statusBarGap;
    UIGraphicsBeginImageContext(statusBgFrame.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,statusBgFrame.size.width,statusBgFrame.size.height);
    CGContextSetFillColorWithColor(currentContext,color.CGColor); //[Theme getNavigationBarBackgroundColor:themeIndex].CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    statusBgFrame.origin.y=-statusBgFrame.size.height;
    statusBgFrame.origin.x=-5;
    UIImageView *barBg=[[UIImageView alloc] initWithFrame:statusBgFrame];
    barBg.image=image;
    barBg.tag=100;
    
    return barBg;
}
+(void)setStatusBarBackground{
    CGRect statusBgFrame=[UIApplication sharedApplication].statusBarFrame;
    
    statusBgFrame.size.height=statusBgFrame.size.height+statusBarGap;
    UIGraphicsBeginImageContext(statusBgFrame.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,statusBgFrame.size.width,statusBgFrame.size.height);
    CGContextSetFillColorWithColor(currentContext, [Theme getNavigationBarBackgroundColor:themeIndex].CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *barBg=[[UIImageView alloc] initWithFrame:statusBgFrame];
    barBg.image=image;
    barBg.tag=100;
    [[UIApplication sharedApplication].keyWindow addSubview:barBg];
//    [[[UIApplication sharedApplication].windows lastObject] addSubview:barBg];
}
+(UIColor *)getNavigationBarBackgroundColor:(int)index{
    themeIndex=index;
    if(themeIndex==0){
        return [UIColor colorWithRed:53.0/255 green:150.0/255 blue:225.0/255 alpha:1.0];
    }else{
       return [UIColor colorWithRed:150.0/255 green:223.0/255 blue:100.0/255 alpha:1.0];
    }
    
}
+(void)styleNavigationBarWithFontName:(NSString*)navigationTitleFont andColor:(UIColor*)color{
    ///设置状态栏背景
//    [Theme setStatusBarBackground];
    ////////End//////////
    
    CGSize size = CGSizeMake(320, 12);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    
    [navAppearance setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [navAppearance setFrame:CGRectMake(0, 0, 320, 30)];
    
    [navAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], UITextAttributeTextColor,
                                           [UIFont fontWithName:navigationTitleFont size:18.0f], UITextAttributeFont,
                                           nil]];
}
+(UIColor *)getRandomColor{
    return [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
}
+(UIColor *)getColorByRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0f green:blue/255.0f blue:blue/255.0f alpha:alpha];
}
#pragma mark 创建位图
+(UIImage *)getImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextFillPath(context);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(UIImage *)getCircleImageWithColor:(UIColor *)color diameter:(float)diameter
{
    UIGraphicsBeginImageContext(CGSizeMake(diameter, diameter));
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, diameter, diameter));
    CGContextFillPath(context);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+(UIImage *)getGridImageWithColor:(UIColor *)color
                           radius:(CGFloat)radius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
{
    CGSize size=CGSizeMake(10, 10);
    
    CALayer *tempLayer=[CALayer layer];
    tempLayer.frame=CGRectMake(0, 0, size.width, size.height);
    tempLayer.backgroundColor=color.CGColor;
    if(borderWidth)
    {
        tempLayer.borderWidth=borderWidth;
        tempLayer.borderColor=borderColor.CGColor;
    }
    tempLayer.cornerRadius=radius;
    tempLayer.masksToBounds=YES;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [tempLayer renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    
//    CGMutablePathRef path=CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, radius, 0);
//    CGPathAddLineToPoint(path, NULL, size.width-radius, 0);
//    CGPathAddArc(path, NULL, size.width-radius, radius,radius, M_PI_2, -M_PI_2,0 , NO);
//    CGPathAddLineToPoint(path, NULL, size.width, size.height-radius);
//    CGPathAddArc(path, NULL, size.width-radius, size.height-radius, radius,M_PI_2,0,M_PI_2 , NO);
//    CGPathAddLineToPoint(path, NULL, radius, size.height);
//    CGPathAddArc(path, NULL, radius, size.height-radius,radius, M_PI_2,M_PI_2,M_PI , NO);
//    CGPathAddLineToPoint(path, NULL, 0, radius);
//    CGPathAddArc(path, NULL, radius, radius,radius, M_PI_2,M_PI_2,M_PI*1.5 , NO);
}
@end
