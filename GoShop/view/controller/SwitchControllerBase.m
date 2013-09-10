//
//  SwitchBaseController.m
//  TestPageChange
//
//  Created by iwinad2 on 13-5-30.
//  Copyright (c) 2013年 iwinad. All rights reserved.
//

#import "SwitchControllerBase.h"
#import "AppDelegate.h"

#define RIGHT_EDAGE 320
#define BOTTOM_EDAGE 640
#define VIEW_MIN_SCALE 0.95
#define FAST_TAP 300
 
@interface SwitchControllerBase(){
    UIPanGestureRecognizer *panGesture;
    //限制范围(避免和右下角的菜单手势冲突)
    CGRect limitRect;
    
    int maxHorEdage;
    int minHorEdage;
    int maxVerEdage;
    int minVerEdage;
    
    CGPoint beganPoint;
    CGPoint movePoint;
    CGPoint previousPoint;
    //按下时的时间戳
    NSTimeInterval beganTimeInterval;
    //已经初始化方向判断
    BOOL isInitDirectionJudage;
    //达到快速轻抚
    BOOL isFastTap;
    //可移动状态
    BOOL isMove;
    
    //是横向移动
    BOOL isLandscapeMove;
    //横向移动，是否是向左移动
    BOOL isToLeft;
    //纵向移动，是否是向上移动
    BOOL isToUp;
    //当前切换信息
    SwitchMoveInfo moveInfo;
    //黑色遮罩层
    UIView *blackLayer;
    
    //
//    CGFloat widthScale;
//    CGFloat heightScale;
}

@end

@implementation SwitchControllerBase
@synthesize window;
@synthesize switchDelegate;
@synthesize isSupportVerticalMove,isSupportHorizontalMove;
@synthesize horizontalNextController,horizontalPreviousController,verticalNextController,verticalPreviousController;
@synthesize defaultFrameOfNextHor,defaultFrameOfNextVer,defaultFrameOfPreviousHor,defaultFrameOfPreviousVer,defaultFrame;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initProperty];
    panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(panView:)];
    panGesture.delegate=self;
    panGesture.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:panGesture];
    self.switchDelegate=self;
    
    
}
-(void)viewDidUnload{
    
    [super viewDidUnload];
    [self.view removeGestureRecognizer:panGesture];
}

-(void)initProperty{
    window=[[UIApplication sharedApplication].windows lastObject];
    limitRect=LIMIT_CGRECT;//CGRectMake(CGRectGetWidth(window.frame)-35, CGRectGetHeight(window.frame)-35, 35, 35);
    
    self.isSupportHorizontalMove=YES;
    self.isSupportVerticalMove=NO;
    
    maxHorEdage=320;
    minHorEdage=0;
    maxVerEdage=window.frame.size.height;
    minVerEdage=20;
    
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    
    defaultFrame=rect;//self.view.frame;
    
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        defaultFrame.origin.y=0;
    }else{
        defaultFrame.origin.y=20;
    }
    
    
    CGRect tempFrame=rect;
    if([UIApplication sharedApplication].isStatusBarHidden){
        tempFrame.origin.x=RIGHT_EDAGE;
        tempFrame.origin.y=0;
        defaultFrameOfNextHor=tempFrame;
    }else{
        tempFrame.origin.x=RIGHT_EDAGE;
        tempFrame.origin.y=20;
        defaultFrameOfNextHor=tempFrame;
    }
    
    tempFrame=rect;
    if([UIApplication sharedApplication].isStatusBarHidden){
        tempFrame.origin.x=0;
        tempFrame.origin.y=0;
        defaultFrameOfPreviousHor=tempFrame;
    }else{
        tempFrame.origin.x=0;
        tempFrame.origin.y=20;
        defaultFrameOfPreviousHor=tempFrame;
    }
    
    tempFrame.origin.y=CGRectGetHeight(tempFrame)+20;
    defaultFrameOfNextVer=tempFrame;
    
    tempFrame.origin.y=-CGRectGetHeight(tempFrame)+20;
    defaultFrameOfPreviousVer=tempFrame;
    
    blackLayer=[[UIView alloc] initWithFrame:defaultFrame];
    blackLayer.backgroundColor=[UIColor blackColor];
    
}
//允许手势并存,子试图的响应优先于父视图的
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    CGPoint point=[otherGestureRecognizer locationInView:window];
//    if([otherGestureRecognizer])
    return YES;
}
//是否允许手势
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point=[gestureRecognizer locationInView:window];
    if(CGRectContainsPoint(limitRect, point)){
        return NO;
    }else{
        return YES;
    }
}
-(void)panView:(UIPanGestureRecognizer *)pan{
//    NSLog(@"switchPan");
    CGPoint point=[pan locationInView:window];
    if(pan.state==UIGestureRecognizerStateBegan){
//        CGPoint p=[pan translationInView:window];
//        NSLog(@"point>>>%@",NSStringFromCGPoint(p));
        [self panBegan:point];
    }else if(pan.state==UIGestureRecognizerStateChanged){
        [self panChanged:point];
    }else if(pan.state==UIGestureRecognizerStateEnded){
        [self panEnded:point];
    }
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
-(void)panBegan:(CGPoint)point{
//    UITouch *touch=[touches anyObject];
    beganPoint=point;//[touch locationInView:window];
    beganTimeInterval=[NSDate timeIntervalSinceReferenceDate];
    
    moveInfo.beganPoint=beganPoint;
    moveInfo.beganTimeInterval=beganTimeInterval;
    moveInitNumbers=0;
}
static int moveInitNumbers=0;
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
-(void)panChanged:(CGPoint)point{
    if(moveInitNumbers<4){
        moveInitNumbers++;
        return;
    }
//    UITouch *touch=[touches anyObject];
    if(!isInitDirectionJudage){//第一次判断
        movePoint=point;//[touch locationInView:window];
        previousPoint=movePoint;
        if(fabsf(beganPoint.x-movePoint.x)>fabsf(beganPoint.y-movePoint.y)){//横向移动
            isLandscapeMove=YES;
            moveInfo.direction=HORIZONTAL;
            if(beganPoint.x>movePoint.x){//判断第一次横向移动方向
                isToLeft=YES;
            }else{
                isToLeft=NO;
            }
        }else{//垂直移动
            isLandscapeMove=NO;
            moveInfo.direction=VERTICAL;
            if(beganPoint.y>movePoint.y){
                isToUp=YES;
            }else{
                isToUp=NO;
            }
        }
        moveInfo.currentPoint=movePoint;
        if(isLandscapeMove){//如果是横向移动
            if(isSupportHorizontalMove){//如果支持横向移动
                [self judageCanHorMove];
            }else{
                isMove=NO;
            }
        }else{//如果是垂直移动
            if(isSupportVerticalMove){
                [self judageCanVerMove];
            }else{
                isMove=NO;
            }
        }
        isInitDirectionJudage=YES;
    }
    
    if(isMove){
        movePoint=point;//[touch locationInView:window];
        if(isLandscapeMove){
            [self horizontalMoveViewWithStep:(previousPoint.x-movePoint.x)];
        }else{
            [self verticalMoveViewWithStep:(previousPoint.y-movePoint.y)];
        }
        previousPoint=movePoint;
    }
}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
-(void)panEnded:(CGPoint)point{
    if(isMove){
//        UITouch *touch=[touches anyObject];
        CGPoint endPoint=point;//[touch locationInView:window];
        moveInfo.currentPoint=endPoint;
        
//        NSLog(@"timeStar>>>%f",fabsf(beganPoint.x-endPoint.x)/([NSDate timeIntervalSinceReferenceDate]-beganTimeInterval));
        
        if(isLandscapeMove){
            if(fabsf(beganPoint.x-endPoint.x)/([NSDate timeIntervalSinceReferenceDate]-beganTimeInterval)>FAST_TAP){
                isFastTap=YES;
            }else{
                isFastTap=NO;
            }
            [self horizontalMoveViewEnd];
        }else{
            if(fabsf(beganPoint.y-endPoint.y)/([NSDate timeIntervalSinceReferenceDate]-beganTimeInterval)>FAST_TAP){
                isFastTap=YES;
            }else{
                isFastTap=NO;
            }
            [self verticalMoveViewEnd];
        }
    }
    isInitDirectionJudage=NO;    
    isMove=NO;
}
//横向移动判断
-(void)judageCanHorMove{
    if(isToLeft){//如果是向左滑动
        if(horizontalNextController){//如果下一个controller不为空
//            [window insertSubview:horizontalNextController.view aboveSubview:self.view];
//            [window insertSubview:blackLayer belowSubview:horizontalNextController.view];
            isMove=YES;
        }else{//没有nextController
            if([switchDelegate respondsToSelector:@selector(switchControllerOfNext:)]){//已经实现了获取方法
                horizontalNextController=[switchDelegate switchControllerOfNext:moveInfo];
                if(horizontalNextController){
                    horizontalNextController.view.frame=horizontalNextController.defaultFrameOfNextHor;
//                    [window insertSubview:horizontalNextController.view aboveSubview:self.view];
//                    [window insertSubview:blackLayer belowSubview:horizontalNextController.view];
                    isMove=YES;
                }else{
                    isMove=NO;
                }
            }else{//如果没有实现获取方法，直接挂掉
                isMove=NO;
                NSLog(@"nextController为nil，delegate必须实现，switchControllerOfNext是必须的 ");
//                NSAssert(NO, @"delegate必须实现，switchControllerOfNext是必须的 ");
            }
        }
        if(isMove){
            [window insertSubview:horizontalNextController.view aboveSubview:self.view];
            [window insertSubview:blackLayer belowSubview:horizontalNextController.view];
            if([switchDelegate respondsToSelector:@selector(switchNextStart:)]){
                [switchDelegate switchNextStart:moveInfo];
            }
        }
    }else{
        if(horizontalPreviousController){
            horizontalPreviousController.view.frame=self.view.frame;
//            [window insertSubview:horizontalPreviousController.view belowSubview:self.view];
//            [window insertSubview:blackLayer belowSubview:self.view];
            isMove=YES;
        }else{
            if([switchDelegate respondsToSelector:@selector(switchControllerOfPrevious:)]){
                horizontalPreviousController=[switchDelegate switchControllerOfPrevious:moveInfo];
                if(horizontalPreviousController){
                    horizontalPreviousController.view.frame=defaultFrameOfPreviousHor;
//                    [window insertSubview:horizontalPreviousController.view belowSubview:self.view];
//                    [window insertSubview:blackLayer belowSubview:self.view];
                    isMove=YES;
                }else{
                    isMove=NO;
                }
            }else{
                isMove=NO;
                NSLog(@"previousController为nil，delegate必须实现，switchControllerOfPrevious是必须的 ");
                //                    NSAssert(NO, @"delegate必须实现，switchControllerOfPrevious是必须的 ");
            }
        }
        if(isMove){
            [window insertSubview:horizontalPreviousController.view belowSubview:self.view];
            [window insertSubview:blackLayer belowSubview:self.view];
            if([switchDelegate respondsToSelector:@selector(switchPreviousStart:)]){
                [switchDelegate switchPreviousStart:moveInfo];
            }
        }
    }
}
//横向移动view
-(void)horizontalMoveViewWithStep:(CGFloat)stepX{
    if(isToLeft){
        CGRect vFrame=horizontalNextController.view.frame;
        vFrame.origin.x-=stepX;
        if(vFrame.origin.x>maxHorEdage){
            vFrame.origin.x=maxHorEdage;
        }
        if(vFrame.origin.x<minHorEdage){
            vFrame.origin.x=minHorEdage;
        }
        horizontalNextController.view.frame=vFrame;
        
        blackLayer.alpha=0.1+0.5-(vFrame.origin.x/640);
        float scale = (vFrame.origin.x/6400)+VIEW_MIN_SCALE;
        
        self.view.transform=CGAffineTransformMakeScale(scale, scale);
    }else{
        CGRect vFrame=self.view.frame;
        
        vFrame.origin.x-=stepX;
        if(vFrame.origin.x>maxHorEdage){
            vFrame.origin.x=maxHorEdage;
        }
        if(vFrame.origin.x<minHorEdage){
            vFrame.origin.x=minHorEdage;
        }
        self.view.frame=vFrame;
        
        blackLayer.alpha=0.5-(vFrame.origin.x/640);
        float scale = (vFrame.origin.x/6400)+VIEW_MIN_SCALE;
        horizontalPreviousController.view.transform=CGAffineTransformMakeScale(scale, scale);
    }
}
//横向移动结束
-(void)horizontalMoveViewEnd{
    if(isToLeft){
        if(horizontalNextController.view.frame.origin.x<maxHorEdage*0.8 || isFastTap){//显示新的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                horizontalNextController.view.frame=defaultFrame;
                self.view.transform=CGAffineTransformMakeScale(VIEW_MIN_SCALE,VIEW_MIN_SCALE);
                blackLayer.alpha=1;
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                if([switchDelegate respondsToSelector:@selector(switchNextCompleted:)]){
                    [switchDelegate switchNextCompleted:moveInfo];
                }
                self.view.transform=CGAffineTransformMakeScale(1,1);
                [self presentViewController:horizontalNextController animated:NO completion:^(void){
                    [self.view removeFromSuperview];
//                    [window insertSubview:horizontalNextController.view aboveSubview:blackLayer];
                }];
            }];
        }else{//取消显示新的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                horizontalNextController.view.frame=defaultFrameOfNextHor;
                self.view.transform=CGAffineTransformMakeScale(1, 1);
                blackLayer.alpha=0;
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                if([switchDelegate respondsToSelector:@selector(switchNextCancelled:)]){
                    [switchDelegate switchNextCancelled:moveInfo];
                }
            }];
        }
    }else{
        if(self.view.frame.origin.x>maxHorEdage*0.2 || isFastTap){//显示旧的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                self.view.frame=defaultFrameOfNextHor;
                blackLayer.alpha=0;
                horizontalPreviousController.view.transform=CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                if([switchDelegate respondsToSelector:@selector(switchPreviousCompleted:)]){
                    [switchDelegate switchPreviousCompleted:moveInfo];
                }
//                [self.navigationController popViewControllerAnimated:NO];
                [self dismissViewControllerAnimated:NO completion:^(void){
                    [self.view removeFromSuperview];
                }];
            }];
        }else{//取消显示旧的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                self.view.frame=defaultFrame;
                blackLayer.alpha=0.8;
                horizontalPreviousController.view.transform=CGAffineTransformMakeScale(VIEW_MIN_SCALE,VIEW_MIN_SCALE);
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                horizontalPreviousController.view.transform=CGAffineTransformMakeScale(1,1);
                if([switchDelegate respondsToSelector:@selector(switchPreviousCancelled:)])
                {
                    [switchDelegate switchPreviousCancelled:moveInfo];
                }
                
            }];
        }
    }
}
//垂直移动判断
-(void)judageCanVerMove{
    if(isToUp){
        if(verticalNextController)
        {//如果下一个controller已经存在
//            [window insertSubview:verticalNextController.view aboveSubview:self.view];
//            [window insertSubview:blackLayer belowSubview:verticalNextController.view];
            isMove=YES;
        }else
        {
            if([switchDelegate respondsToSelector:@selector(switchControllerOfNext:)])//调用生成方法
            {
                verticalNextController=[switchDelegate switchControllerOfNext:moveInfo];
                if(verticalNextController)
                {
                    verticalNextController.view.frame=defaultFrameOfNextVer;
//                    [window insertSubview:verticalNextController.view aboveSubview:self.view];
//                    [window insertSubview:blackLayer belowSubview:verticalNextController.view];
                    isMove=YES;
                }else
                {
                    isMove=NO;
                }
            }else
            {//没有实现生成方法
                isMove=NO;
                NSLog(@"nextControllerVer 为nil");
            }
        }
        if(isMove){
            [window insertSubview:verticalNextController.view aboveSubview:self.view];
            [window insertSubview:blackLayer belowSubview:verticalNextController.view];
            if([switchDelegate respondsToSelector:@selector(switchNextStart:)]){
                [switchDelegate switchNextStart:moveInfo];
            }
        }
    }else{
        if(verticalPreviousController)
        {
//            [window insertSubview:verticalPreviousController.view belowSubview:self.view];
//            [window insertSubview:blackLayer belowSubview:self.view];
            isMove=YES;
        }else
        {
            if([switchDelegate respondsToSelector:@selector(switchControllerOfPrevious:)])
            {
                verticalPreviousController=[switchDelegate switchControllerOfPrevious:moveInfo];
                if(verticalPreviousController)
                {
                    verticalPreviousController.view.frame=defaultFrameOfPreviousVer;
//                    [window insertSubview:verticalPreviousController.view belowSubview:self.view];
//                    [window insertSubview:blackLayer belowSubview:self.view];
                    isMove=YES;
                }else
                {
                    isMove=NO;
                }
            }else
            {
                isMove=NO;
                NSLog(@"verticalPreviousController 为nil");
            }
        }
        if(isMove){
            [window insertSubview:verticalPreviousController.view belowSubview:self.view];
            [window insertSubview:blackLayer belowSubview:self.view];
            if([switchDelegate respondsToSelector:@selector(switchPreviousStart:)]){
                [switchDelegate switchPreviousStart:moveInfo];
            }
        }
    }
}
//垂直移动
-(void)verticalMoveViewWithStep:(CGFloat)stepY{
    if(isToUp){
        CGRect vFrame=verticalNextController.view.frame;
        vFrame.origin.y-=stepY;
        if(vFrame.origin.y>maxVerEdage){
            vFrame.origin.y=maxVerEdage;
        }
        if(vFrame.origin.y<minVerEdage){
            vFrame.origin.y=minVerEdage;
        }
        verticalNextController.view.frame=vFrame;
        
        blackLayer.alpha=1-(vFrame.origin.y/546);
        float scale = (vFrame.origin.y/10960)+VIEW_MIN_SCALE;
        self.view.transform=CGAffineTransformMakeScale(scale, scale);
    }else{
        CGRect vFrame=self.view.frame;
        vFrame.origin.y-=stepY;
        if(vFrame.origin.y>maxVerEdage){
            vFrame.origin.y=maxVerEdage;
        }
        if(vFrame.origin.y<minVerEdage){
            vFrame.origin.y=minVerEdage;
        }
        self.view.frame=vFrame;
        blackLayer.alpha=0.5-(vFrame.origin.y/1096);
        float scale = (vFrame.origin.y/10960)+VIEW_MIN_SCALE;
        verticalPreviousController.view.transform=CGAffineTransformMakeScale(scale, scale);
    }
}
//垂直移动结束
-(void)verticalMoveViewEnd{
    if(isToUp){
        if(verticalNextController.view.frame.origin.y<(maxVerEdage*0.8) || isFastTap){//显示新的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                verticalNextController.view.frame=defaultFrame;
                //                self.view.frame=defaultFrameOfPreviousHor;
                blackLayer.alpha=1;
                self.view.transform=CGAffineTransformMakeScale(VIEW_MIN_SCALE,VIEW_MIN_SCALE);
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                if([switchDelegate respondsToSelector:@selector(switchNextCompleted:)]){
                    [switchDelegate switchNextCompleted:moveInfo];
                }
                [self presentViewController:verticalNextController animated:NO completion:^(void){
                    [self.view removeFromSuperview];
                }];
//                [self.navigationController pushViewController:verticalNextController animated:NO];
            }];
        }else{//取消显示新的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                verticalNextController.view.frame=defaultFrameOfNextVer;
                //                self.view.frame=defaultFrame;
                blackLayer.alpha=0;
                self.view.transform=CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                if([switchDelegate respondsToSelector:@selector(switchNextCancelled:)]){
                    [switchDelegate switchNextCancelled:moveInfo];
                }
            }];
        }
    }else{
        if(self.view.frame.origin.y>(maxVerEdage*0.2) || isFastTap){//显示旧的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                self.view.frame=defaultFrameOfNextVer;
                verticalPreviousController.view.transform=CGAffineTransformMakeScale(1, 1);
                blackLayer.alpha=0;
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                if([switchDelegate respondsToSelector:@selector(switchPreviousCompleted:)]){
                    [switchDelegate switchPreviousCompleted:moveInfo];
                }
                [self dismissViewControllerAnimated:NO completion:^(void){
                    [self.view removeFromSuperview];
                }];
//                [self.navigationController popViewControllerAnimated:NO];
            }];
        }else{//取消显示旧的controller
            [UIView animateWithDuration:0.5 animations:^(void){
                self.view.frame=defaultFrame;
                //                previousController.view.frame=defaultFrameOfPreviousHor;
                blackLayer.alpha=1;
                verticalPreviousController.view.transform=CGAffineTransformMakeScale(VIEW_MIN_SCALE,VIEW_MIN_SCALE);
            } completion:^(BOOL finished){
                [blackLayer removeFromSuperview];
                if([switchDelegate respondsToSelector:@selector(switchPreviousCancelled:)])
                {
                    [switchDelegate switchPreviousCancelled:moveInfo];
                }
                
            }];
        }
    }
}

-(void)pushController:(SwitchControllerBase *)controller direction:(SwitchDirection)direction{
    if(direction==HORIZONTAL){
//        controller.horizontalPreviousController=self;
        controller.view.frame=controller.defaultFrameOfNextHor;
//        [window insertSubview:controller.view aboveSubview:self.view];
        [window addSubviewBelowMenu:controller.view];
        [window insertSubview:blackLayer belowSubview:controller.view];
        
        blackLayer.alpha=0.1;
        [UIView animateWithDuration:0.6 animations:^(void){
            controller.view.frame=controller.defaultFrame;
            self.view.transform=CGAffineTransformMakeScale(0.9,0.9);
            blackLayer.alpha=1;
        } completion:^(BOOL finished){
            [blackLayer removeFromSuperview];
//            if([switchDelegate respondsToSelector:@selector(switchNextCompleted:)]){
//                [switchDelegate switchNextCompleted:moveInfo];
//            }
            self.view.transform=CGAffineTransformMakeScale(1,1);
//            NSLog(@"self>>>>%@",self);
            [self.view removeFromSuperview];
//            [self presentViewController:controller animated:NO completion:^(void){
//                [self.view removeFromSuperview];
//               // [window insertSubview:controller.view aboveSubview:blackLayer];
//            }];
        }];
    }
}
-(void)popController:(SwitchControllerBase *)controller direction:(SwitchDirection)direction{
    
}

@end
