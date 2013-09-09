//
//  AudioControlPanel.h
//  GoShop
//
//  Created by iwinad2 on 13-7-16.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface ControlPanel : UIView{
    UIButton *pauseButton;
    float progress;
}
@property (nonatomic,weak) AudioPlayer *audioPlay;
-(void)updatePlayProgressView:(float)progress_;
@end
