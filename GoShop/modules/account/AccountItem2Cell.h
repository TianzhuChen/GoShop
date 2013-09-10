//
//  AccountItem2Cell.h
//  GoShop
//
//  Created by iwinad2 on 13-6-27.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountItem2Cell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
+(CGFloat)getCellHeight;
@property (nonatomic,strong) UITableView *table;
@end
