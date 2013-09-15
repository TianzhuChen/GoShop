//
//  SwitchControllerDelegate.h
//  GoShop
//
//  Created by iwinad2 on 13-9-13.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    kMoveDirectionLeft,
    kMoveDirectionUp,
    kMoveDirectionBottom,
    kMoveDirectionRight
}SwitchDirection;

typedef struct{
    CGPoint beganPoint;
    CGPoint currentPoint;
    NSTimeInterval beganTimeInterval;
    SwitchDirection direction;
}SwitchMoveInfo;

@class SwitchControllerBase;
@class SwitchPageController;

@protocol SwitchControllerDelegate <NSObject>

@optional
//请更改为SwitchPageController
//返回下一个controller
-(id)switchControllerOfNext:(SwitchMoveInfo )moveInfo;
//返回旧的controller
-(id)switchControllerOfPrevious:(SwitchMoveInfo )moveInfo;

-(BOOL)switchNextStart:(SwitchMoveInfo )moveInfo;
-(void)switchNextCancelled:(SwitchMoveInfo )moveInfo;
-(void)switchNextCompleted:(SwitchMoveInfo )moveInfo;
-(void)switchPreviousCancelled:(SwitchMoveInfo )moveInfo;
-(void)switchPreviousCompleted:(SwitchMoveInfo )moveInfo;
-(BOOL)switchPreviousStart:(SwitchMoveInfo )moveInfo;
/*****新版接口*****/
//如果返回yes将会切换页面；如果返回no不会切换页面，终止后面的所有动作，默认Yes。
-(BOOL)switchWillStart:(SwitchMoveInfo)moveInfo;
-(void)switchStart:(SwitchMoveInfo)moveInfo;
-(void)switchCancel:(SwitchMoveInfo)moveInfo;
-(void)switchCompleted:(SwitchMoveInfo)moveInfo;
@end
