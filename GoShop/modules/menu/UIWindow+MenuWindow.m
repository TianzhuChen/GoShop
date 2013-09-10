//
//  UIWindow+MenuWindow.m
//  GoShop
//
//  Created by iwinad2 on 13-9-10.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "UIWindow+MenuWindow.h"

@implementation UIWindow (MenuWindow)
-(void)addSubviewBelowMenu:(UIView *)view
{
    if([AppDelegate getAppDelegate].menu.menuView.superview){
        [self insertSubview:view belowSubview:[AppDelegate getAppDelegate].menu.menuView];
    }else
    {
        [self addSubview:view];
    }
}
@end
