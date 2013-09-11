//
//  ViewControllerManager.m
//  GoShop
//
//  Created by iwinad2 on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "ViewControllerManager.h"
#import "AppDelegate.h"
#import "AccountViewController.h"
#import "GoodViewController.h"
#import "NewsViewController.h"
#import "WeiboViewController.h"
#import "AudioViewController.h"

@interface ViewControllerManager(){
   __strong SwitchControllerBase *_currentController;
    NSMutableArray *controllers;
}



@end

@implementation ViewControllerManager


+(ViewControllerManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    static ViewControllerManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ViewControllerManager alloc] init];
    });
    return instance;
}
-(id)init{
    self=[super init];
    if(self){
        
    }
    return self;
}
#pragma mark MenuViewDelegate
-(void)selectedMenuItem:(MenuItem *)menuItem{
    if(menuItem.menuLevel!=1){
        return;
    }else{
        self.currentMenuItemIndex=menuItem.menuIndex;
    }
    SwitchControllerBase *controller;
    if(controllers){
        for(SwitchControllerBase *Tcontroller in controllers){
            if(Tcontroller.controllerTag==menuItem.menuIndex){
                controller=Tcontroller;
                break;
            }
        }
    }
    if(controller==nil){
        switch (menuItem.menuIndex) {
            case menuItemIndexNew:
                controller=[[NewsViewController alloc] initWithClassName];
                break;
            case menuItemIndexGoodNew:
                controller=[[AudioViewController alloc] initWithClassName];
//                controller=[[GoodViewController alloc] initWithClassName];
                break;
            case menuItemIndexAccount:
                controller=[[AccountViewController alloc] initWithClassName];
                break;
            case menuItemIndexShop:
                controller=[[WeiboViewController alloc] initWithClassName];
                break;
            default:
                break;
        }
        controller.controllerTag=menuItem.menuIndex;
        [self addControllerToCaches:controller];
    }
    
    controller.horizontalPreviousController=_currentController;
    [_currentController pushController:controller direction:HORIZONTAL];
    self.currentController=controller;
}

-(void)setCurrentController:(UIViewController *)currentController{
//    if([currentController isKindOfClass:[SwitchControllerBase class]]){
//        NSLog(@"currentController 必须为 SwitchControllerBase");
//    }else{
//        _currentController=(SwitchControllerBase *)currentController;
//    }
     _currentController=(SwitchControllerBase *)currentController;
}
-(id)checkCacheController:(Class)controllerClass{
//    __block BOOL haved=NO;
    __block UIViewController *Tcontroller;
    [controllers enumerateObjectsUsingBlock:^(SwitchControllerBase *obj, NSUInteger idx, BOOL *stop){
        if([obj isMemberOfClass:controllerClass]){
            Tcontroller=obj;
//            return obj;
        }
    }];
    return Tcontroller;
}
-(void)addControllerToCaches:(UIViewController *)controller{
    if(!controllers){
        controllers=[[NSMutableArray alloc] init];
    }else{
        if([controllers containsObject:controllers]){
            return;
        }
    }
    
    [controllers addObject:controller];
}
-(void)didReceiveMemoryWarning{
//    __block NSArray *Tarr;
//    [controllers enumerateObjectsUsingBlock:^(SwitchControllerBase *obj, NSUInteger idx, BOOL *stop){
//        if(obj.controllerTag==_currentController.controllerTag){
//            Tarr=[NSArray arrayWithObject:obj];
//        }
//    }];
    [controllers removeAllObjects];
    [controllers addObject:self.currentController];
    [controllers addObject:[AppDelegate getAppDelegate].window.rootViewController];
//    controllers=[NSMutableArray arrayWithArray:Tarr];
}
@end
