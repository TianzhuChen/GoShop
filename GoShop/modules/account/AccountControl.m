//
//  AccountData.m
//  GoShop
//
//  Created by iwinad2 on 13-7-10.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "AccountControl.h"

NSString *const KeyLastloginAccountType=@"KeyLastloginAccountType";
NSString *const KeyUserHavedLogined=@"KeyUserHavedLogined";
NSString *const AccountSwitchWillFinishedNotification=@"accountSwitchWillFinishedNotification";

@interface AccountControl()
{
    WeiboBase *tempWeiboControl;
    Account_Type tempAccountType;
}

@end

@implementation AccountControl
@synthesize userLists,weiboControl;

+(AccountControl *)sharedAccount
{
    static AccountControl *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[AccountControl alloc] init];
    });
    return instance;
}
-(id)init{
    self=[super init];
    if(self)
    {
        weiboQueue=[[NSOperationQueue alloc] init];
    }
    return [super init];
}
#pragma mark 登录、注销、清除用户数据
-(void)loginWithName:(NSString *)name password:(NSString *)password
{
    _userName=name;
    _password=password;
    [self loginSuccess];
}
-(void)loginWithAccountType:(Account_Type)type{
    if(type==kAccountTypeDefault || type==kAccountTypeNone)//不用允许
    {
        ERROR_AND_STOP;
    }else if (type==_accountType)
    {
        return;
    }
    tempAccountType=type;
    if(type==kAccountTypeSina)
    {
//        if(!weiboControl)
//        {
//            weiboControl=[self getWeiboControl:[SinaWeiboControl class] tag:kAccountTypeSina];
//            //最新微博数据
////            [sinaWeiboControl addObserver:self
////                           forKeyPath:@"friendsWeibos"
////                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
////                              context:(void *)sinaWeiboControl.tag];
////                                  context:(__bridge_retained void *)[NSString stringWithFormat:@"sina"]];
////                              context:(__bridge void *)([SinaWeiboControl class])];
//        }
        tempWeiboControl=[self getWeiboControl:[SinaWeiboControl class] tag:kAccountTypeSina];
    }
    if(tempWeiboControl)
    {
        [tempWeiboControl login];
    }
    
}
-(void)logOut
{
    
}
-(void)clearUserData
{
    
}
-(WeiboBase *)getCurrentLoginWeibo
{
    return weiboControl;
}

-(BOOL)checkIsLogin
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _isLogined=[defaults boolForKey:KeyUserHavedLogined];
    if([defaults integerForKey:KeyLastloginAccountType])
    {
        _accountType=[defaults integerForKey:KeyLastloginAccountType];
    }
    if(_isLogined)
    {
        if(_accountType ==kAccountTypeNone)
        {
            _isLogined=NO;
        }else if(_accountType==kAccountTypeSina)
        {
            if(!weiboControl)
            {
                weiboControl=[self getWeiboControl:[SinaWeiboControl class] tag:kAccountTypeSina];
            }
            _isLogined=[weiboControl checkUserHavedLogin];
        }
    }
    NSLog(@"checkIsLogin>>>>%d|||isLogin>>>>%d",_accountType,_isLogined);
    return _isLogined;
}
-(BOOL)handleUrl:(NSURL *)url
{
    if(tempAccountType==kAccountTypeSina)
    {
       return [WeiboSDK handleOpenURL:url delegate:(SinaWeiboControl *)tempWeiboControl];
    }else
    {
        return YES;
    }
}
#pragma mark -
-(void)loginSuccess
{
    if(_isLogined)//如果已经登录，说明是切换账号
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:AccountSwitchWillFinishedNotification object:nil];
    }
    _isLogined=YES;
    
    _accountType=tempAccountType;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:_isLogined forKey:KeyUserHavedLogined];
    [defaults setInteger:_accountType forKey:KeyLastloginAccountType];
    
    [defaults synchronize];
    
    weiboControl=tempWeiboControl;
    tempWeiboControl=nil;
}
-(void)loginFailed
{
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    [defaults setBool:_isLogined forKey:KeyUserHavedLogined];
//    [defaults setInteger:_accountType forKey:KeyLastloginAccountType];
//    
//    [defaults synchronize];
}
-(void)loginoutSuccess
{
    _isLogined=NO;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:_isLogined forKey:KeyUserHavedLogined];
    [defaults synchronize];
}
#pragma mark 生成weiboControl
-(id)getWeiboControl:(Class)class_ tag:(int)tag
{
    WeiboBase *base=[[class_ alloc] init];
    base.delegate=self;
    base.requestQueue=weiboQueue;
    base.tag=tag;
    return base;
}
#pragma mark -
#pragma mark KVO观察
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
//    NSString *observerName=CFBridgingRelease(context);
//    (void *)CFBridgingRetain([NSString stringWithFormat:@"sinaWeiboControl"]
    int observerTag=(int)context;
    NSLog(@"observerTag>>>%d",observerTag);
    if ([keyPath isEqualToString:@"userInfo"])
    {
        if(observerTag==kAccountTypeSina)
        {
            
        }
    }
}
-(void)dealloc
{
    
}
@end
