//
//  Theme.h
//  GoShop
//
//  Created by ( on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Theme : NSObject
//根据标题,返回标题栏
+(UIView *)getTitleViewWithTitle:(NSString *)title withBackgroundColor:(UIColor *)color;
+(void)setStatusBarHidden:(BOOL)hide;
//设置状态栏背景
+(void)setStatusBarBackground;
//根据主题获取导航栏背景颜色
+(UIColor *)getNavigationBarBackgroundColor:(int)index;
//设置导航栏风格
+(void)styleNavigationBarWithFontName:(NSString*)navigationTitleFont andColor:(UIColor*)color;

+(UIColor *)getRandomColor;
+(UIColor *)getColorByRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;

+(UIImage *)getImageWithColor:(UIColor *)color
                         size:(CGSize)size;
//得到一个10*10的九宫格图片，insetset为2,2,2,2
+(UIImage *)getGridImageWithColor:(UIColor *)color
                           radius:(CGFloat)radius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor;
+(UIImage *)getCircleImageWithColor:(UIColor *)color
                           diameter:(float)diameter;
@end
