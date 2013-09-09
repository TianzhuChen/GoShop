//
//  NewsWeiboData.m
//  GoShop
//
//  Created by iwinad2 on 13-9-6.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "NewsWeiboData.h"

@interface NewsWeiboData (){
    NSMutableArray *faceImageRangeArr;
}

@end
@implementation NewsWeiboData
@synthesize weiboContent,screenName,createTime,frameRefCache,contentHeight,faceImages;

static UIColor *weiboLinkColor;
static CGSize labelSize;
+(void)load
{
    labelSize=CGSizeMake(300, 10000);
    weiboLinkColor=[UIColor colorWithRed:0.000 green:0.763 blue:0.763 alpha:1.000];
}
-(void)updateWeiboContentToAttributedString
{
    
}

-(void)updateFrameRefCache
{
//    NSLog(@"uifon>>>%f",[UIFont systemFontOfSize:12].lineHeight);
    NSString *content=[NSString stringWithFormat:@"%@\n%@\n%@",screenName,createTime,weiboContent];
    contentHeight=[weiboContent sizeWithFont:[UIFont systemFontOfSize:12]
                           constrainedToSize:labelSize
                               lineBreakMode:NSLineBreakByWordWrapping].height;
    content=[self getFaceImage:content];
    
    //行缩进
    CGFloat screennameLineindentValue=45.0f;
    //行高
    CGFloat screennamelineHeightValue=20.f;
    
    CTParagraphStyleSetting seetings[]={
        getParagrafSeeting(&screennameLineindentValue, kCTParagraphStyleSpecifierFirstLineHeadIndent),
        getParagrafSeeting(&screennamelineHeightValue, kCTParagraphStyleSpecifierMinimumLineHeight)};
    CTParagraphStyleRef screennameLineParagraphStyle=CTParagraphStyleCreate(seetings, sizeof(seetings));
    
    //行间距
    CGFloat screenLineSpaceValue=5.0f;
    //第二行的样式设置
    CTParagraphStyleSetting seetings1[]={
        getParagrafSeeting(&screenLineSpaceValue, kCTParagraphStyleSpecifierLineSpacing)};
    CTParagraphStyleRef createtimeLineParagraphStyle=CTParagraphStyleCreate(seetings1, sizeof(seetings1));
    
    NSMutableAttributedString *createTimeAttributed=[[NSMutableAttributedString alloc] initWithString:content];
   //高亮标注内容中的微博账号名称
    NSRange range=[content rangeOfRegex:@"#.*#"];
    if(range.location!=NSNotFound)
    {
        [createTimeAttributed addAttribute:CFBridgingRelease(kCTForegroundColorAttributeName)
                                     value:weiboLinkColor
                                     range:range];
    }
    [createTimeAttributed addAttribute:CFBridgingRelease(kCTFontAttributeName)
                                 value:CFBridgingRelease(CTFontCreateWithName((__bridge CFTypeRef)([UIFont systemFontOfSize:12].fontName), 12, NULL))
                                 range:range];
    [createTimeAttributed addAttribute:CFBridgingRelease(kCTParagraphStyleAttributeName)
                                 value:(__bridge id)(screennameLineParagraphStyle)
                                 range:NSMakeRange(0, 1)];
    [createTimeAttributed addAttribute:CFBridgingRelease(kCTParagraphStyleAttributeName)
                                 value:CFBridgingRelease(screennameLineParagraphStyle)
                                 range:NSMakeRange(screenName.length+1, 1)];
    [createTimeAttributed addAttribute:CFBridgingRelease(kCTParagraphStyleAttributeName)
                                 value:CFBridgingRelease(createtimeLineParagraphStyle)
                                 range:NSMakeRange(screenName.length+1, 3)];
//    NSDictionary *dic=@{@"width":@20,@"height":@20,@"descent":@0};
    //设置表情图片的ctrun
    CTRunDelegateCallbacks delegateCallBacks=getCtrunDelegateCallback();
    for(NSDictionary *dic in faceImageRangeArr)
    {
        
        CTRunDelegateRef runDelegateRef=CTRunDelegateCreate(&delegateCallBacks, (__bridge void *)(dic));
        NSRange range;
        [[dic objectForKey:keyFaceImageRange] getValue:&range];
        [createTimeAttributed addAttribute:CFBridgingRelease(kCTRunDelegateAttributeName)
                                     value:CFBridgingRelease(runDelegateRef)
                                     range:range];
//        NSLog(@"contentsssss>>>%@",content);
    }
    
    
    CTFramesetterRef framesetter=CTFramesetterCreateWithAttributedString((__bridge CFTypeRef)(createTimeAttributed));
    CGSize size= CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(300, 2000), NULL );
//    NSLog(@"size.>>>>%@",NSStringFromCGSize(size));
    CGMutablePathRef path=CGPathCreateMutable();
    contentHeight=size.height;
    CGPathAddRect(path, NULL, CGRectMake(contentXoffset, -contentYoffset, 300,contentHeight+contentBottomEdge+contentYoffset));
    
    
    frameRefCache=CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    //计算表情图片的具体位置
    [self getFaceImageRect:frameRefCache];
    
    _haveCached=YES;
}
-(void)clearFrameRefCache
{
    _haveCached=NO;
    
    CFRelease(frameRefCache);
    frameRefCache=NULL;
    contentHeight=0;
}
//创建段落样式
CTParagraphStyleSetting getParagrafSeeting(const void* value,CTParagraphStyleSpecifier spec)
{
    CTParagraphStyleSetting paragrafSetting;
    paragrafSetting.spec=spec;
    paragrafSetting.value=value;
    paragrafSetting.valueSize=sizeof(float);
    return paragrafSetting;
}
#pragma mark CTRunCallBacks
//创建一个特定的ctrun回调
CTRunDelegateCallbacks getCtrunDelegateCallback()
{
    CTRunDelegateCallbacks delegateCallBacks;
    delegateCallBacks.getWidth=widthCallback;
    delegateCallBacks.getAscent=ascentCallback;
    delegateCallBacks.getDescent=descentCallback;
    delegateCallBacks.version=kCTRunDelegateVersion1;
    delegateCallBacks.dealloc=deallocCallback;
    return delegateCallBacks;
}
/*CTRunDelegateCallbacks Callbacks */
static void deallocCallback( void* ref ){
//    NSDictionary *dic=(__bridge NSDictionary *)ref;
//    dic=nil;
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:keyFaceImageHeight] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:keyFaceImageDescent] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:keyFaceImageWidth] floatValue];
}
#pragma mark -
#pragma mark 计算表情索引位置和具体位置
//计算表情图片索引位置
-(NSString *)getFaceImage:(NSString *)contents
{
    NSRange range=NSMakeRange(0, 0);
    //循环查找表情
    while (YES) {
//        range=[contents rangeOfRegex:@"\\[.{2}\\]"];
        range=[contents rangeOfRegex:@"\\[.{2}\\]" inRange:NSMakeRange(range.location+range.length, contents.length-range.location-range.length)];
        if(range.location!=NSNotFound)
        {
            if(!faceImageRangeArr)
            {
                faceImageRangeArr=[[NSMutableArray alloc] init];
            }
            range.length=range.length;
            contents=[contents stringByReplacingCharactersInRange:range withString:@" "];
            range.length=1;
            NSDictionary *dic=@{keyFaceImageWidth:@23,
                                keyFaceImageHeight:@23,
                                keyFaceImageDescent:@5,
                                keyFaceImageRange:[NSValue valueWithRange:range]};
            
            [faceImageRangeArr addObject:dic];
        }else
        {
            break;
        }
    }

    return contents;
}
//根据最终布局，计算表情图片绘制的具体位置
-(void)getFaceImageRect:(CTFrameRef)frameRef
{
    if(faceImageRangeArr.count>0)
    {
        NSArray *lines=(__bridge NSArray *)(CTFrameGetLines(frameRef));
        CGPoint origins[[lines count]];
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        NSUInteger lineIndex=0;
        NSUInteger imageIndex=0;
        NSUInteger imageNums=faceImageRangeArr.count;//需要填充的图片数量，从0开始
        for(id lineObj in lines)
        {
            if(imageIndex==imageNums)
            {
                break;
            }
            CTLineRef line=(__bridge CTLineRef)lineObj;
            for(id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line))
            {
                if(imageIndex==imageNums)
                {
                    break;
                }
                
                CTRunRef run=(__bridge CTRunRef)runObj;
                CFRange runRange = CTRunGetStringRange(run);
                
                NSDictionary *dic=[faceImageRangeArr objectAtIndex:imageIndex];
                NSRange imageRange;
                [[dic objectForKey:keyFaceImageRange] getValue:&imageRange];
                if(imageRange.location==runRange.location && imageRange.length==runRange.length)
                {//如果是图片Run
                    CGRect runBounds;
                    CGFloat ascent;//height above the baseline
                    CGFloat descent;//height below the baseline
                    //获取此分段的宽、高和上线偏移位置
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                    runBounds.size.height = ascent;// + descent;
                    
                    //当前行run的x偏移位置
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                    //发回的坐标，是左上角的，这个时候的坐标是，倒着话，左上角
                    runBounds.origin.x = contentXoffset+origins[lineIndex].x + xOffset ;
                    runBounds.origin.y = contentHeight- origins[lineIndex].y;
                    runBounds.origin.y += descent;
//                    NSLog(@"rund>>>>%@|||%ld||%ld",NSStringFromCGRect(runBounds),runRange.location,runRange.length);
                    NSDictionary *dic=@{keyFaceImageName: @"001.png",
                                        keyFaceImageRect:[NSValue valueWithCGRect:runBounds]};
                    [arr addObject:dic];
                    
                    imageIndex++;
                }
            }
            
//            NSLog(@"origins>>>>%f",origins[lineIndex].y);
            lineIndex++;
            
        }
//        NSLog(@"lines>>>%d",lineIndex);
        faceImages=[NSArray arrayWithArray:arr];
        [arr removeAllObjects];
        arr=nil;
    }
    [faceImageRangeArr removeAllObjects];
    faceImageRangeArr=nil;
}
@end
