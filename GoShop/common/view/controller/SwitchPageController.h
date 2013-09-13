//
//  SwitchPageControllerViewController.h
//  GoShop
//
//  Created by iwinad2 on 13-9-13.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchControllerDelegate.h"
typedef enum{
    kSupportHorizontal,
    kSupportVerticality,
    kSupportAll
}SupportDirection;
@interface SwitchPageController : UIViewController
//旧页面
@property (nonatomic,weak) SwitchPageController *previousController;
@property (nonatomic) SupportDirection supportDirection;

+(void)setSwitchFrame:(CGRect)frame;
//前往下一个页面
-(void)pushController:(SwitchPageController *)controller;
//返回到上一个页面
-(void)backController;
//返回到指定历史页面
-(void)presentController:(SwitchPageController *)controller;
@end
