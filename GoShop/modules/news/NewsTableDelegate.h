//
//  NewsTableDelegate.h
//  GoShop
//
//  Created by iwinad2 on 13-9-3.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCell.h"
#import "CTZUITableView.h"

@class NewsViewController;
@interface NewsTableDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>
{
}
@property (weak,nonatomic) NewsViewController *newsController;
-(void)listenerData;
@end
