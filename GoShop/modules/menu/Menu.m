//
//  Menu.m
//  GoShop
//
//  Created by iwinad2 on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "Menu.h"
#import "AppDelegate.h"

@interface Menu(){
    CGPoint beganPoint;
    NSTimeInterval beganTimeInterval;
    //可触发显示位置
    CGRect beganRect;
    //夹角范围触发
    CGFloat minAngle;
    CGFloat maxAngle;
    
    BOOL isInBeganRect;
    UIWindow *window;
}

@end

@implementation Menu
-(id)initMenuWithDelegate:(id<MenuViewDelegate>)delegate{
    self=[super init];
    if(self){
       
        window=[UIApplication sharedApplication].keyWindow;
        //触发显示菜单
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(panWindow:)];
        pan.delegate=self;
        [window addGestureRecognizer:pan];
        
        
        beganRect=LIMIT_CGRECT;//CGRectMake(CGRectGetWidth(window.frame)-35, CGRectGetHeight(window.frame)-35, 35, 35);
        
        minAngle=M_PI_2*0.2;
        maxAngle=M_PI_2*0.8;
        
        CGRect menuFrame=window.frame;
        menuFrame.origin.y=[UIApplication sharedApplication].statusBarFrame.size.height;
        menuFrame.size.height-=[UIApplication sharedApplication].statusBarFrame.size.height;
        _menuView=[[MenuView alloc] initWithFrame:menuFrame];
        _menuView.delegate=delegate;
        
        UIView *v=[[UIView alloc] initWithFrame:beganRect];
        v.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.01];
        [window insertSubview:v atIndex:100];
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//   
//    CGPoint point=[gestureRecognizer locationInView:window];
//    if(CGRectContainsPoint(beganRect, point)){
//        return NO;
//    }else{
//        return YES;
//    }
    return YES;
}
//避免冲突,只在首先满足条件时才触发
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@"frame>>%@|||%@",NSStringFromCGRect(beganRect),NSStringFromCGPoint(point));
    CGPoint point=[gestureRecognizer locationInView:window];
    if(CGRectContainsPoint(beganRect, point) && !_menuView.isShowing){
        return YES;
    }else{
        return NO;
    }
}
-(void)show{
    [_menuView showMenu:0];
    [window bringSubviewToFront:_menuView];
}
#pragma mark -
#pragma mark window pan gesture 触发
-(void)panWindow:(UIPanGestureRecognizer *)pan{
    if(_menuView.isShowing){
        return;
    }
    CGPoint point=[pan locationInView:window];
//    NSLog(@"frame>>%@|||%@",NSStringFromCGRect(beganRect),NSStringFromCGPoint(point));
    if(pan.state==UIGestureRecognizerStateBegan){
//        NSLog(@"rect>>%@|||point>>%@",NSStringFromCGRect(beganRect),NSStringFromCGPoint(point));
        if(CGRectContainsPoint(beganRect, point)){
            isInBeganRect=YES;
            [self panBegan:point];
        }else{
            isInBeganRect=NO;
        }
    }else if(pan.state==UIGestureRecognizerStateChanged){
        if(isInBeganRect){
            [self panChagned:point];
        }
    }else if(pan.state==UIGestureRecognizerStateEnded){
        if(isInBeganRect){
            [self panEnded:point];
        }
    }
    
}
-(void)panBegan:(CGPoint)point{
    beganPoint=point;
    beganTimeInterval=[NSDate timeIntervalSinceReferenceDate];
}
-(void)panChagned:(CGPoint)point{
    
}
-(void)panEnded:(CGPoint)point{
    if(CGRectContainsPoint(beganRect, point)){
        return;
    }
    CGFloat x=beganPoint.x-point.x;
    CGFloat y=beganPoint.y-point.y;
    CGFloat angle=atan2f(y, x);
//    CGFloat timeOften=[NSDate timeIntervalSinceReferenceDate]-beganTimeInterval;
    CGFloat length=sqrtf((beganPoint.x-point.x)*(beganPoint.x-point.x)+(beganPoint.y-point.y)*(beganPoint.y-point.y));
    if(angle>minAngle && angle<maxAngle && length<100 && length>40){
        [self show];
    }
}
@end
