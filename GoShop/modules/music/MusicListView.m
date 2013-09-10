//
//  MusicList.m
//  GoShop
//
//  Created by iwinad2 on 13-8-21.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "MusicListView.h"

@implementation MusicListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        table=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        table.delegate=self;
        table.dataSource=self;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
