//
//  AudioViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-7-15.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "AudioViewController.h"
#import "CTZBasicAnimation.h"



@interface AudioViewController ()

@end

@implementation AudioViewController

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
    self.titleView=[Theme getTitleViewWithTitle:@"AudioPlay"
                            withBackgroundColor:[Theme getNavigationBarBackgroundColor:0]];
    
    audioPlayer=[[AudioPlayer alloc] init];

    controlPanel=[[ControlPanel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-70, 320, 70)];
    controlPanel.audioPlay=audioPlayer;
    [self.view addSubview:controlPanel];
    
    lrcPanel=[[LRCView alloc] initWithFrame:CGRectMake(0, 30, 320,360 )];
    lrcPanel.lrcDelegate=self;
    [self.view addSubview:lrcPanel];
    [lrcPanel displayLrcWithUrl:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"青春1.lrc"]];
    lrcPanel.backgroundColor=[UIColor clearColor];
    
    [audioPlayer prepareToPlayWithProgress:^(float progress) {
        [lrcPanel updateLrcByTime:audioPlayer.currentTime];
        [controlPanel updatePlayProgressView:progress];
    }];
    
    listPanel=[[MusicListView alloc] initWithFrame:CGRectMake(0, 30, 320,360 )];
    listPanel.backgroundColor=[UIColor greenColor];
    listPanel.layer.position=CGPointMake(CGRectGetWidth(listPanel.frame)/2, CGRectGetHeight(listPanel.frame)*1.5+listPanel.frame.origin.y);
    listPanel.layer.anchorPoint=CGPointMake(0.5, 1.5);
    listPanel.layer.transform=CATransform3DMakeRotation(angleToRadian(90), 0, 0, 1);
    [self.view addSubview:listPanel];
}
-(void)viewWillAppear:(BOOL)animated{
    CGRect controlPanelFrame=controlPanel.frame;
    controlPanelFrame.origin.y=CGRectGetHeight(self.view.frame)-70;
    controlPanel.frame=controlPanelFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
#pragma mark LRCViewDelegate
-(void)dragLrcDidEnd:(NSTimeInterval)duration{
    [audioPlayer seekToDuration:duration];
}
#pragma mark 歌词和列表显示动画
-(void)showListPanel
{
    lrcPanel.layer.position=CGPointMake(CGRectGetWidth(lrcPanel.frame)/2, CGRectGetHeight(lrcPanel.frame)*1.5+lrcPanel.frame.origin.y);
    lrcPanel.layer.anchorPoint=CGPointMake(0.5, 1.5);
//    CABasicAnimation *ani=[CABasicAnimation animationWithKeyPath:@"transform"];
//    [ani setFillMode:kCAFillModeBoth];
//    [ani setRemovedOnCompletion:YES];
//    [ani setDelegate:self];
//    [ani setDuration:0.5];
//    [ani setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(angleToRadian(-90), 0, 0, 1)]];
//    [lrcPanel.layer addAnimation:ani forKey:@"lrcPanel"];
//    
//    CABasicAnimation *listPanelAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
//    [listPanelAnimation setFillMode:kCAFillModeBoth];
//    [listPanelAnimation setRemovedOnCompletion:YES];
//    [listPanelAnimation setDuration:0.5];
//    [listPanelAnimation setDelegate:self];
//    [listPanelAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(angleToRadian(0), 0, 0, 1)]];
//    [listPanel.layer addAnimation:listPanelAnimation forKey:@"lrcPanel"];
    [UIView animateWithDuration:0.7 animations:^{
        listPanel.transform=CGAffineTransformMakeRotation(angleToRadian(0));
        lrcPanel.transform=CGAffineTransformMakeRotation(angleToRadian(-90));
    } completion:^(BOOL finished) {
        listPanel.layer.position=CGPointMake(0, 30);
        listPanel.layer.anchorPoint=CGPointMake(0, 0);
    }];
}
-(void)showLrcPanel
{
    listPanel.layer.position=CGPointMake(CGRectGetWidth(listPanel.frame)/2, CGRectGetHeight(listPanel.frame)*1.5+listPanel.frame.origin.y);
    listPanel.layer.anchorPoint=CGPointMake(0.5, 1.5);
//    lrcPanel.layer.position=CGPointMake(CGRectGetWidth(lrcPanel.frame)/2, CGRectGetHeight(lrcPanel.frame)*1.5+lrcPanel.frame.origin.y);
//    lrcPanel.layer.anchorPoint=CGPointMake(0.5, 1.5);
//    CABasicAnimation *ani=[CABasicAnimation animationWithKeyPath:@"transform"];
////    ani.tag=12;
//    [ani setFillMode:kCAFillModeBoth];
//    [ani setRemovedOnCompletion:NO];
//    [ani setDuration:0.5];
//    [ani setDelegate:self];
//    [ani setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(angleToRadian(0), 0, 0, 1)]];
//    [lrcPanel.layer addAnimation:ani forKey:@"lrcPanel"];
//    
//    
//    
//    CABasicAnimation *listPanelAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
////    listPanelAnimation.tag=13;
//    [listPanelAnimation setFillMode:kCAFillModeBoth];
//    [listPanelAnimation setRemovedOnCompletion:NO];
//    [listPanelAnimation setDuration:0.5];
//    [listPanelAnimation setDelegate:self];
//    [listPanelAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(angleToRadian(90), 0, 0, 1)]];
//    [listPanel.layer addAnimation:listPanelAnimation forKey:@"lrcPanel"];
    [UIView animateWithDuration:0.7 animations:^{
        listPanel.transform=CGAffineTransformMakeRotation(angleToRadian(90));
        lrcPanel.transform=CGAffineTransformMakeRotation(angleToRadian(0));
    } completion:^(BOOL finished) {
        lrcPanel.layer.position=CGPointMake(0, 30);
        lrcPanel.layer.anchorPoint=CGPointMake(0, 0);
    }];
   
}
-(void)lrcTest:(id)sender
{
//    CATransform3D transform=lrcPanel.layer.transform;//CATransform3DMakeRotation(angleToRadian(90), 0, 0, 1);
    
    [self showListPanel];

    
}

- (IBAction)lrcTest1:(id)sender {
    [self showLrcPanel];
}
@end
