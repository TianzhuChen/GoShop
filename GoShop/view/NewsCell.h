//
//  NewsCell.h
//  GoShop
//
//  Created by iwinad2 on 13-6-26.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsWeiboData.h"
#import "UIImageView+WebCache.h"


@interface NewsCell : UITableViewCell
{
    UIImageView *userProfileImage;
    UILabel *userScreenNameLabel;
//    UILabel *userWeiboContent;
    __weak NewsWeiboData *weiboData;
    CGRect userWeiboContentRect;
    CGRect userScreenNameRect;
    CGRect userWeiboTimeRect;
}
//-(void)showAnimation;
//-(void)hideAnimation;
-(void)showWeibo:(NewsWeiboData *)data;
+(CGFloat)getCellHeight:(NewsWeiboData *)data;//根据内容获取cell的高度
@end
