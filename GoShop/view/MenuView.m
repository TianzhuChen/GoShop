//
//  MenuView.m
//  GoShop
//
//  Created by Tianzhu on 13-6-13.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "MenuView.h"
#import "Help.h"


#define HIDE_POSITION CGPointMake([Help sharedInstance].screenWidth,[Help sharedInstance].screenHeight)
#define MENU_POSITION CGPointMake(CGRectGetWidth(self.frame)-0, CGRectGetHeight(self.frame)-0)
#define enum_To_NSNumber(enumInt) [NSNumber numberWithInt:enumInt]

#define INNER_RADIUS 50
//#define HIDE_CHILDANIPARAM {0.4f,CACurrentMediaTime()}
//#define SHOW_CHILDANIPARAM {0.4f,CACurrentMediaTime()+0.4f}

@interface MenuView(){
    NSMutableArray *menuItems;
    UIView *backgroundView;
    CGPoint centerPoint;
    MenuItem *homeItem;
    
    MenuItemClick _itemClick;
    
}

@end

@implementation MenuView
@synthesize currentFirstMenuItemIndex,isShowing;

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor clearColor];
        [self initMenu];
    }
    return self;
}
#pragma mark 菜单初始化
-(void)initMenu{
    
    centerPoint=CGPointMake([Help sharedInstance].screenWidth,[Help sharedInstance].screenHeight);
    menuItems=[[NSMutableArray alloc] initWithCapacity:4];
    
//    _itemClick=^(MenuItem *item){
//        NSLog(@"item>>%d",item.menuIndex);
//    };

    //一级菜单索引
    NSArray *firstMenuItemIndexs=@[enum_To_NSNumber(menuItemIndexNew),
                                   enum_To_NSNumber(menuItemIndexShop),
                                   enum_To_NSNumber(menuItemIndexGoodNew),
                                   enum_To_NSNumber(menuItemIndexAccount)];
    //二级菜单索引
    NSArray *secondMenuItemIndexs=@[@[enum_To_NSNumber(menuItemIndexNewByArea),
                                      enum_To_NSNumber(menuItemIndexNewByTime),
                                      enum_To_NSNumber(menuItemIndexNewByRating),
                                      enum_To_NSNumber(menuItemIndexNewByShop)],
                                    @[enum_To_NSNumber(menuItemIndexShopByArea),
                                      enum_To_NSNumber(menuItemIndexShopByName),
                                      enum_To_NSNumber(menuItemIndexShopByRating)],
                                    @[enum_To_NSNumber(menuItemIndexGoodNewByArea),
                                      enum_To_NSNumber(menuItemIndexGoodNewByRating),
                                      enum_To_NSNumber(menuItemIndexGoodNewByShop),
                                      enum_To_NSNumber(menuItemIndexGoodNewByTime)],@[]];
    CGFloat menuItemNumber=firstMenuItemIndexs.count;//菜单数量
    //        CGFloat itemRadius=30;//单个菜单的半径
    //        CGFloat edageRadius=atan2f(itemRadius, INNER_RADIUS);//两边的菜单与屏幕边界的角度
    //        CGFloat averageRadius=(M_PI_2/2-edageRadius*2)/(menuItemNumber-1);//中间的平均角度
    
    for(int i=0;i<menuItemNumber;i++){//一级菜单,位置计算是，以y轴冲下往上算
        MenuItem *item=[[MenuItem alloc] initWithFrame:CGRectZero];
        item.delegate=self;
        item.menuLevel=menuItemLevel_FIRST;
        item.menuIndex=[firstMenuItemIndexs[i] intValue];
        item.superMenuIndex=menuItemIndexHome;
        item.radius=130;
        item.angle=angleToRadian(90/menuItemNumber);
        item.hidePosition=HIDE_POSITION;
        [item initItemDisplayWithScale:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)
                              rotation:CATransform3DMakeRotation((item.angle/2+item.angle*i+angleToRadian(90)), 0.0f, 0.0f, 1.0f)];
        item.displayRotationTransform=CATransform3DMakeRotation(item.angle/2+item.angle*i, 0.0f, 0.0f, 1.0f);
        item.hideRotationTransform=CATransform3DMakeRotation(item.angle/2+item.angle*i+angleToRadian(-90),0.0f,0.0f,1.0f);
        item.displayScaleTransform=CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
        item.hideScaleTransform=CATransform3DMakeScale(1.0f, 1.0f,1.0f);
        item.layer.position=MENU_POSITION;
        [self addSubview:item];
        
        NSArray *TchildItemIndexs=[secondMenuItemIndexs objectAtIndex:i];
        NSMutableArray *childItems=[[NSMutableArray alloc] initWithCapacity:TchildItemIndexs.count];
        for(int j=0;j<TchildItemIndexs.count;j++){//二级菜单
            MenuItem *TchildItem=[[MenuItem alloc] initWithFrame:CGRectZero];
            TchildItem.delegate=self;
            TchildItem.menuLevel=menuItemLevel_SECOND;
            TchildItem.menuIndex=[TchildItemIndexs[j] intValue];
            TchildItem.superMenuIndex=[firstMenuItemIndexs[i] intValue];
            TchildItem.radius=180;
            TchildItem.angle=M_PI_2/TchildItemIndexs.count;//angleToRadian(90/TchildItemIndexs.count);
            TchildItem.hidePosition=HIDE_POSITION;
            [TchildItem initItemDisplayWithScale:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)
                                        rotation:CATransform3DMakeRotation((TchildItem.angle/2+TchildItem.angle*j+angleToRadian(-90)), 0.0f, 0.0f, 1.0f)];
            TchildItem.displayRotationTransform=CATransform3DMakeRotation((TchildItem.angle/2+TchildItem.angle*j), 0.0f, 0.0f, 1.0f);
            TchildItem.hideRotationTransform=CATransform3DMakeRotation(TchildItem.angle/2+TchildItem.angle*j+angleToRadian(90),0.0f,0.0f,1.0f);
            TchildItem.displayScaleTransform=CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
            TchildItem.hideScaleTransform=CATransform3DMakeScale(1.0f, 1.0f,1.0f);
            TchildItem.layer.position=MENU_POSITION;
            [childItems addObject:TchildItem];
            [self insertSubview:TchildItem atIndex:0];
        }
        item.childrenItems=[NSArray arrayWithArray:childItems];
        [menuItems addObject:item];
    }
    //顶级菜单
    homeItem=[[MenuItem alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    homeItem.delegate=self;
    homeItem.menuLevel=menuItemLevel_HOME;
    homeItem.menuIndex=menuItemIndexHome;
    homeItem.superMenuIndex=1000;
    homeItem.radius=80;
    homeItem.angle=angleToRadian(90);
    [homeItem initItemDisplayWithScale:CATransform3DMakeScale(0.001f, 0.001f, 1.0f)
                              rotation:CATransform3DMakeRotation(angleToRadian(45), 0.0f, 0.0f, 1.0f)];
    homeItem.displayRotationTransform=homeItem.initRotationTransform;
    homeItem.hideRotationTransform=homeItem.displayRotationTransform;
    homeItem.displayScaleTransform=CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
    homeItem.hideScaleTransform=CATransform3DMakeScale(0.001f, 0.001f,1.0f);
    homeItem.layer.position=MENU_POSITION;
    [self addSubview:homeItem];
    
    currentFirstMenuItemIndex=menuItemIndexNew;
    
    
    UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(backgroundViewTap:)];
    backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    backgroundView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    backgroundView.alpha=0.0f;
    [self insertSubview:backgroundView atIndex:0];
    [backgroundView addGestureRecognizer:tap3];
    tap3.delegate=self;
}
#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
-(void)backgroundViewTap:(UITapGestureRecognizer *)tap{
    [self hideMenu];
}
#pragma mark 点击菜单项
-(void)menuItemClick:(MenuItem *)item{
    NSLog(@"menuItemLevel>>%d|||%d",item.menuLevel,item.menuIndex);
    MenuItemAnimationParam showChildAniParam={0.5f,CACurrentMediaTime()};
    MenuItemAnimationParam hideChidAniParam={0.5f,CACurrentMediaTime()};
    
    if(item.menuLevel==menuItemLevel_HOME){
//        currentFirstMenuItemIndex=menuItemIndexHome;
//        if([self getCurrentSelectedMenuItem].childrenItems.count!=0){//如果有子菜单进入子菜单
//            [[self getCurrentSelectedMenuItem] hideChildItem:showChildAniParam];
//            [menuItems enumerateObjectsUsingBlock:^(MenuItem *item, NSUInteger index, BOOL *stop){
//                [item show:showChildAniParam];
//            }];
//        }
    }else if(item.menuLevel==menuItemLevel_FIRST){
        if(currentFirstMenuItemIndex!=item.menuIndex){
            [self getCurrentSelectedMenuItem].selected=NO;
            [[self getCurrentSelectedMenuItem] hideChildItem:hideChidAniParam];
            currentFirstMenuItemIndex=item.menuIndex;
            if(item.childrenItems.count!=0){//如果有子菜单进入子菜单
                [[self getCurrentSelectedMenuItem] showChildItem:showChildAniParam];
//                [menuItems enumerateObjectsUsingBlock:^(MenuItem *item, NSUInteger index, BOOL *stop){
//                    [item hide:hideChidAniParam];
//                }];
            }
            
            if([self.delegate respondsToSelector:@selector(selectedMenuItem:)]){
                [self.delegate selectedMenuItem:item];
            }
            if(item.childrenItems.count==0){
                [self performSelector:@selector(hideMenu) withObject:self afterDelay:0.5];
            }
        }
        [self getCurrentSelectedMenuItem].selected=YES;
    }else if(item.menuLevel==menuItemLevel_SECOND){
        if([self getCurrentSelectedMenuItem].childMenuIndex!=item.menuIndex){
            [self getCurrentSelectedMenuItem].childMenuIndex=item.menuIndex;
            if([self.delegate respondsToSelector:@selector(selectedMenuItem:)]){
                [self.delegate selectedMenuItem:item];
            }
        }
    }

}
#pragma mark 显示菜单
-(void)showMenu:(MenuItemEnum)menuIndex{
    if(isShowing){
        return;
    }
    isShowing=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.7f animations:^(void){
        backgroundView.alpha=1.0f;
    } completion:^(BOOL finished){
        
    }];

    MenuItemAnimationParam homeAniParam={0.4f,CACurrentMediaTime()+0};
    MenuItemAnimationParam aniParam={0.4f,CACurrentMediaTime()+0.3f};
    MenuItemAnimationParam childAniParam={0.4f,CACurrentMediaTime()+0.4f};
    [homeItem show:homeAniParam];
    //一级
    [menuItems enumerateObjectsUsingBlock:^(MenuItem *item, NSUInteger index, BOOL *stop){
        [item show:aniParam];
    }];
    [[self getCurrentSelectedMenuItem] showChildItem:childAniParam];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOTIFICATION object:nil];
}
#pragma mark 隐藏菜单
-(void)hideMenu{
    if(!isShowing){
        return;
    }
    [UIView animateWithDuration:0.8f animations:^(void){
        backgroundView.alpha=0.0f;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    isShowing=NO;
    MenuItemAnimationParam homeAniParam ={0.4f,CACurrentMediaTime()+0.3f};
    MenuItemAnimationParam aniParam ={0.5f,CACurrentMediaTime()+0.1f};
    MenuItemAnimationParam chidAniParam={0.4f,CACurrentMediaTime()};
    [menuItems enumerateObjectsUsingBlock:^(MenuItem *item, NSUInteger index, BOOL *stop){
        [item hide:aniParam];
    }];
    [[self getCurrentSelectedMenuItem] hideChildItem:chidAniParam];
    [homeItem hide:homeAniParam];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_MENU_NOTIFICATION object:nil];
}
-(MenuItem *)getCurrentSelectedMenuItem{
    return menuItems[currentFirstMenuItemIndex];
}

@end
