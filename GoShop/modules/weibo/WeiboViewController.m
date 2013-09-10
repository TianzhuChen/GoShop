//
//  testViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "WeiboViewController.h"
#import "GoodViewController.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController

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
    self.titleView=[Theme getTitleViewWithTitle:@"Shop" withBackgroundColor:[Theme getRandomColor]];
    [self resetViewFrameByTitleview:self.tableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SwitchControllerBaseDelegate
-(SwitchControllerBase *)switchControllerOfNext:(SwitchMoveInfo)moveInfo{
    GoodViewController *account=[[ViewControllerManager sharedInstance] checkCacheController:[GoodViewController class]];
    if(!account){
        account=[[GoodViewController alloc] initWithClassName];
        [[ViewControllerManager sharedInstance] addControllerToCaches:account];
    }
    account.horizontalPreviousController=self;
    return account;
}
//-(void)switchNextStart:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=NO;
//}
//-(void)switchNextCompleted:(SwitchMoveInfo)moveInfo{
//    [ViewControllerManager sharedInstance].currentController=self.horizontalNextController;
//    self.tableView.scrollEnabled=YES;
//}
//-(void)switchNextCancelled:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=YES;
//}
//
//-(void)switchPreviousStart:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=NO;
//}
//-(void)switchPreviousCompleted:(SwitchMoveInfo)moveInfo{
//    [ViewControllerManager sharedInstance].currentController=self.horizontalPreviousController;
//    self.tableView.scrollEnabled=YES;
//}
//-(void)switchPreviousCancelled:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=YES;
//}
#pragma mark UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
