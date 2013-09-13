//
//  SwitchPageControllerViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-9-13.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "SwitchPageController.h"

static CGRect switchRect;
//static NSUInteger *switchPanGestureChangedTimes;
@interface SwitchPageController (){
    SwitchMoveInfo switchMoveInfo;
    UIWindow *window;
    //初始化方向判断
    BOOL isInitDirectionJudage;
}

@end

@implementation SwitchPageController
@synthesize supportDirection,previousController;

+(void)load
{
    switchRect=[UIScreen mainScreen].bounds;
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
    UIPanGestureRecognizer *switchPanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(switchPanGesture:)];
    [self.view addGestureRecognizer:switchPanGesture];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
+(void)setSwitchFrame:(CGRect)frame
{
    switchRect=frame;
}
#pragma mark ******************
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
    if(isInitDirectionJudage)
    {
        if(supportDirection==kSupportHorizontal)
        {
            if (fabsf(p.x)>2) {
                if(p.x>0)
                {
                    switchMoveInfo.direction=kMoveDirectionLeft;
                }else
                {
                    switchMoveInfo.direction=kMoveDirectionLeft;
                }
            }
        }else if (supportDirection==kSupportVerticality)
        {
            if (fabsf(p.y)>2) {
                if(p.y>0)
                {
                    switchMoveInfo.direction=kMoveDirectionBottom;
                }else
                {
                    switchMoveInfo.direction=kMoveDirectionUp;
                }
            }
        }else
        {
            
        }
    }
}
-(void)gestureEnded:(UIPanGestureRecognizer *)panGesture
{
    
}
@end
