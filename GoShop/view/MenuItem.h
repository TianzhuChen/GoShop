//
//  MenuItem.h
//  GoShop
//
//  Created by iwinad2 on 13-6-18.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Help.h"
#import "OBShapedButton.h"

@protocol MenuItemDelegate;
@class MenuItem;
//菜单索引枚举
typedef enum {
    menuItemIndexNew=0,
    menuItemIndexShop,
    menuItemIndexGoodNew,
    menuItemIndexAccount,
    
    menuItemIndexNewByTime=10,
    menuItemIndexNewByShop,
    menuItemIndexNewByRating,
    menuItemIndexNewByArea,
    
    menuItemIndexShopByArea=20,
    menuItemIndexShopByRating,
    menuItemIndexShopByName,
    
    menuItemIndexGoodNewByTime=30,
    menuItemIndexGoodNewByShop,
    menuItemIndexGoodNewByRating,
    menuItemIndexGoodNewByArea,
    
    menuItemIndexHome=100,
    
}MenuItemEnum;

//菜单动画参数
typedef struct{
    float duration;
    float startDelayTime;
}MenuItemAnimationParam;

//菜单层级
typedef enum {
    menuItemLevel_HOME=0,
    menuItemLevel_FIRST,
    menuItemLevel_SECOND,
}MenuItemLevel;

//使用块实现点击
typedef void (^MenuItemClick) (MenuItem *item);
@interface MenuItem : OBShapedButton

-(void)initItemDisplayWithScale:(CATransform3D)scale rotation:(CATransform3D)rotation;

-(void)show:(MenuItemAnimationParam)animationParam;
-(void)hide:(MenuItemAnimationParam)animationParam;
-(void)showChildItem:(MenuItemAnimationParam)animationParam;
-(void)hideChildItem:(MenuItemAnimationParam)animationParam;

-(MenuItem *)getMenuItemByIndex:(MenuItemEnum)itemIndex;

@property(nonatomic,weak) id<MenuItemDelegate> delegate;

@property(nonatomic,strong) NSArray *childrenItems;
@property(nonatomic,copy) MenuItemClick itemClick;
@property(nonatomic) CGPoint showPosition;
@property(nonatomic) CGPoint hidePosition;

@property(nonatomic) MenuItemLevel menuLevel;
@property(nonatomic) MenuItemEnum menuIndex;
@property(nonatomic) int childMenuIndex;
@property(nonatomic) int superMenuIndex;

//主题颜色
@property(nonatomic) UIColor *color;
//所占弧度
@property(nonatomic) CGFloat angle;
//半径
@property(nonatomic) CGFloat radius;

//最终显示旋转的角度
@property(nonatomic) CATransform3D displayRotationTransform;
//初始化时旋转的角度
@property(nonatomic,readonly) CATransform3D initRotationTransform;
//隐藏是旋转的角度
@property(nonatomic) CATransform3D hideRotationTransform;
//最终显示缩放
@property(nonatomic) CATransform3D displayScaleTransform;
//初始化时缩放
@property(nonatomic,readonly) CATransform3D initScaleTransform;
//隐藏时的缩放
@property(nonatomic) CATransform3D hideScaleTransform;
@end

@protocol MenuItemDelegate <NSObject>

@required
-(void)menuItemClick:(MenuItem *)item;
@optional
-(void)menuItemHideComplete;
-(void)menuItemShowCompete;
@end
