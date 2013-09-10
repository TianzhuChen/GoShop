//
//  MenuView.h
//  GoShop
//
//  Created by Tianzhu on 13-6-13.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"
#import <CoreImage/CoreImage.h>


@protocol MenuViewDelegate;

@interface MenuView : UIView<MenuItemDelegate,UIGestureRecognizerDelegate>

-(void)showMenu:(MenuItemEnum)menuIndex;
-(void)hideMenu;
-(MenuItem *)getCurrentSelectedMenuItem;

@property (nonatomic,weak) id<MenuViewDelegate> delegate;
//当前一级菜单
@property (nonatomic) MenuItemEnum currentFirstMenuItemIndex;
@property (nonatomic) BOOL isShowing;
@end

@protocol MenuViewDelegate <NSObject>
-(void)selectedMenuItem:(MenuItem *)menuItem;
@optional
-(void)menuViewAnimationCompleted;
-(void)menuViewAnimationStart;
@end
