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

@protocol SwitchControllerDelegate <NSObject>

@optional
//返回下一个controller
-(SwitchControllerBase *)switchControllerOfNext:(SwitchMoveInfo )moveInfo;
//返回旧的controller
-(SwitchControllerBase *)switchControllerOfPrevious:(SwitchMoveInfo )moveInfo;

-(BOOL)switchNextStart:(SwitchMoveInfo )moveInfo;
-(void)switchNextCancelled:(SwitchMoveInfo )moveInfo;
-(void)switchNextCompleted:(SwitchMoveInfo )moveInfo;
-(void)switchPreviousCancelled:(SwitchMoveInfo )moveInfo;
-(void)switchPreviousCompleted:(SwitchMoveInfo )moveInfo;
-(BOOL)switchPreviousStart:(SwitchMoveInfo )moveInfo;
@end
