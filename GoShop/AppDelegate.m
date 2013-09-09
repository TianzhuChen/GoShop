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
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
@end
