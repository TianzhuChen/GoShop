//
//  BaseViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

-(id)initWithClassName{
    self=[super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if(self){
        [self initController];
    }
    return self;
}
-(void)initController{};
-(void)viewDidLoad{
    self.view.backgroundColor=[Theme getColorByRed:203 green:214 blue:216 alpha:1];
    NSLog(@"viewDidload>>>%@||parentControl>>>%@",NSStringFromClass(isa),self.parentViewController);
//    self.navigationController.navigationBarHidden=YES;
}
-(void)viewDidUnload{
    NSLog(@"viewDidUnload>>>%@",NSStringFromClass(isa));
}
-(void)didReceiveMemoryWarning{
    NSLog(@"didReceiveMemoryWarning>>>%@",NSStringFromClass(isa));
}
-(void)dealloc{
    NSLog(@"dealloc>>>%@",NSStringFromClass(isa));
}
-(void)setTitleView:(UIView *)titleView{
    if(_titleView){
        [_titleView removeFromSuperview];
    }
    _titleView=titleView;
    [self.view addSubview:titleView];
}
-(void)resetViewFrameByTitleview:(UIView *)view{
    CGRect Tframe=view.frame;
    Tframe.origin.y=CGRectGetMaxY(self.titleView.frame)+5;
    Tframe.size.height=CGRectGetHeight(self.view.frame)-Tframe.origin.y;
    view.frame=Tframe;
}
-(void)setBarLeftItem:(UIImage *)image{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
-(void)leftButtonTap{
    NSLog(@"left item");
};
-(void)setBarRightItem:(UIImage *)image{
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftButtonTap) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)rightButtonTap{
    NSLog(@"right item");
};
@end
