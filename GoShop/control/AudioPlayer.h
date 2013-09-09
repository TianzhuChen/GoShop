//
//  AudioPlayer.h
//  GoShop
//
//  Created by iwinad2 on 13-7-16.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioStreamer.h"
#import <AVFoundation/AVFoundation.h>

typedef void (^PlayProgress)(float progress);
@interface AudioPlayer : NSObject{
    PlayProgress _progressBlock;
    AudioStreamer *audioStreamer;
    AVAudioPlayer *audioLocalPlayer;
    NSTimer *updateTimer;
    BOOL isLocal;
}
//是否在播放
@property (nonatomic,readonly,getter = getIsPlaying) BOOL isPlaying;
@property (nonatomic,readonly) BOOL isStop;
@property (nonatomic,readonly,getter = getDuration) NSTimeInterval duration;
@property (nonatomic,readonly,getter = getTime) NSTimeInterval currentTime;
@property (nonatomic) float volume;
//播放准备，更新进度
-(void)prepareToPlayWithProgress:(PlayProgress)progressBlock;
//播放音乐（本地/网络）
-(void)playByUrl:(NSString *)url;
-(void)seekToDuration:(NSTimeInterval)duration;
-(void)stop;
-(void)resume;
-(void)pause;

@end
