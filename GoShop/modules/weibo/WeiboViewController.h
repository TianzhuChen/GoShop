//
//  testViewController.h
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchControllerBase.h"
#import "CTZUITableView.h"


@interface WeiboViewController : SwitchControllerBase<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet CTZUITableView *tableView;

@end
