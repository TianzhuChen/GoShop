//
//  LRCView.m
//  GoShop
//
//  Created by iwinad2 on 13-8-16.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "LRCView.h"
#include <QuartzCore/QuartzCore.h>

#define KEY_TIME @"time"
#define KEY_CONTENT @"content"

#define LABELCOLOR_NORMAL [UIColor whiteColor]
#define LABELCOLOR_FOCUS [UIColor redColor]


@implementation LRCView
@synthesize lrcFocusColor,lrcNormalColor,enableScroll,lrcDelegate,lrcLineGap,maskImage,lineImage,lrcFont;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lrcScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(frame), CGRectGetHeight(frame))];
        lrcScrollView.delegate=self;
        lrcScrollView.backgroundColor=[UIColor clearColor];
        lrcScrollView.showsVerticalScrollIndicator=NO;
        lrcScrollView.alwaysBounceVertical=YES;
        lrcScrollView.decelerationRate=UIScrollViewDecelerationRateNormal;
        [self addSubview:lrcScrollView];
        
        lrcLineGap=6;
        lrcNormalColor=[UIColor whiteColor];
        lrcFocusColor=[UIColor redColor];
        halfHeight=CGRectGetHeight(self.frame)/2;
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
#pragma mark 显示歌词根据地址指定的歌词
-(void)displayLrcWithUrl:(NSString *)url
{
   NSError *error;
   NSString *lrcSource_=[NSString stringWithContentsOfFile:url
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
//    NSLog(@"source>>>%@",lrcSource_);
    if(error)
    {
        [self showErrorInfo:NSLocalizedString(@"LRC load error", @"")];
    }else
    {
        [self displayLrcWithSource:lrcSource_];      
    }
    
}
-(void)displayLrcWithSource:(NSString *)source
{
    [self resetProperty];
    [self prepareUI];
    lrcSource=source;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self parseLrcSource];
         totalLrcLines=lrcContents.count;
//        [self prepareDisplayData];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self displayLrc];
        });
       
    });
}
#pragma mark 滚动到指定时间
-(void)scrollToDuration:(NSTimeInterval)duration
{
    [self updateLrcByTime:duration];
}
#pragma mark 更新歌词显示
-(void)updateLrcByTime:(NSTimeInterval)duration
{
//    NSLog(@"lrcView>>>%f",duration);
    if(enableUpdate)
    {
        int tempCurrentLrcIndex=0;
        for(int i=0;i<totalLrcLines;i++)
        {
            if([[lrcContents[i] valueForKey:KEY_TIME] floatValue]>duration)
            {
                tempCurrentLrcIndex=i-1;
                if(tempCurrentLrcIndex<0)
                {
                    tempCurrentLrcIndex=0;
                }
                break;
            }else if(i+1==totalLrcLines)//已经是最后一行了
            {
                tempCurrentLrcIndex=totalLrcLines-1;
                break;
            }
        }
        if(tempCurrentLrcIndex!=currentLrcIndex)
        {
//            NSLog(@"tempCurrentLrcIndex>>%d",tempCurrentLrcIndex);
           [self moveToLrcWithIndex:tempCurrentLrcIndex];
        }
        
    }
}
-(void)setEnableScroll:(BOOL)enableScroll_
{
    [self delayUpdate];
    enableScroll=enableScroll_;
    lrcScrollView.scrollEnabled=enableScroll;
}
#pragma mark -
-(void) resetProperty
{
    timeType=0;
    currentLrcIndex=-1;
    totalLrcLines=0;
}
-(void)showErrorInfo:(NSString *)info
{
    
}
//解析完歌词后，显示出来，主线程中
-(void)displayLrc
{
    [self delayUpdate];
    [self prepareDisplayData];
    
    [self moveToLrcWithIndex:0];
}
//移动到指定行
-(void)moveToLrcWithIndex:(int)index
{
//   NSLog(@"moveTo>>%d",index);
    if(index<0 || index>=totalLrcLines)
    {
        return;
    }
    if(index!=currentLrcIndex)
    {
        if(currentLrcIndex>=0)
        {
            ((UILabel *)lrcLineLabels[currentLrcIndex]).textColor=lrcNormalColor;
        }
        
        currentLrcIndex=index;
        ((UILabel *)lrcLineLabels[currentLrcIndex]).textColor=lrcFocusColor;
    }
    
    CGPoint p=CGPointMake(0, [lrcPositions[index] floatValue]);
    [lrcScrollView setContentOffset:p animated:YES];
}
#pragma mark 歌词解析
//解析歌词源
-(void)parseLrcSource
{
    NSArray *lrcLineSource_=[lrcSource componentsSeparatedByString:@"\n"];
    //可以释放原始的歌词数据
    lrcSource=nil;
    if(!lrcLineSource_ || lrcLineSource_.count<1)
    {
        [self showErrorInfo:NSLocalizedString(@"LRC Content error", @"")];
    }else
    {
        [self parseLrcWithLines:lrcLineSource_];
    }
}
//分行解析
-(void)parseLrcWithLines:(NSArray *)lrclines_
{
    NSMutableArray *tempLines=[[NSMutableArray alloc] init];
    NSArray *tempArr;
    for(NSString *line in lrclines_)
    {
        tempArr=[line componentsSeparatedByString:@"]"];
        if(tempArr.count==0)//空行过滤掉
        {
            continue;
        }else
        {
            //第一个分割点
            if(![self parseIdtags:tempArr[0]])
            {
                NSString *tempContent=[tempArr lastObject];
                
                if([tempContent isEqualToString:@"\r"] || tempContent.length<1)//置换空内容为....
                {
                    tempContent=@"......";
                }
                for(int i=0;i<tempArr.count-1;i++)//减一是因为最后一个为内容
                {
                    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithFloat:[self formatLrcTimeToSeconds:tempArr[i]]],
                                       KEY_TIME,tempContent,KEY_CONTENT, nil];
//                    NSLog(@"tempContnet>>>%f|||%@",[[dic valueForKey:@"time"] floatValue],tempContent);
                    [tempLines addObject:dic];
                }
            }
        }
    }
    if(lrcContents){
        lrcContents=nil;
    }
    NSSortDescriptor *sortByTime=[NSSortDescriptor sortDescriptorWithKey:KEY_TIME ascending:YES];
    [tempLines sortUsingDescriptors:@[sortByTime]];
    lrcContents=[NSArray arrayWithArray:tempLines];
}
//解析歌词的标签，如果是标签返回yes
-(BOOL)parseIdtags:(NSString *)lrcLine
{
    if(![lrcLine hasPrefix:@"["])//没有这个标签标示无用行，过滤掉
    {
        return YES;
    }else if([lrcLine hasPrefix:@"[ar"])
    {
        return YES;
    }else if([lrcLine hasPrefix:@"[ti"])
    {
        return YES;
    }else if([lrcLine hasPrefix:@"[al"])
    {
        return YES;
    }else if([lrcLine hasPrefix:@"[by"])
    {
        return YES;
    }else if([lrcLine hasPrefix:@"[offset"])
    {
        return YES;
    }
    return NO;
}
//格式化lrc时间为秒，传入参数可能包括"["
//支持3种
//都以两位(00)计算
//1、[分钟:秒.毫秒]
//2、[分钟:秒:毫秒]
//3、[分钟:秒]

int timeType=0;//0表示还没有确定歌词的时间格式(缓存类型判断)
int minutes=0;
int seconds=0;
float millisecond=0;
-(CGFloat)formatLrcTimeToSeconds:(NSString *)lrcTime
{
//    NSString *time_=[lrcTime substringWithRange:NSMakeRange(1, lrcTime.length-1)];
    if([lrcTime hasPrefix:@"["]){
        lrcTime=[lrcTime substringWithRange:NSMakeRange(1, lrcTime.length-1)];
    }
    NSArray *timeArr=[lrcTime componentsSeparatedByString:@":"];
    if(timeType==0)
    {
       if(timeArr.count==3)
       {
           timeType=2;
       }else
       {
           if([timeArr[1] rangeOfString:@"."].location!=NSNotFound)
           {
               timeType=1;
           }else
           {
               timeType=3;
           }
       }
    }
    
    minutes=[timeArr[0] intValue];
    switch (timeType) {
        case 1:
            seconds=[[timeArr[1] substringWithRange:NSMakeRange(0, 2)] intValue];
            millisecond=[[timeArr[1] substringWithRange:NSMakeRange(3, 2)] floatValue];
            break;
        case 2:
            seconds=[timeArr[1] intValue];
            millisecond=[timeArr[2] floatValue];
            break;
        case 3:
             seconds=[timeArr[1] intValue];
            break;
        default:
            break;
    }
    return minutes*60+seconds+millisecond/100;
}
#pragma mark 准备显示
-(void)prepareDisplayData
{
    NSMutableArray *tempPositions=[[NSMutableArray alloc] initWithCapacity:totalLrcLines];
    NSMutableArray *tempDragPositionNodes=[[NSMutableArray alloc] initWithCapacity:totalLrcLines];
    NSMutableArray *tempLineLabels=[[NSMutableArray alloc] initWithCapacity:totalLrcLines];
    //第一行高度的一半
    __block float beforePosition=0;
    __block float beforeHalfHeight=0;
    __block float currentHalfHeight=0;
    
    float labelWidth=CGRectGetWidth(self.frame);
    __block float contentTotalHeight=0;
    CGSize constrainedSize=CGSizeMake(labelWidth, 5000);
    
    
    [lrcContents enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        UILabel *lrcLineLabel=[[UILabel alloc] init];
        lrcLineLabel.textColor=lrcNormalColor;
        lrcLineLabel.backgroundColor=[UIColor clearColor];
        lrcLineLabel.textAlignment=NSTextAlignmentCenter;
        lrcLineLabel.numberOfLines=0;
        lrcLineLabel.font=lrcFont;
        lrcLineLabel.text=[obj valueForKey:KEY_CONTENT];//[NSString stringWithFormat:@"%0.1f",[[lrcContents[idx] valueForKey:KEY_TIME] floatValue]];
        CGSize size=[lrcLineLabel.text sizeWithFont:lrcFont constrainedToSize:constrainedSize];
        contentTotalHeight+=size.height+lrcLineGap;
        lrcLineLabel.frame=CGRectMake(0, 30*idx, labelWidth, size.height+4);
        [lrcScrollView addSubview:lrcLineLabel];
        [tempLineLabels addObject:lrcLineLabel];
        
        currentHalfHeight=(size.height+lrcLineGap)/2;
        beforePosition=beforePosition+beforeHalfHeight+currentHalfHeight;
        if(idx==0)
        {
            beforePosition=0;
        }
        [tempPositions addObject:[NSNumber numberWithFloat:beforePosition]];
        [tempDragPositionNodes addObject:[NSNumber numberWithFloat:beforePosition-currentHalfHeight]];
        beforeHalfHeight=currentHalfHeight;
        lrcLineLabel.center=CGPointMake(lrcLineLabel.center.x, beforePosition+halfHeight);
    }];

    if(lrcPositions)
    {
        lrcPositions=nil;
    }
    lrcPositions=[NSArray arrayWithArray:tempPositions];
    
    
    if(dragPositionNodes)
    {
        dragPositionNodes=nil;
    }
    dragPositionNodes=[NSArray arrayWithArray:tempDragPositionNodes];
    minPosition=[dragPositionNodes[0] floatValue];
    maxPosition=[[dragPositionNodes lastObject] floatValue];
    
    if(lrcLineLabels)
    {
        lrcLineLabels=nil;
    }
    lrcLineLabels=[NSArray arrayWithArray:tempLineLabels];
    
    //最后应该减去第一行和最后一行的歌词高度的一半
    lrcScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.frame),
                                         contentTotalHeight+CGRectGetHeight(self.frame)-CGRectGetHeight(((UILabel *)lrcLineLabels[0]).frame)/2-CGRectGetHeight(((UILabel *)[lrcLineLabels lastObject]).frame)-lrcLineGap);
}

#pragma mark 显示拖动歌词的进度
-(void)updateDragTimeByContentOffset:(float)offset
{
    int i=0;
    int tempDragLrcIndex=0;
    if(offset<minPosition)
    {
        tempDragLrcIndex=0;
    }else if(offset>maxPosition)
    {
        tempDragLrcIndex=totalLrcLines-1;
    }else
    {
        for(NSNumber *position in dragPositionNodes)
        {
            if([position floatValue]>offset)
            {
                if(i>0)
                {
                   tempDragLrcIndex=i-1;
                }else
                {
                   tempDragLrcIndex=i;
                }
                break;
            }
            i++;
        }
    }
    timeLabel.text=[Help formatSecondsToTime:[[lrcContents[dragLrcIndex] valueForKey:KEY_TIME] floatValue]];//[NSString stringWithFormat:@"%0.1f",[[lrcContents[dragLrcIndex] valueForKey:KEY_TIME] floatValue]];
    if(!timeLabel.superview)
    {
        [self addSubview:timeLabel];
        [self addSubview:lineImage];
    }
    if(dragLrcIndex!=tempDragLrcIndex)
    {
        ((UILabel *)lrcLineLabels[dragLrcIndex]).textColor=lrcNormalColor;
        ((UILabel *)lrcLineLabels[tempDragLrcIndex]).textColor=lrcFocusColor;
        dragLrcIndex=tempDragLrcIndex;
    }
    
}

#pragma mark UIScrollViewDelegate协议代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     dragLrcIndex=currentLrcIndex;
//     enableUpdate=NO;
    [self stopUpdate];
     if([lrcDelegate respondsToSelector:@selector(dragLrcDidBegin)])
     {
         
     }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.dragging)
    {
        [self updateDragTimeByContentOffset:scrollView.contentOffset.y];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        NSLog(@"scrollViewDidEndDecelerating");
        [self endDragMove];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        NSLog(@"scrollViewDidEndDragging");
        [self endDragMove];
    }
}
-(void)endDragMove
{
//    NSLog(@"endDragMove>>%d",dragLrcIndex);
    [self moveToLrcWithIndex:dragLrcIndex];
    if(timeLabel)
    {
        [timeLabel removeFromSuperview];
        [lineImage removeFromSuperview];
    }
    if([lrcDelegate respondsToSelector:@selector(dragLrcDidEnd:)])
    {
        [lrcDelegate dragLrcDidEnd:[[lrcContents[dragLrcIndex] valueForKey:KEY_TIME] doubleValue]];
    }
    [self delayUpdate];
}
//解决播放时，拖动歌词闪动问题
-(void)delayUpdate
{
    [self performSelector:@selector(startUpdate) withObject:nil afterDelay:0.5];
    
}
-(void)stopUpdate
{
    enableUpdate=NO;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(startUpdate) object:nil];
}
-(void)startUpdate
{
    enableUpdate=YES;
}
#pragma mark 初始化ui
bool havedPrepareUI=false;
-(void)prepareUI{
    if(havedPrepareUI)
    {
        return;
    }
    havedPrepareUI=true;
    CGContextRef context;
    if(!maskImage)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        context=UIGraphicsGetCurrentContext();
        CGGradientRef gradient;
        CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
        CGFloat colors[20]={
            1.0,1.0,1.0,0.7,
            1.0,1.0,1.0,0.0,
            1.0,1.0,1.0,0.0,
            1.0,1.0,1.0,0.0,
            1.0,1.0,1.0,0.7,
        };
        CGFloat locations[5]={0.0,0.4,0.5,0.6,1.0};
        gradient=CGGradientCreateWithColorComponents(colorSpace, colors, locations, 5);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetWidth(self.frame)/2, 0), CGPointMake(CGRectGetWidth(self.frame)/2, halfHeight*2), kCGGradientDrawsBeforeStartLocation);
        UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
        maskImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        maskImage.image=img;
        [self addSubview:maskImage];
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
    }else
    {
        maskImage.center=CGPointMake(CGRectGetWidth(self.frame),halfHeight);
    }
    
    if(!lineImage)
    {
        UIGraphicsBeginImageContext(CGSizeMake(CGRectGetWidth(self.frame), 1));
        context=UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 2);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.195 green:0.840 blue:1.000 alpha:1.000].CGColor);
        CGFloat dashs[2]={4,4};
        CGContextSetLineDash(context, 0, dashs,2);
        CGContextMoveToPoint(context, 0, 1);
        CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), 1);
        CGContextStrokePath(context);
        CGContextStrokePath(context);
        
        UIImage *img1=UIGraphicsGetImageFromCurrentImageContext();
        lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, halfHeight, CGRectGetWidth(self.frame), 1)];
        lineImage.image=img1;
        
        UIGraphicsEndImageContext();
    }else
    {
        lineImage.center=CGPointMake(CGRectGetWidth(self.frame),halfHeight);
    }
    if(!lrcFont)
    {
        lrcFont=[UIFont systemFontOfSize:13];
    }
    timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-30,halfHeight-13, 30, 12)];
    timeLabel.textColor=[UIColor colorWithRed:0.140 green:0.795 blue:1.000 alpha:1.000];
    timeLabel.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.2];
    timeLabel.font=[UIFont systemFontOfSize:11];
}
-(void)dealloc{
    [[self class] cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(startUpdate)
                                                   object:nil];
}
@end
