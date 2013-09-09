//
//  ViewController.h
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchControllerBase.h"
#import "CTZUITableView.h"
#import "SinaWeiboControl.h"
#import "AccountControl.h"
#import "NewsTableDelegate.h"
#import "NewsControl.h"

//显示关注用户的最新微博信息
@interface NewsViewController : SwitchControllerBase<UITableViewDataSource,UITableViewDelegate>
{
    NewsTableDelegate *tableDelegate;
    NewsControl *dataControl;
}
@property (weak, nonatomic) IBOutlet CTZUITableView *tableView;
@property (nonatomic,readonly) WeiboBase *weiboControl;
@end
