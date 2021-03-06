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
    __weak NewsWeiboData *weiboData;
    UIImageView *userProfileImage;
    CGRect userWeiboContentRect;
    CGRect userScreenNameRect;
    CGRect userWeiboTimeRect;
    BOOL canUpdate;
}
-(void)showWeibo:(NewsWeiboData *)data;
//更新下载cell当中的图片
-(void)updateCellImage;
+(CGFloat)getCellHeight:(NewsWeiboData *)data;//根据内容获取cell的高度
@end
