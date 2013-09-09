//
//  DataManager.h
//  GoShop
//
//  Created by iwinad2 on 13-8-22.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountControl.h"

@interface DataManager : NSObject
@property (nonatomic) AccountControl *accountControl;
+(id)sharedManager;
-(void)clearData;
@end
