//
//  GoodViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-6-25.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "GoodViewController.h"
#import "AccountViewController.h"

@interface GoodViewController ()

@end

@implementation GoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleView=[Theme getTitleViewWithTitle:@"Good News" withBackgroundColor:[Theme getRandomColor]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SwitchControllerBaseDelegate
-(SwitchControllerBase *)switchControllerOfNext:(SwitchMoveInfo)moveInfo{
    AccountViewController *account=[[ViewControllerManager sharedInstance] checkCacheController:[AccountViewController class]];
    if(!account){
        account=[[AccountViewController alloc] initWithClassName];
        [[ViewControllerManager sharedInstance] addControllerToCaches:account];
    }
    //[[AccountViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    account.horizontalPreviousController=self;
    return account;
}
-(void)switchNextStart:(SwitchMoveInfo)moveInfo{
}
-(void)switchNextCompleted:(SwitchMoveInfo)moveInfo{
    [ViewControllerManager sharedInstance].currentController=self.horizontalNextController;
}
-(void)switchNextCancelled:(SwitchMoveInfo)moveInfo{
}
-(void)switchPreviousCompleted:(SwitchMoveInfo)moveInfo{
    [ViewControllerManager sharedInstance].currentController=self.horizontalPreviousController;
}
@end
