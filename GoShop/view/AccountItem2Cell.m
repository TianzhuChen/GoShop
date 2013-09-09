//
//  AccountItem2Cell.m
//  GoShop
//
//  Created by iwinad2 on 13-6-27.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "AccountItem2Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "Theme.h"



@implementation AccountItem2Cell
@synthesize table;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code 
        table=[[UITableView alloc] initWithFrame:CGRectMake(5, 0, 310,[AccountItem2Cell getCellHeight]-cell_gap)
                                               style:UITableViewStylePlain];
        table.delegate=self;
        table.dataSource=self;
        table.scrollEnabled=NO;
        table.backgroundColor=[UIColor clearColor];
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:table];
        UIView *v=[[UIView alloc] initWithFrame:table.frame];
        v.backgroundColor=[Theme getNavigationBarBackgroundColor:1];//[UIColor colorWithRed:17.0f/255.0f green:148.0f/255.0f blue:153.0f/255.0f alpha:1.0];
        v.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        v.layer.cornerRadius=cell_cornerRadius;
        table.backgroundView=v;
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CGFloat)getCellHeight{
    return 250+cell_gap;
}
#pragma mark UITableView delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"cellIdentifier";
    UITableViewCell *cell=[table dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(310, 2), NO, 0);
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        float lengths[]={10,10};
        
        CGContextSetLineDash(context, 0, lengths, 2);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 310, 0);
        CGContextStrokePath(context);
        CGContextClosePath(context);
        
        UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
        
        UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 310, 2)];
        lineImage.image=image;
        lineImage.tag=10;
        [cell addSubview:lineImage];
    
    }
    cell.backgroundView=nil;
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
    if(indexPath.row==4){
        [[cell viewWithTag:10] removeFromSuperview];
    }
    return cell;
}
@end
