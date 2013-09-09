//
//  SwitchBaseController.h
//  TestPageChange
//
//  Created by iwinad2 on 13-5-30.
//  Copyright (c) 2013年 iwinad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

typedef enum {
    HORIZONTAL,
    VERTICAL,
}SwitchDirection;

typedef struct{
    CGPoint beganPoint;
    CGPoint currentPoint;
    NSTimeInterval beganTimeInterval;
    SwitchDirection direction;
}SwitchMoveInfo;

@protocol SwitchControllerBaseDelegate;

@interface SwitchControllerBase : BaseViewController<SwitchControllerBaseDelegate,UIGestureRecognizerDelegate>{
//    UIWindow *window;
//    UIImage *lastPageScreenshot;
}
@property (nonatomic,weak) id<SwitchControllerBaseDelegate> switchDelegate;
@property (nonatomic,weak) UIView *window;
//是否支持水平方向
@property (nonatomic) BOOL isSupportHorizontalMove;
//是否支持垂直方向
@property (nonatomic) BOOL isSupportVerticalMove;

#pragma mark 默认frame
//水平方向，下一个view
@property (nonatomic) CGRect defaultFrameOfNextHor;
//水平方向，前一个view
@property (nonatomic) CGRect defaultFrameOfPreviousHor;
@property (nonatomic) CGRect defaultFrameOfNextVer;
@property (nonatomic) CGRect defaultFrameOfPreviousVer;
//当前viewFrame，切换成功以后的frame
@property (nonatomic) CGRect defaultFrame;
#pragma mark Controller引用
//水平下一个controller
@property (nonatomic,strong) SwitchControllerBase *horizontalNextController;
//水平前一个controller
@property (nonatomic,weak) SwitchControllerBase *horizontalPreviousController;
//垂直下一个controller
@property (nonatomic,strong) SwitchControllerBase *verticalNextController;
//垂直前一个controller
@property (nonatomic,weak) SwitchControllerBase *verticalPreviousController;

-(void)pushController:(SwitchControllerBase *)controller direction:(SwitchDirection)direction;
-(void)popController:(SwitchControllerBase *)controller direction:(SwitchDirection)direction;

@end

@protocol SwitchControllerBaseDelegate <NSObject>

@optional
//返回下一个controller
-(SwitchControllerBase *)switchControllerOfNext:(SwitchMoveInfo )moveInfo;
//返回旧的controller
-(SwitchControllerBase *)switchControllerOfPrevious:(SwitchMoveInfo )moveInfo;

-(void)switchNextStart:(SwitchMoveInfo )moveInfo;
-(void)switchNextCancelled:(SwitchMoveInfo )moveInfo;
-(void)switchNextCompleted:(SwitchMoveInfo )moveInfo;
-(void)switchPreviousCancelled:(SwitchMoveInfo )moveInfo;
-(void)switchPreviousCompleted:(SwitchMoveInfo )moveInfo;
-(void)switchPreviousStart:(SwitchMoveInfo )moveInfo;

@end
