//
//  LoginView.h
//  GoShop
//
//  Created by iwinad2 on 13-7-10.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountControl.h"
#import "Theme.h"

@interface LoginView : UIView<UITextFieldDelegate>{
    UITextField *userTextfield;
    UITextField *passwordTextfield;
    CGRect defaultFrame;
    UIButton *loginButton;
    UIImageView *userFace;
    BOOL isUpdated;
}
@property (nonatomic) UIColor *loginBackgroundColor;
@property (nonatomic,weak) AccountControl *accountControl;
@end
