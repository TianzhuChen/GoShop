//
//  NewsViewController.h
//  GoShop
//
//  Created by iwinad2 on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchControllerBase.h"
#import "LoginView.h"
#import "AccountControl.h"

@interface AccountViewController : SwitchControllerBase{
    LoginView *loginView;
    AccountControl *accountControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
