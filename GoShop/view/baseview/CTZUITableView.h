//
//  CTZUITableView.h
//  GoShop
//
//  Created by Tianzhu on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//手势遮挡
@interface CTZUITableView : UITableView{
    CGRect limitRect;
    UIWindow *window;
}

@end
