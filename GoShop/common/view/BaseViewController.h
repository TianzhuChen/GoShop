//
//  BaseViewController.h
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"
#import "Global.h"
#import "ViewControllerManager.h"



@interface BaseViewController : UIViewController
-(id)initWithClassName;
-(void)initController;
-(void)resetViewFrameByTitleview:(UIView *)view;
//-(void)setBarLeftItem:(UIImage *)image;
//-(void)leftButtonTap;
//
//-(void)setBarRightItem:(UIImage *)image;
//-(void)rightButtonTap;
@property (nonatomic,weak) UIView *titleView;
@property (nonatomic) int controllerTag;
@end
