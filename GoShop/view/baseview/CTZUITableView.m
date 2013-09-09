//
//  CTZUITableView.m
//  GoShop
//
//  Created by Tianzhu on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "CTZUITableView.h"
#import "Global.h"

@implementation CTZUITableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSelfProperty];
        
    }
    return self;
}
-(id)init{
    self=[super init];
    if(self){
        [self initSelfProperty];
    }
    return self;
}
-(void)awakeFromNib{
    [self initSelfProperty];
    self.delaysContentTouches=YES;
}
-(void)initSelfProperty{
    window=[UIApplication sharedApplication].keyWindow;
    limitRect=LIMIT_CGRECT;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideMenu:)
                                                 name:HIDE_MENU_NOTIFICATION
                                               object:nil];
}
-(void)hideMenu:(NSNotification *)noti{
//    self.scrollEnabled=YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//
//    CGPoint point=[gestureRecognizer locationInView:window];
//    if(CGRectContainsPoint(beganRect, point)){
//        return NO;
//    }else{
//        return YES;
//    }
    return YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@"getsutre>>%@",gestureRecognizer);
    CGPoint point=[gestureRecognizer locationInView:window];
    
    if(self.panGestureRecognizer==gestureRecognizer){
        UIPanGestureRecognizer *pan=(UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point1=[pan translationInView:window];
//         || fabsf(point1.x)>fabsf(point1.y)
        if(CGRectContainsPoint(limitRect, point) || fabsf(point1.x)>fabsf(point1.y)){
//            fabsf(point1.x)>fabsf(point1.y)
//            NSLog(@"rect>>%@||point>>%@",NSStringFromCGRect(limitRect),NSStringFromCGPoint(point));
//            self.scrollEnabled=NO;
            return NO;
        }else{
//            self.scrollEnabled=YES;
            return YES;
        }
    }else{
        if(CGRectContainsPoint(limitRect, point)){
//            self.scrollEnabled=NO;
            return NO;
        }else{
//            self.scrollEnabled=YES;
            return YES;
        }
    }
//    if(gestureRecognizer.state==UIGestureRecognizerStateBegan){
//        NSLog(@"began");
//        self.scrollEnabled=YES;
//        return YES;
//    }else{
//        NSLog(@"began11");
//        return NO;
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
