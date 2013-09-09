//
//  NewsViewController.m
//  GoShop
//
//  Created by iwinad2 on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountItem1Cell.h"
#import "AccountItem2Cell.h"

@interface AccountViewController (){
   
}

@end

@implementation AccountViewController

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
    self.tableView.backgroundColor=[UIColor clearColor];
    self.titleView=[Theme getTitleViewWithTitle:@"Account" withBackgroundColor:[Theme getNavigationBarBackgroundColor:1]];
    [self resetViewFrameByTitleview:self.tableView];
    accountControl=[AccountControl sharedAccount];
    if([accountControl checkIsLogin]){
        
    }else{
       [self.tableView setHidden:YES];
        if(!loginView){
            loginView=[[LoginView alloc] initWithFrame:CGRectMake(cell_offsetX, 130, cell_width, 500)];
            loginView.loginBackgroundColor=[Theme getNavigationBarBackgroundColor:1];
        }
        loginView.backgroundColor=[UIColor clearColor];
       [self.view addSubview:loginView];
    }
//    NSLog(@"self.frmae>>>%@||%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.tableView.frame));
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 155;
    }else if(indexPath.row==1){
        return [AccountItem2Cell getCellHeight];
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"cellIdentifier";
    static NSString *identifier1=@"accountItem1Cell";
    static NSString *identifier2=@"accountItem2Cell";
    if(indexPath.row==0){
        AccountItem1Cell *cell1=[tableView dequeueReusableCellWithIdentifier:identifier1];
        if(!cell1){
            UINib *nib=[UINib nibWithNibName:@"AccountItem1Cell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier1];
            cell1=[tableView dequeueReusableCellWithIdentifier:identifier1];
        }
        cell1.bgView.backgroundColor=[Theme getNavigationBarBackgroundColor:1];
        return cell1;
    }else if(indexPath.row==1){
        AccountItem2Cell *cell=[tableView dequeueReusableCellWithIdentifier:identifier2];
        if(!cell){
            cell=[[AccountItem2Cell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:identifier2];
        }
//        cell.table.backgroundColor=[Theme getNavigationBarBackgroundColor:1];
        cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(5, 0, 310,47)];
            bgView.backgroundColor=[Theme getNavigationBarBackgroundColor:1];//[UIColor colorWithRed:17.0f/255.0f green:148.0f/255.0f blue:153.0f/255.0f alpha:1.0];
//            v.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            bgView.layer.cornerRadius=cell_cornerRadius;
            bgView.tag=10;
            [cell insertSubview:bgView atIndex:0];
            cell.backgroundColor=[UIColor clearColor];
            cell.backgroundView=nil;
            [cell.contentView removeFromSuperview];
        }
        cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
//        [cell viewWithTag:10].backgroundColor=[Theme getRandomColor];
        return cell;
    }
}
#pragma mark SwitchControllerBaseDelegate
//-(SwitchControllerBase *)switchControllerOfNext:(SwitchMoveInfo)moveInfo{
//
//}
-(void)switchNextStart:(SwitchMoveInfo)moveInfo{
    
}
-(void)switchNextCompleted:(SwitchMoveInfo)moveInfo{
    [ViewControllerManager sharedInstance].currentController=self.horizontalNextController;
}
-(void)switchNextCancelled:(SwitchMoveInfo)moveInfo{
    
}
-(SwitchControllerBase *)switchControllerOfPrevious:(SwitchMoveInfo)moveInfo{
    return nil;
}
-(void)switchPreviousStart:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=NO;
}
-(void)switchPreviousCompleted:(SwitchMoveInfo)moveInfo{
    [ViewControllerManager sharedInstance].currentController=self.horizontalPreviousController;
}
-(void)switchPreviousCancelled:(SwitchMoveInfo)moveInfo{
//    self.tableView.scrollEnabled=YES;
}
@end
