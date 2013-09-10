//
//  NewsWeiboData.h
//  GoShop
//
//  Created by iwinad2 on 13-9-6.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "DataBase.h"
#import <CoreText/CoreText.h>
#import "RegexKitLite.h"

static CGFloat const contentYoffset=10;//微博内容初始位置10+20+20+5
static CGFloat const contentBottomEdge=4;//微博内容底边距
static CGFloat const contentXoffset=10;

#pragma mark 图片插入数据字典key
static NSString *const keyFaceImageWidth=@"width";
static NSString *const keyFaceImageHeight=@"height";
static NSString *const keyFaceImageDescent=@"descent";
static NSString *const keyFaceImageName=@"imageName";
static NSString *const keyFaceImageUrl=@"imageUrl";
static NSString *const keyFaceImageId=@"imageId";
static NSString *const keyFaceImageRect=@"imageFrame";
static NSString *const keyFaceImageRange=@"imageRange";

@interface NewsWeiboData : DataBase
{
    
}
@property (nonatomic,strong) NSString *screenName;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *weiboContent;
@property (nonatomic,strong) NSString *profileImageUrl;

//内容高度（可变部分）
@property (nonatomic) CGFloat contentHeight;
//是否有布局缓存
@property (nonatomic,readonly) BOOL haveCached;
//图文布局缓存
@property (nonatomic,readonly) CTFrameRef frameRefCache;
@property (nonatomic,readonly) NSArray *faceImages;
//-(void)updateWeiboContentToAttributedString;
-(void)updateFrameRefCache;
-(void)clearFrameRefCache;
@end
