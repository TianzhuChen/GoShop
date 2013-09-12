//
//  AppDelegate.m
//  GoShop
//
//  Created by iwinad2 on 13-6-9.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "AppDelegate.h"
#import "Theme.h"
#import "NewsViewController.h"
#import "ViewControllerManager.h"


@interface AppDelegate(){
    ViewControllerManager *manager;
    UILabel *_infoLabel;
    UILabel *_infoLabel1;
}
@property (strong, nonatomic) NewsViewController *viewController;

@end

@implementation AppDelegate
@synthesize menu,dataManager;

static AppDelegate *instance;
+(AppDelegate *)getAppDelegate{
    return instance;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSHomeDirectory());
    
    NSLog(@"*************************");
    [[AccountControl sharedAccount] checkIsLogin];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    NSLog(@"frame>>>%@",NSStringFromCGRect([[UIScreen mainScreen] bounds]));
   
    
   [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    // Override point for customization after application launch.
    [self.window makeKeyWindow];
    self.viewController=[[NewsViewController alloc] initWithClassName];
//    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
//    self.childWindow=[[UIWindow alloc] initWithFrame:self.window.frame];
//    self.childWindow.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5];
//    [self.childWindow makeKeyAndVisible];
    
    manager=[ViewControllerManager sharedInstance];
    manager.currentController=self.viewController;
    [manager addControllerToCaches:self.viewController];
    
    self.menu=[[Menu alloc] initMenuWithDelegate:manager];
    [self.menu show];
    instance=self;
//    [Theme setStatusBarBackground];
//     [Theme styleNavigationBarWithFontName:@"" andColor:[Theme getNavigationBarBackgroundColor:0]];
    
    dataManager=[DataManager sharedManager];
    
    /**********************/
    
//    NSLog(@"启动信息%@",[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]);
//    _infoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 200)];
//    [_infoLabel1 setBackgroundColor:[UIColor clearColor]];
//    [_infoLabel1 setTextColor:[UIColor colorWithRed:0.750 green:0.023 blue:0.023 alpha:1.000]];
//    [_infoLabel1 setFont:[UIFont boldSystemFontOfSize:20]];
//    [_infoLabel1 setTextAlignment:UITextAlignmentCenter];
//    [_infoLabel1 setNumberOfLines:0];
//    [_infoLabel1 setText:[launchOptions description]];
//    [self.window addSubview:_infoLabel1];
    /*******APNS推送*******/
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kAPNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kAPNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kAPNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kAPNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kAPNetworkDidReceiveMessageNotification
                        object:nil];
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                   UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound)];
    [APService setupWithOption:launchOptions];
//    [APService setTags:[NSSet setWithObjects:@"tag1", @"tag2", @"tag3", nil] alias:@"别名"];
    
    [APService setTags:[NSSet setWithObjects:@"tag4",@"tag5",@"tag6",nil] alias:@"别名" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    /********END*********/
    return YES;
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [manager didReceiveMemoryWarning];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"TYPESSSSSS: %d", [application enabledRemoteNotificationTypes]);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
   return [[AccountControl sharedAccount] handleUrl:url];
//    if([[AccountControl sharedAccount].weiboControl isKindOfClass:[SinaWeiboControl class]])
//    {
//        return  [WeiboSDK handleOpenURL:url delegate:(SinaWeiboControl *)dataManager.accountControl.weiboControl];    
//    }else
//    {
//        return  [self application:application handleOpenURL:url];
//    }
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[AccountControl sharedAccount] handleUrl:url];
//    if([dataManager.accountControl.weiboControl isKindOfClass:[SinaWeiboControl class]])
//    {
//        return [WeiboSDK handleOpenURL:url delegate:(SinaWeiboControl *)dataManager.accountControl.weiboControl];
//    }else
//    {
//        return [self application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    }
}
#pragma mark -
#pragma mark APNS 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
}
#pragma mark ---------------------------------
- (void)networkDidSetup:(NSNotification *)notification {
    [self initLable];
    [_infoLabel setText:@"已连接"];
}

- (void)networkDidClose:(NSNotification *)notification {
    [self initLable];
    [_infoLabel setText:@"未连接。。。"];
}

- (void)networkDidRegister:(NSNotification *)notification {
    [self initLable];
    [_infoLabel setText:@"已注册"];
}

- (void)networkDidLogin:(NSNotification *)notification {
    [self initLable];
    [_infoLabel setText:@"已登录"];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    [self initLable];
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKeyPath:@"extras.title"];//[userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    [_infoLabel setText:[NSString stringWithFormat:@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content]];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
-(void)initLable
{
    if(!_infoLabel)
    {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 200)];
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextColor:[UIColor colorWithRed:0.5 green:0.65 blue:0.75 alpha:1]];
        [_infoLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [_infoLabel setTextAlignment:UITextAlignmentCenter];
        [_infoLabel setNumberOfLines:0];
        [_infoLabel setText:@"未连接。。。"];
        [self.window addSubview:_infoLabel];
    }

}
@end
