//
//  SwitchPageControllerViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-9-13.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "SwitchPageController.h"

static CGRect switchRect;
static CGFloat verScaleStep;
static CGFloat horScaleStep;
//动画参数
static CGFloat minScale;
//static NSUInteger *switchPanGestureChangedTimes;
@interface SwitchPageController (){
    SwitchMoveInfo switchMoveInfo;
    UIWindow *window;
    //初始化方向判断
    BOOL isInitDirectionJudage;
    //是否锁定页面切换（停止页面切换）一般会通过SwitchControllerDelegate的switchWillStart获得
    BOOL isLockMove;
    
    //移动时上面的controller
   __weak SwitchPageController *aboveController;
    //移动时下面的controller
   __weak SwitchPageController *followController;
    
    NSInteger aboveIndex;
    NSInteger middleIndex;
    NSInteger followIndex;
    
    CGRect aboveFrame;
    CGRect followFrame;
    
    
    
}

@end

@implementation SwitchPageController
@synthesize supportDirection,previousController,switchDelegate,nextController;

+(void)load
{
    switchRect=[UIScreen mainScreen].bounds;
    minScale=0.95;
    verScaleStep=CGRectGetHeight(switchRect)/(1-minScale);
    horScaleStep=CGRectGetWidth(switchRect)/(1-minScale);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    window=[UIApplication sharedApplication].keyWindow;
    if(supportDirection==kSupportNone)
    {
        UIPanGestureRecognizer *switchPanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(switchPanGesture:)];
        [self.view addGestureRecognizer:switchPanGesture];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark open function
+(void)setSwitchFrame:(CGRect)frame
{
    switchRect=frame;
//    verScaleStep=CGRectGetHeight(switchRect)/(1-minScale);
//    horScaleStep=CGRectGetWidth(switchRect)/(1-minScale);
}
//#pragma mark ******************
-(void)pushController:(SwitchPageController *)controller
{
    
}
-(void)backController
{
    
}
-(void)presentController:(SwitchPageController *)controller
{
    
}
#pragma mark -
#pragma mark UIPanGestureRecognizer
-(void)switchPanGesture:(UIPanGestureRecognizer *)panGesture
{
    if(panGesture.state==UIGestureRecognizerStateBegan)
    {
        [self gestureBegan:panGesture];
    }else if(panGesture.state==UIGestureRecognizerStateChanged)
    {
        [self gestureChanged:panGesture];
    }else if(panGesture.state==UIGestureRecognizerStateEnded)
    {
        [self gestureEnded:panGesture];
    }
}
-(void)gestureBegan:(UIPanGestureRecognizer *)panGesture
{
    switchMoveInfo.beganPoint=[panGesture locationInView:window];
    switchMoveInfo.currentPoint=switchMoveInfo.beganPoint;
    switchMoveInfo.beganTimeInterval=[NSDate timeIntervalSinceReferenceDate];
}
-(void)gestureChanged:(UIPanGestureRecognizer *)panGesture
{
    CGPoint p=[panGesture translationInView:window];
    if(!isInitDirectionJudage)//初始化方向判断
    {
        float xL=fabsf(p.x);
        float yL=fabsf(p.y);
        if(xL<2 && yL<2)
        {
            return;
        }
        if(xL>=yL)//如果距离大于2，开始判断方向,横向具有优先级
        {
            if(supportDirection==kSupportHorizontal)//如果只支持水平向
            {
                isInitDirectionJudage=YES;
                if(p.x>0)
                {
                    switchMoveInfo.direction=kMoveDirectionLeft;
                }else
                {
                    switchMoveInfo.direction=kMoveDirectionLeft;
                }
            }
        }else if(yL>xL)
        {
            if (supportDirection==kSupportVerticality)//如果只支持垂直方向
            {
                isInitDirectionJudage=YES;
                if(p.y>0)
                {
                    switchMoveInfo.direction=kMoveDirectionBottom;
                }else
                {
                    switchMoveInfo.direction=kMoveDirectionUp;
                }
            }
        }
        if (isInitDirectionJudage)
        {
            if([switchDelegate respondsToSelector:@selector(switchWillStart:)])//调用代理看是否能够开始移动
            {
                isLockMove=![switchDelegate switchWillStart:switchMoveInfo];
            }
            if (!isLockMove) {//能够移动
                [self startMoveView];
            }
        }
    }else if(!isLockMove)
    {
        [self moveViewTranslation:p];
    }
}
-(void)gestureEnded:(UIPanGestureRecognizer *)panGesture
{
    isInitDirectionJudage=NO;
    isLockMove=NO;
    [self endMoveView];
}
#pragma mark -
#pragma mark move uiview
-(void)startMoveView
{
    if([switchDelegate respondsToSelector:@selector(switchStart:)])
    {
        [switchDelegate switchStart:switchMoveInfo];
    }
    if(switchMoveInfo.direction==kMoveDirectionLeft || switchMoveInfo.direction==kMoveDirectionBottom)//用于创建新的试图
    {
        followController=self;
        followFrame=followController.view.frame;
        if (!nextController)//nextController已经存在，则不通过代理获取
        {
            if ([switchDelegate respondsToSelector:@selector(switchControllerOfNext:)])
            {
                nextController=[switchDelegate switchControllerOfNext:switchMoveInfo];
            }
        }
        aboveController=nextController;
        if (switchMoveInfo.direction==kMoveDirectionLeft)
        {
            aboveFrame=CGRectOffset(followFrame, CGRectGetWidth(switchRect), 0);
        }else
        {
            aboveFrame=CGRectOffset(followFrame, 0, CGRectGetHeight(switchRect));
        }
    }else//回到前一个试图
    {
        aboveController=self;
        aboveFrame=aboveController.view.frame;
        if(!previousController)
        {
            if([switchDelegate respondsToSelector:@selector(switchControllerOfPrevious:)])
            {
                previousController=[switchDelegate switchControllerOfPrevious:switchMoveInfo];
            }
        }
        followController=previousController;
        followFrame=aboveFrame;
        followController.view.transform=CGAffineTransformScale(followController.view.transform, minScale, minScale);
    }
    if(!(followController && aboveController))//却是controller无法实现切花界面
    {
        isLockMove=YES;
        NSLog(@"警告：找不到指定的controller，无法移动切换页面");
    }else
    {
        followController.view.frame=followFrame;
        aboveController.view.frame=aboveFrame;
        [window insertSubview:followController.view atIndex:followIndex];
        [window insertSubview:aboveController.view atIndex:aboveIndex];
    }
}
-(void)moveViewTranslation:(CGPoint)point
{
    CGRect _followFrame;
    CGRect _aboveFrame;
    _followFrame=followController.view.frame;
    _aboveFrame=aboveController.view.frame;
    if(switchMoveInfo.direction==kMoveDirectionLeft)//切换到新页面
    {
        _followFrame.origin.x+=point.x;
//        CGAffineTransform transform=aboveController.view.transform;
        followController.view.transform=CGAffineTransformScale(aboveController.view.transform, (fabsf(point.y)/320)*horScaleStep, 1.0);
    }else if (switchMoveInfo.direction==kMoveDirectionRight)//返回到就页面
    {
        _followFrame.origin.x+=point.x;
    }else if(switchMoveInfo.direction==kMoveDirectionUp)
    {
        
    }else if(switchMoveInfo.direction==kMoveDirectionBottom)
    {
        
    }
}
-(void)endMoveView
{
    if([switchDelegate respondsToSelector:@selector(switchCompleted:)])
    {
        [switchDelegate switchCompleted:switchMoveInfo];
    }
    
}
@end
