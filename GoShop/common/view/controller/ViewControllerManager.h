//
//  ViewControllerManager.h
//  GoShop
//
//  Created by iwinad2 on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuView.h"

@interface ViewControllerManager : NSObject<MenuViewDelegate>{
    
}
+(ViewControllerManager *)sharedInstance;
-(void)didReceiveMemoryWarning;
//根据指定的class检查缓存是否有，没有返回nil
-(id)checkCacheController:(Class)controllerClass;
//添加controller到缓存
-(void)addControllerToCaches:(UIViewController *)controller;

@property (nonatomic,strong) UIViewController *currentController;
@property (nonatomic) MenuItemEnum currentMenuItemIndex;
@end
