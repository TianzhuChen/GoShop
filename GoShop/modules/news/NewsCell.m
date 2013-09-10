//
//  NewsCell.m
//  GoShop
//
//  Created by iwinad2 on 13-6-26.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "NewsCell.h"
#import "Theme.h"
#import <CoreText/CoreText.h>
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"

@implementation NewsCell

static UIImage *bgImage;//背景图片
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect tempF=self.frame;
        tempF.size.height=100;
        self.frame=tempF;
        

        if(!bgImage)
        {
            bgImage=[Theme getGridImageWithColor:[UIColor whiteColor] radius:2 borderWidth:0 borderColor:nil];
        }
        self.backgroundView=nil;

        
        
        userProfileImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        userProfileImage.backgroundColor=[UIColor greenColor];
        userProfileImage.autoresizingMask=UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:userProfileImage];
//        
//        userScreenNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userProfileImage.frame)+5, 10, 250, 20)];
//        userScreenNameLabel.font=[UIFont systemFontOfSize:12];
//        userScreenNameLabel.backgroundColor=[UIColor clearColor];
//        userScreenNameLabel.autoresizingMask=UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
//        
//        [self addSubview:userScreenNameLabel];
//        
//        userWeiboContentRect=CGRectMake(CGRectGetMinX(userProfileImage.frame),
//                                        CGRectGetMaxY(userProfileImage.frame)+5, CGRectGetWidth(self.frame)-CGRectGetMinX(userProfileImage.frame)*2,
//                                        CGRectGetHeight(self.frame)-CGRectGetMaxY(userProfileImage.frame)-5-5);
        
//        userWeiboContent=[[UILabel alloc] initWithFrame:userWeiboContentRect];
//        userWeiboContent.font=[UIFont systemFontOfSize:12];
//        userWeiboContent.numberOfLines=0;
//        userWeiboContent.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//        userWeiboContent.backgroundColor=[UIColor clearColor];
//        [self addSubview:userWeiboContent];
        
        canUpdate=YES;
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareForReuse
{
    canUpdate=YES;
}
-(void)showWeibo:(NewsWeiboData *)data
{
    weiboData=data;
//   [self setNeedsDisplay];
}
-(void)updateCellImage
{
    [userProfileImage setImageWithURL:[NSURL URLWithString:weiboData.profileImageUrl]];
    canUpdate=YES;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    [bgImage drawInRect:CGRectMake(5, 5, 310, CGRectGetHeight(self.frame)-5)
              blendMode:kCGBlendModeCopy
                  alpha:1.0];
    if(canUpdate)
    {
        if(![weiboData haveCached])
        {
            [weiboData updateFrameRefCache];
        }
        for(NSDictionary *dic in weiboData.faceImages)
        {
            
            UIImage *img=[UIImage imageNamed:[dic objectForKey:keyFaceImageName]];
            CGRect rect;
            NSValue *value=[dic objectForKey:keyFaceImageRect];
            [value getValue:&rect];
            [img drawInRect:rect];
            
        }
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        CTFrameDraw(weiboData.frameRefCache, context);
    }
}
+(CGFloat)getCellHeight:(NewsWeiboData *)data
{
//    if(labelSize.width<10)
//    {
//        labelSize=CGSizeMake(300, 10000);
//    }
//    NSString *str=data.weiboContent;
//    CGFloat h=[str sizeWithFont:[UIFont systemFontOfSize:12]
//               constrainedToSize:labelSize
//                   lineBreakMode:NSLineBreakByWordWrapping].height;
    return data.contentHeight+contentBottomEdge+contentYoffset;//+contentTopEdge+contentBottomEdge;
}

-(void)drawContentWithContext:(CGContextRef *)context
{
    
}
-(void)dealloc
{
    NSLog(@"dealloc");
}
@end
