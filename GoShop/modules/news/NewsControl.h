//
//  NewsControl.h
//  GoShop
//
//  Created by iwinad2 on 13-9-4.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "ControlBase.h"
#import "AccountControl.h"
#import "NewsWeiboData.h"

@interface NewsControl : ControlBase<NSURLConnectionDataDelegate>
@property(nonatomic,readonly)NSMutableArray *weiboData;
-(void)updateWeiboData;
@end
