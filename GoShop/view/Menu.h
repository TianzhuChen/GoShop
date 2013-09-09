//
//  Menu.h
//  GoShop
//
//  Created by iwinad2 on 13-6-24.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuView.h"
#import "Global.h"

@interface Menu : NSObject<UIGestureRecognizerDelegate>
-(id)initMenuWithDelegate:(id<MenuViewDelegate>)delegate;
-(void)show;
@property (nonatomic,strong,readonly) MenuView *menuView;
@end
