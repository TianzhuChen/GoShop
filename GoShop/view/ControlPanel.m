//
//  AudioControlPanel.m
//  GoShop
//
//  Created by iwinad2 on 13-7-16.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "ControlPanel.h"
#import "Help.h"

#define PROGRESS_RADIUS 30
#define PROGRESS_STROKE_WIDTH 3
#define PAUSE_BUTTON_CENTER CGPointMake(40, 35)

@implementation ControlPanel
@synthesize audioPlay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pauseButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, (PROGRESS_RADIUS-PROGRESS_STROKE_WIDTH)*2, (PROGRESS_RADIUS-PROGRESS_STROKE_WIDTH)*2)];
        
        [pauseButton addTarget:self
                        action:@selector(togglePausePlay:)
              forControlEvents:UIControlEventTouchUpInside];
        [pauseButton setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:1]];
        [pauseButton setTitle:@"Play" forState:UIControlStateNormal];
        [pauseButton setTitle:@"Pause" forState:UIControlStateSelected];
        
        pauseButton.layer.masksToBounds=YES;
        pauseButton.layer.cornerRadius=pauseButton.frame.size.width/2;
        pauseButton.center=PAUSE_BUTTON_CENTER;
        [self addSubview:pauseButton];
        
        self.backgroundColor=[UIColor whiteColor];
        progress=0;
    }
    return self;
}
-(void)togglePausePlay:(UIButton *)sender{
    NSString *url=[[NSBundle mainBundle] pathForResource:@"青春" ofType:@"mp3"];
//    NSString *url=@"http://y1.eoews.com/assets/ringtones/2012/6/29/36195/mx8an3zgp2k4s5aywkr7wkqtqj0dh1vxcvii287a.mp3";
    if([audioPlay isStop])//如果当前是停止播放状态
    {
        [audioPlay playByUrl:url];
        pauseButton.selected=YES;
    }else
    {
        if(audioPlay.isPlaying)
        {
            [audioPlay pause];
            pauseButton.selected=NO;
        }else
        {
            [audioPlay resume];
            pauseButton.selected=YES;
        }
    }
    
}
-(void)updatePlayProgressView:(float)progress_
{
    progress=progress_;
    if(progress>0.999)
    {
        progress=1.0;
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGPoint myStartPoint, myEndPoint;
    CGFloat myStartRadius, myEndRadius;
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    CGFloat locations[1]={1.0};
    size_t num_locations = 1;
    CGFloat components[12] = {
        0.0, 0.0, 0.8, 0.9,    // Start colour
//        0.9, 0.9, 0.9, 1.0,	// middle colour
//        0.4, 0.7, 0.9, 0.9
    }; // End colour
    myColorspace=CGColorSpaceCreateDeviceRGB();
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 200), NO, 0);
    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextSetShouldAntialias(context, TRUE);
//    CGContextSetAllowsAntialiasing(context, TRUE);
    CGContextSaveGState(context);
    //变形移动
//    CGContextRotateCTM(context, 45);
//    CGContextTranslateCTM(context, 50, -130);
    myGradient=CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
    myStartPoint=CGPointMake(100, 100);
    myStartRadius=50;
    myEndPoint=myStartPoint;
    myEndRadius=30;
    
    
//    CGContextSetFillColorWithColor(context,[UIColor redColor].CGColor);
//    CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
//    CGContextAddArc(context, myStartPoint.x, myStartPoint.y, 50, 0,angleToRadian(30) , 0);
//    CGContextFillPath(context);
    CGContextMoveToPoint(context, PAUSE_BUTTON_CENTER.x, PAUSE_BUTTON_CENTER.y);
    CGContextAddArc(context, PAUSE_BUTTON_CENTER.x, PAUSE_BUTTON_CENTER.y, PROGRESS_RADIUS, angleToRadian(-90),angleToRadian(progress*360-90) , 0);
    //闭合路径结束路径
//    CGContextClosePath(context);
    //遮罩
    CGContextClip(context);
    CGContextFillPath(context);

    //一个圆框
//    CGContextMoveToPoint(context, 200, 80);
//    CGContextSetLineWidth(context, 0);
//    CGContextAddEllipseInRect(context, CGRectMake(200, 0, 100, 80));
//    CGContextStrokePath(context);
    //==上面两行
//    CGContextFillEllipseInRect(context, CGRectMake(200, 0, 100, 80));
    
    CGContextDrawRadialGradient(context,
                                myGradient,
                                PAUSE_BUTTON_CENTER, PROGRESS_RADIUS-PROGRESS_STROKE_WIDTH, PAUSE_BUTTON_CENTER, PROGRESS_RADIUS, 0);

    CGContextRestoreGState(context);
    
//    CGColorSpaceRelease(myColorspace);
//    CGGradientRelease(myGradient);
}


@end
