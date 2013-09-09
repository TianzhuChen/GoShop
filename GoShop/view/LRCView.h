//
//  LRCView.h
//  GoShop
//
//  Created by iwinad2 on 13-8-16.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Help.h"

@protocol LRCViewDelegate;
@interface LRCView : UIView<UIScrollViewDelegate>{
    UIScrollView *lrcScrollView;
    
    NSString *lrcSource;//歌词内容，解析完以后回清除掉
    NSArray *lrcContents;//解析后的歌词
    NSArray *lrcPositions; //每行歌词居中时，contentoffset的偏移位置
    
    NSArray *dragPositionNodes;//拖动位置判断
    float minPosition;//最小拖动节点
    float maxPosition;//最大拖动节点
    NSArray *lrcLineLabels;//存储每行歌词的label
    
    BOOL enableUpdate;//可以更新歌词显示通过时间
   
    int currentLrcIndex; //当前播放到多少行了，对应lrcContents
    int totalLrcLines;//总共多少行歌词
    
    UILabel *timeLabel;//拖动时的时间显示
    int dragLrcIndex;//拖动歌词时的行位置
    
    float halfHeight;//高度一半
}
@property (nonatomic) id<LRCViewDelegate> lrcDelegate;
@property (nonatomic) BOOL enableScroll;
@property (nonatomic) UIColor *lrcNormalColor;
@property (nonatomic) UIColor *lrcFocusColor;
@property (nonatomic) float lrcLineGap;//每行歌词的间距
@property (nonatomic) UIFont *lrcFont;//歌词字体
@property (nonatomic) UIImageView *maskImage;//歌词遮罩
@property (nonatomic) UIImageView *lineImage;//拖动歌词时显示的中间线
//显示歌词
-(void)displayLrcWithUrl:(NSString *)url;
-(void)displayLrcWithSource:(NSString *)source;
//滚动到指定的时间
-(void)scrollToDuration:(NSTimeInterval)duration;
//更新歌词
-(void)updateLrcByTime:(NSTimeInterval)duration;
//-(void)moveToLrcWithIndex:(int)index;
@end

@protocol LRCViewDelegate <NSObject>
@optional
-(void)dragLrcDidEnd:(NSTimeInterval)duration;//拖动歌词结束
-(void)dragLrcDidBegin;//开始拖动歌词
@end
