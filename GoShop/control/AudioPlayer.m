//
//  AudioPlayer.m
//  GoShop
//
//  Created by iwinad2 on 13-7-16.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer
-(void)prepareToPlayWithProgress:(PlayProgress)progressBlock{
    _progressBlock=[progressBlock copy];
    _isStop=YES;
}
#pragma mark 播放音乐（本地/网络）
-(void)playByUrl:(NSString *)url{
    _isStop=NO;
    if([url hasPrefix:@"http://"]){
        isLocal=NO;
        audioStreamer=[[AudioStreamer alloc] initWithURL:[NSURL URLWithString:url]];
        if(![audioStreamer isPlaying]){
            [audioStreamer start];
        }
    }else{
        isLocal=YES;
        audioLocalPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:url] error:nil];
        [audioLocalPlayer play];
    }
    if(!updateTimer){
        NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(updateProgress)]];
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        if(_progressBlock){
            updateTimer=[NSTimer scheduledTimerWithTimeInterval:0.1
                                                     invocation:invocation
                                                        repeats:YES];
        }
    }
    if(!updateTimer.isValid){
        [updateTimer fire];
    }
}
-(void)stop{
    _isStop=YES;
}
-(void)pause{
    if(isLocal){
        if([audioLocalPlayer isPlaying]){
            [audioLocalPlayer pause];
        }
    }else{
        if([audioStreamer isPlaying]){
            [audioStreamer pause];
        }
    }
};
-(void)resume{
    if(isLocal){
        if(![audioLocalPlayer isPlaying]){
            [audioLocalPlayer play];
        }
    }else{
        if(![audioStreamer isPlaying]){
            [audioStreamer start];
        }
    }
}
-(void)seekToDuration:(NSTimeInterval)duration{
    if(isLocal)
    {
        audioLocalPlayer.currentTime=duration;
    }else
    {
        [audioStreamer seekToTime:duration];
    }
//    audioLocalPlaye
}
#pragma mark -
float _progress;
-(void)updateProgress{
    if(_progress==1.0)
    {
        return;
    }
    if(isLocal)
    {
        if(audioLocalPlayer.duration<=0.5)
        {
            _progress=0;
        }else
        {
            _progress=audioLocalPlayer.currentTime/audioLocalPlayer.duration;
            
        }
    }else
    {
        if(audioStreamer.duration<=0.5)
        {
            _progress=0;
        }else
        {
            _progress=audioStreamer.progress/audioStreamer.duration;
        }
    }
    if(_progress>0.99)
    {
        _progress=1.0;
    }
    _progressBlock(_progress);
}
-(BOOL)getIsPlaying{
    if(isLocal){
        return [audioLocalPlayer isPlaying];
    }else{
        return [audioStreamer isPlaying];
    }
}
-(NSTimeInterval)getDuration{
    if(isLocal){
        return audioLocalPlayer.duration;
    }else{
        return audioStreamer.duration;
    }
}
-(NSTimeInterval)getTime{
    if(isLocal)
    {
        return  audioLocalPlayer.currentTime;
    }else
    {
        return [audioStreamer.currentTime doubleValue];
    }
}
@end
