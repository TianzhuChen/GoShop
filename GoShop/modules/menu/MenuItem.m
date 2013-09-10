//
//  MenuItem.m
//  GoShop
//
//  Created by iwinad2 on 13-6-18.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "MenuItem.h"

@interface MenuItem(){
    BOOL isShow;
    
}
@end

@implementation MenuItem
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.radius=0;
        self.angle=0;
        
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)click:(UIButton *)button{
    //_itemClick(self);
    if([delegate respondsToSelector:@selector(menuItemClick:)]){
        [delegate menuItemClick:self];
    }
}
-(void)setMenuIndex:(MenuItemEnum)menuIndex{
    _menuIndex=menuIndex;
}
-(void)initItemDisplayWithScale:(CATransform3D)scale rotation:(CATransform3D)rotation{
    _initScaleTransform=scale;
    _initRotationTransform=rotation;
    [CATransaction commit];
    [CATransaction setDisableActions:YES];
    CATransform3D trans=CATransform3DConcat(scale, rotation);
    self.layer.transform=trans;
    [CATransaction commit];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGContextRef ref=UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ref, [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1].CGColor);
//    CGContextMoveToPoint(ref, _radius, _radius*sin(_angle/2));
//    CGContextAddArc(ref,_radius, _radius*sin(_angle/2), _radius,  angleToRadian(-180+_angle/2),  angleToRadian(180-_angle/2), 1);
//    CGContextFillPath(ref);
//  self.layer.transform=CATransform3DConcat(_initRotationTransform, _initScaleTransform);  
   
    
  
}
-(void)setAngle:(CGFloat)angle{
    _angle=angle;
    [self updateFrame];
}
-(void)setRadius:(CGFloat)radius{
    _radius=radius;
    [self updateFrame];
}
-(void)updateFrame{
    
    if(_angle!=0 && _radius!=0){
        CGRect Tframe=self.frame;
        if(CGRectEqualToRect(Tframe, CGRectZero)){
            Tframe.origin.x=0;
            Tframe.origin.y=0;
        }
        Tframe.size.height=_radius*sin(_angle/2)*2;
        Tframe.size.width=_radius;
        self.frame=Tframe;
        self.layer.anchorPoint=CGPointMake(1.0f, 0.5f);
        
        //绘制背景图
        UIGraphicsBeginImageContextWithOptions(Tframe.size, NO, 0);
        CGContextRef ref=UIGraphicsGetCurrentContext();
        UIColor *tempColor=[UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
        CGColorRef colorRef=tempColor.CGColor;
        CGContextSetLineWidth(ref,1);
        CGContextSetFillColorWithColor(ref, colorRef);
        CGContextSetStrokeColorWithColor(ref, colorRef);
        
        CGContextMoveToPoint(ref, _radius, _radius*sin(_angle/2));
       
        CGContextAddArc(ref,_radius, _radius*sin(_angle/2), _radius,  (M_PI/180*(-180)+_angle/2),  (M_PI/180*(180)-_angle/2), 1);
        CGContextFillPath(ref);
        CGContextStrokePath(ref);
        
        UIImage *bgImg=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundImage:bgImg forState:UIControlStateNormal];
        
//        UIGraphicsBeginImageContextWithOptions(Tframe.size, NO, 0);
//        ref=UIGraphicsGetCurrentContext();
//        CGContextSetStrokeColorWithColor(ref, [UIColor blueColor].CGColor);
//        CGContextMoveToPoint(ref, _radius, _radius*sin(_angle/2));
//        CGContextAddArc(ref,_radius, _radius*sin(_angle/2), _radius,  angleToRadian(-180+_angle/2),  angleToRadian(180-_angle/2), 1);
//        CGContextStrokePath(ref);
//        UIImage *foucsImg=UIGraphicsGetImageFromCurrentImageContext();
//        [self setImage:foucsImg forState:UIControlStateNormal];
        
        self.layer.transform=CATransform3DConcat(_initRotationTransform, _initScaleTransform);
        
       
        //设置测试标题
        [self setTitle:[NSString stringWithFormat:@"%d",_menuIndex] forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(Tframe.size.width)+self.titleLabel.frame.size.width+3,0 ,0)];
    }
    
}

-(void)show:(MenuItemAnimationParam)animationParam{
    if(isShow){
        return;
    }
    isShow=YES;
    CATransform3D transform;
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setFillMode:kCAFillModeBoth];
    [animation setRemovedOnCompletion:NO];
    [animation setDelegate:self];
    transform=CATransform3DConcat(self.initScaleTransform,
                                 self.initRotationTransform);
    [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
    transform=CATransform3DConcat(self.displayScaleTransform,
                                  self.displayRotationTransform);
    [animation setToValue:[NSValue valueWithCATransform3D:transform]];
    
    [animation setBeginTime:animationParam.startDelayTime];
    [animation setDuration:animationParam.duration];
    [self.layer addAnimation:animation forKey:@"menuExpand"];
}
-(void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    if(flag){ 
//        if([anim.toValue isEqual:[NSValue valueWithCATransform3D:CATransform3DConcat(self.displayScaleTransform,
//                                                                                    self.displayRotationTransform)]]){
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
        if(isShow){
            self.layer.transform=CATransform3DConcat(self.displayScaleTransform,
                                                     self.displayRotationTransform);
        }else{
            self.layer.transform=CATransform3DConcat(self.hideScaleTransform,
                                                     self.hideRotationTransform);
        }
//        [CATransaction commit];
    }
}
-(void)showChildItem:(MenuItemAnimationParam)animationParam{
    if(_childrenItems.count>0){
        [_childrenItems enumerateObjectsUsingBlock:^(MenuItem *item, NSUInteger index, BOOL *stop){
            [item show:animationParam];
        }];
    }
}
-(void)hide:(MenuItemAnimationParam)animationParam{
    if(!isShow){
        return;
    }
    isShow=NO;
    CATransform3D transform=CATransform3DConcat(self.hideScaleTransform,
                                  self.hideRotationTransform);
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setFillMode:kCAFillModeBoth];
    [animation setRemovedOnCompletion:NO];
    [animation setDelegate:self];
    [animation setToValue:[NSValue valueWithCATransform3D:transform]];
    
    [animation setBeginTime:animationParam.startDelayTime];
    [animation setDuration:animationParam.duration];
    [self.layer addAnimation:animation forKey:@"menuFold"];
}
//隐藏子菜单
-(void)hideChildItem:(MenuItemAnimationParam)animationParam{
    if(_childrenItems.count>0){
        [_childrenItems enumerateObjectsUsingBlock:^(MenuItem *item, NSUInteger index, BOOL *stop){
            [item hide:animationParam];
        }];
    }
}
-(MenuItem *)getMenuItemByIndex:(MenuItemEnum)itemIndex{
    for(MenuItem *item in self.childrenItems){
        if(item.menuIndex==itemIndex){
            return item;
        }
    }
    return nil;
}
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    [UIColor clearColor];
//}
@end
