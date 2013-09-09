//
//  NewsTableDelegate.m
//  GoShop
//
//  Created by iwinad2 on 13-9-3.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "NewsTableDelegate.h"
#import "NewsViewController.h"

@class NewsViewController;
@implementation NewsTableDelegate
@synthesize newsController;
-(void)listenerData
{
    [newsController.weiboControl addObserver:self
                                  forKeyPath:@"friendsWeibos"
                                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                     context:NULL];
}
#pragma mark UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"index>>>%d",indexPath.row);
    return 100+arc4random()%100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"cell>>>%d",indexPath.row);
    static NSString *identifier=@"newsCell";
    NewsCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
#pragma mark KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"friendsWeibos"])
    {
        NSLog(@"weibodata>>>>%@",newsController.weiboControl.friendsWeibos);
    }
}
#pragma mark -
-(void)dealloc
{
    [newsController.weiboControl removeObserver:self forKeyPath:@"friendsWeibos"];
}
@end
