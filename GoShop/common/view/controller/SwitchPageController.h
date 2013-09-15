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
    kSupportAll,
    kSupportNone,
}SupportDirection;
@interface SwitchPageController : UIViewController
//旧页面,如果不为nil，不会触发代理去查找
@property (nonatomic,weak) SwitchPageController *previousController;
//新的页面,如果不为nil，不会触发代理去查找
@property (nonatomic,weak) SwitchPageController *nextController;
//支持的滑动方向，默认为支持所有
@property (nonatomic) SupportDirection supportDirection;
@property (nonatomic,weak) id<SwitchControllerDelegate> switchDelegate;

//设置页面切换后最终的显示位置
+(void)setSwitchFrame:(CGRect)frame;
//前往下一个页面
-(void)pushController:(SwitchPageController *)controller;
//返回到上一个页面
-(void)backController;
//返回到指定历史页面
-(void)presentController:(SwitchPageController *)controller;
@end
