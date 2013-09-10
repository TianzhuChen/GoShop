//
//  LoginView.m
//  GoShop
//
//  Created by iwinad2 on 13-7-10.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "LoginView.h"
#import <QuartzCore/QuartzCore.h>
#import "Help.h"

#define loginButton_radius 66
#define border_width 1.5
#define textfiled_error_borderColor [UIColor redColor].CGColor
#define textfiled_input_borderColor [UIColor cyanColor].CGColor

@implementation LoginView
@synthesize accountControl;

@synthesize loginBackgroundColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor=[UIColor grayColor];
//        self.layer.cornerRadius=cell_cornerRadius;
        accountControl=[AccountControl sharedAccount];
        defaultFrame=frame;
    }
    return self;
}
bool havedInitUI=false;
#pragma  mark 准备ui
-(void)initUI{
    havedInitUI=true;
    
    //用户头像
    CGFloat tAngle=60;
    CGFloat tRadius=33;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(66, 72), NO, 0);
    CGContextRef faceRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(faceRef,loginBackgroundColor.CGColor);
    CGContextAddEllipseInRect(faceRef, CGRectMake(0, 0, 66, 66));
    CGContextFillPath(faceRef);
    CGPoint startP=CGPointMake(tRadius-tRadius*cosf(angleToRadian(tAngle)),
                               tRadius+tRadius*sinf(angleToRadian(tAngle)));
    CGPoint controlP=CGPointMake(tRadius,tRadius/sinf(angleToRadian(tAngle))+tRadius);
    CGPoint endP=CGPointMake(tRadius+tRadius*cosf(angleToRadian(tAngle)),
                             tRadius+tRadius*sinf(angleToRadian(tAngle)));
    CGContextMoveToPoint(faceRef,startP.x,startP.y);
    CGContextAddLineToPoint(faceRef, controlP.x, controlP.y);
    CGContextAddLineToPoint(faceRef, endP.x, endP.y);
    //        CGContextAddQuadCurveToPoint(faceRef,controlP.x-5,controlP.y-20,controlP.x,controlP.y);
    
    //        CGContextMoveToPoint(faceRef,endP.x,endP.y);
    //        CGContextAddQuadCurveToPoint(faceRef, controlP.x+5,controlP.y-20, endP.x,endP.y);
    //        NSLog(@"sP>>%@||cP>>%@||eP>>%@",NSStringFromCGPoint(startP),NSStringFromCGPoint(controlP),NSStringFromCGPoint(endP))    ;
    CGContextFillPath(faceRef);
    UIImage *faceImg=UIGraphicsGetImageFromCurrentImageContext();

    
    UIImageView *faceBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 66, 72)];
    faceBg.backgroundColor=[UIColor clearColor];
    faceBg.image=faceImg;
    faceBg.center=CGPointMake(self.center.x, -CGRectGetHeight(faceBg.frame)/2-15);
    [self addSubview:faceBg];
    
    userFace=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
    userFace.center=CGPointMake(faceBg.center.x, faceBg.center.y-3);
    userFace.backgroundColor=[UIColor clearColor];
    userFace.image=[UIImage imageNamed:@"userFace"];
    userFace.layer.masksToBounds=YES;
    userFace.layer.cornerRadius=30.0;
    
    [self addSubview:userFace];
    
    //登录框
    UIImageView *inputBgImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 150)];
    inputBgImg.image=[Theme getImageWithColor:loginBackgroundColor size:CGSizeMake(310, 150)];
    [self addSubview:inputBgImg];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(2, 3, cell_width-4, 40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:23];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.text=@"Login";
    [self addSubview:label];
    
    UIView *userLeftV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    userLeftV.backgroundColor=[UIColor clearColor];
    
    userTextfield=[[UITextField alloc] initWithFrame:(CGRect){2,54,cell_width-4,45}];
    userTextfield.backgroundColor=[UIColor whiteColor];
    userTextfield.leftViewMode=UITextFieldViewModeAlways;
    userTextfield.leftView=userLeftV;
    userTextfield.layer.cornerRadius=cell_cornerRadius*0.5;
    userTextfield.layer.borderColor=textfiled_input_borderColor;
    userTextfield.placeholder=@"Username";
    userTextfield.delegate=self;
    userTextfield.tag=10;
    userTextfield.layer.cornerRadius=2;
    
    userTextfield.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self addSubview:userTextfield];
    
    UIView *passwordLeftV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    passwordLeftV.backgroundColor=[UIColor clearColor];
    
    passwordTextfield=[[UITextField alloc] initWithFrame:(CGRect){2,CGRectGetMaxY(userTextfield.frame)+4,cell_width-4,45}];
    passwordTextfield.placeholder=@"Password";
    passwordTextfield.backgroundColor=[UIColor whiteColor];
    passwordTextfield.secureTextEntry=YES;
    passwordTextfield.leftViewMode=UITextFieldViewModeAlways;
    passwordTextfield.leftView=passwordLeftV;
    passwordTextfield.layer.cornerRadius=cell_cornerRadius*0.5;
    passwordTextfield.delegate=self;
    passwordTextfield.tag=11;
    passwordTextfield.layer.borderColor=textfiled_input_borderColor;
    passwordTextfield.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    passwordTextfield.layer.cornerRadius=2;
    [self addSubview:passwordTextfield];
    
    
    
    //登录按钮
    loginButton=[[UIButton alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(inputBgImg.frame)+15, loginButton_radius, loginButton_radius)];
    loginButton.tag=9;
    loginButton.backgroundColor=[UIColor clearColor];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.textColor=[UIColor whiteColor];
    loginButton.titleLabel.font=[UIFont boldSystemFontOfSize:19];
    [loginButton setTitle:@"GO" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[Theme getCircleImageWithColor:loginBackgroundColor diameter:loginButton_radius] forState:UIControlStateNormal];
    loginButton.center=CGPointMake(self.center.x, loginButton.center.y);
    [self addSubview:loginButton];
//    userFace=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userHeader@2x"]];
//    userFace.center=CGPointMake(self.center.x, -CGRectGetHeight(userFace.frame)/2-15);
//    userFace.frame=CGRectInset(userFace.frame, 20, 20);
//    [self addSubview:userFace];
    
    UIButton *sinaButton=[[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(loginButton.frame)+30, loginButton_radius, loginButton_radius)];
    sinaButton.tag=10;
    [sinaButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [sinaButton setBackgroundImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
    [self addSubview:sinaButton];
    
    UIButton *tecentButton=[[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(loginButton.frame)+30, loginButton_radius, loginButton_radius)];
    [tecentButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [tecentButton setBackgroundImage:[UIImage imageNamed:@"whatsapp"] forState:UIControlStateNormal];
    [self addSubview:tecentButton];
    tecentButton.center=CGPointMake(CGRectGetWidth(self.frame)/2, tecentButton.center.y);
    
    UIButton *baiduButton=[[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginButton.frame)+30, loginButton_radius, loginButton_radius)];
    [baiduButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [baiduButton setBackgroundImage:[UIImage imageNamed:@"skype"] forState:UIControlStateNormal];
    [self addSubview:baiduButton];
    baiduButton.center=CGPointMake(CGRectGetWidth(self.frame)-loginButton_radius/2-5, baiduButton.center.y);
}
-(void)login:(UIButton *)sender
{
    NSLog(@"登陆");
    if(sender.tag==9)
    {
        if([self checkUserInput])
        {
            [UIView animateWithDuration:0.5 animations:^(void){
                CATransform3D transform=CATransform3DMakeRotation(angleToRadian(180), 1.0, 0.0, 0.0);
                userTextfield.layer.transform=transform;
                passwordTextfield.layer.transform=transform;
                
            } completion:^(BOOL finished){
                userTextfield.enabled=NO;
                passwordTextfield.enabled=NO;
            }];
        }
    }else if(sender.tag==10)
    {
        [accountControl loginWithAccountType:kAccountTypeSina];
    }

//    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(update) userInfo:nil repeats:YES];
//    [timer fire];
}
-(BOOL)checkUserInput{
    BOOL tIsSuccess=YES;
    if(userTextfield.text.length<2){
        userTextfield.layer.borderWidth=border_width;
        userTextfield.layer.borderColor=textfiled_error_borderColor;
        tIsSuccess=NO;
    }else{
        NSString *userRegx=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
        NSPredicate *userNamePredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",userRegx];
        if([userNamePredicate evaluateWithObject:userTextfield.text]){
            userTextfield.layer.borderWidth=border_width;
            userTextfield.layer.borderColor=textfiled_input_borderColor;
        }else{
            userTextfield.layer.borderWidth=border_width;
            userTextfield.layer.borderColor=textfiled_error_borderColor;
            tIsSuccess=NO;
        }
    }
    if(passwordTextfield.text.length<6){
        passwordTextfield.layer.borderWidth=border_width;
        passwordTextfield.layer.borderColor=textfiled_error_borderColor;
        tIsSuccess=NO;
    }else{
        NSString *passwordRegx=@"^[0-9]*$";
        NSPredicate *passwordPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegx];
        if([passwordPredicate evaluateWithObject:passwordTextfield.text]){
            passwordTextfield.layer.borderWidth=border_width;
            passwordTextfield.layer.borderColor=textfiled_input_borderColor;
        }else{
            passwordTextfield.layer.borderWidth=border_width;
            passwordTextfield.layer.borderColor=textfiled_error_borderColor;
            tIsSuccess=NO;
        }
    }
    return tIsSuccess;
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    
    if(newWindow)
    {
       if(!havedInitUI)
       {
           [self initUI];
       }
    }
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if(![super pointInside:point withEvent:event]){
        if(CGRectContainsPoint(loginButton.frame, point)){
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth=1.5;
//    textField.layer.shadowColor=[UIColor blueColor].CGColor;
//    textField.layer.shadowRadius=5.0;
//    textField.layer.shadowOpacity=0.8;
//    textField.layer.shadowOffset=CGSizeMake(0, 15);
    if(textField.tag==10){
        if(passwordTextfield.text.length>8){
            textField.returnKeyType=UIReturnKeyDone;
        }else{
            textField.returnKeyType=UIReturnKeyNext;
        }
    }else if(textField.tag==11){
        if(userTextfield.text.length>0){
            textField.returnKeyType=UIReturnKeyDone;
        }else{
            textField.returnKeyType=UIReturnKeyNext;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderWidth=0;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType==UIReturnKeyNext){
        if(textField.tag==10){
           return  [passwordTextfield becomeFirstResponder];
        }else{
           return [userTextfield becomeFirstResponder];
        }
    }else if(textField.returnKeyType==UIReturnKeyJoin){
        NSLog(@"登陆");
        return [textField resignFirstResponder];
    }
    return [textField resignFirstResponder];
}
-(void)keyboardWillShow:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if(CGRectGetMaxY(defaultFrame)+kbSize.height>=CGRectGetHeight(self.superview.frame)){
        [UIView animateWithDuration:0.5f animations:^(void){
            self.frame=CGRectOffset(defaultFrame, 0, -((CGRectGetMaxY(defaultFrame)+kbSize.height)-CGRectGetHeight(self.superview.frame))-10);
        }];
    }
}
-(void)keyboardWillHide:(NSNotification *) notification{
    [UIView animateWithDuration:0.3f animations:^(void){
        self.frame=defaultFrame;
    }];
}
@end
