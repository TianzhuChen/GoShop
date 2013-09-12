//
//  AppDelegate.h
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerManager.h"
#import "Menu.h"
#import "DataManager.h"
#import "APService.h"

@class NewsViewController;

@interface AppDelegate : UIResponder<UIApplicationDelegate>

+(AppDelegate *)getAppDelegate;

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) UIWindow *childWindow;

@property (strong,nonatomic) Menu *menu;

@property (strong,nonatomic) DataManager *dataManager;

@end
