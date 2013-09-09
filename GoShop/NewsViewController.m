//
//  ViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "NewsViewController.h"
#import "WeiboViewController.h"
#import "MenuView.h"
#import "AppDelegate.h"
#import "NewsCell.h"

@interface NewsViewController (){
  
}

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.controllerTag=menuItemIndexNew;
//    [self setBarLeftItem:[UIImage imageNamed:@"menu"]];
    self.titleView=[Theme getTitleViewWithTitle:@"New"
                            withBackgroundColor:[Theme getNavigationBarBackgroundColor:0]];
    
    if(!tableDelegate)
    {
        tableDelegate=[[NewsTableDelegate alloc] init];
        tableDelegate.newsController=self;
        [tableDelegate listenerData];
    }
    
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self resetViewFrameByTitleview:self.tableView];
    
    if(!dataControl)
    {
        dataControl=[[NewsControl alloc] init];
        [dataControl addObserver:self
                      forKeyPath:@"weiboData"
                         options:NSKeyValueObservingOptionNew
                         context:NULL];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [dataControl updateWeiboData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if([keyPath isEqualToString:@"weiboData"])
    {
        [self.tableView reloadData];
//        NSLog(@"weibodata>>>>%@",newsController.weiboControl.friendsWeibos);
    }
}
#pragma mark SwitchControllerBaseDelegate
-(SwitchControllerBase *)switchControllerOfNext:(SwitchMoveInfo)moveInfo{
    
    WeiboViewController  *shop=[[ViewControllerManager sharedInstance] checkCacheController:[WeiboViewController class]];
    if(!shop){
        shop=[[WeiboViewController alloc] initWithClassName];
        [[ViewControllerManager sharedInstance] addControllerToCaches:shop];
    }
    shop.horizontalPreviousController=self;
    return shop;
}
-(void)switchNextStart:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=NO;
}
-(void)switchNextCompleted:(SwitchMoveInfo)moveInfo{
    [ViewControllerManager sharedInstance].currentController=self.horizontalNextController;
//    self.tableView.scrollEnabled=YES;
}
-(void)switchNextCancelled:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=YES;
}
-(void)switchPreviousCompleted:(SwitchMoveInfo)moveInfo{
    [ViewControllerManager sharedInstance].currentController=self.horizontalPreviousController;
}
#pragma mark UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataControl.weiboData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [NewsCell getCellHeight:dataControl.weiboData[indexPath.row]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"newsCell";
    NewsCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell showWeibo:dataControl.weiboData[indexPath.row]];
    return cell;
}
#pragma mark -
-(void)dealloc
{
    [dataControl removeObserver:self
                     forKeyPath:@"weiboData"
                        context:NULL];
}

@end
