//
//  iAppPDFAppDelegate.m
//  iAppPDF
//
//  Created by apple on 14-7-8.
//  Copyright (c) 2014年 com.kinggrid. All rights reserved.
//

#import "iAppPDFAppDelegate.h"

#import "LoginViewController.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface iAppPDFAppDelegate() 
@property (nonatomic,strong)LoginViewController *rootVC ;
@end
@implementation iAppPDFAppDelegate

- (void)checkLauhchDaTangApp{
//    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SSO_IS_NEED_LOGIN];
//    if([ret integerValue] != 1){
        if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"www.cattsoft.gportal:"]])
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"www.cattsoft.gportal://com.kj.jyoa?info=login"]];
        }
//    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
#if DEBUG
    
#else
    [self checkLauhchDaTangApp];
#endif
    
    
    NSString *server =[[NSUserDefaults standardUserDefaults]objectForKey:KEY_SERVER_PRE];
    if(server == nil || server.length == 0)
    {
#if DEBUG
        [[NSUserDefaults standardUserDefaults]setObject:@"218.94.19.242:3001/jymserver" forKey:KEY_SERVER_PRE];
#else
        [[NSUserDefaults standardUserDefaults]setObject:@"58.213.150.105:8080/jymserver" forKey:KEY_SERVER_PRE];
#endif
    }
    
    [self checkUpdate];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.rootVC = [[LoginViewController alloc]init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[XTNavigationController alloc]initWithRootViewController:self.rootVC];
    
    self.isEnableAnnotation = NO;
    self.isQianming = NO;
    self.isCanAnnotation = YES;
    self.isNotTake = YES;
    self.isHaveCamera = YES;
    self.isCanChangeAuthor = YES;
    self.isCountersigned = YES;
    self.isPushCamera = YES;
    self.isMeettingFile = YES;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self checkUpdate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -

- (void)checkUpdate
{
    [[HttpConnctionManager sharedInstance] gettheLastestVersion:^(NSDictionary *retDic){
        
        NSArray *arr = (NSArray *)retDic;
        if(arr.count > 0)
        {
            NSDictionary  *bundleDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentAppVersion = [bundleDic objectForKey:@"CFBundleVersion"];
            
            self.m_versionDic = [arr firstObject];
            BOOL isCanUpdate =  [currentAppVersion integerValue] < [self.m_versionDic[@"version"]integerValue];
            
            if(isCanUpdate)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"有版本可以升级" message:@"是否升级" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"确认", nil];
                [alert show];
            }

        }
        else
        {
            
        }
        
    } failedBolck:FAILED_BLOCK{
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https%3A%2F%2Fmelaka.fir.im%2Fapi%2Fv2%2Fapp%2Finstall%2F55591f138e82369a570010bf%3Ftoken%3DWKQhCC19JIygnoM2k3H4dojAWYx3I4x5jo1iO7Qm"]];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self parseUrl:url application:application];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    [self parseUrl:url application:application];
    return YES;
}

- (void)parseUrl:(NSURL *)url application:(UIApplication *)application
{
    NSLog(@"url = %@",url);
    
    NSString *query = [[url query]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"query = %@",query);
    
    NSArray *arr = [query componentsSeparatedByString:@"&"];
    NSString *username = nil;
    NSString *pwd       = nil;
    for(NSString *str in arr)
    {
        if([str rangeOfString:@"username"].length > 0)
        {
            NSArray *_arr = [str componentsSeparatedByString:@"="];
            username = [_arr lastObject];
            [[NSUserDefaults standardUserDefaults]setObject:username == nil ? @"" : username forKey:KEY_SSO_NAME];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_SSO_IS_NEED_LOGIN];
        }
        
        if([str rangeOfString:@"password"].length > 0)
        {
            NSArray *_arr = [str componentsSeparatedByString:@"="];
            pwd = [_arr lastObject];
            [[NSUserDefaults standardUserDefaults]setObject:pwd == nil ? @"" : pwd forKey:KEY_SSO_PWD];
        }
    }
    
    if(self.rootVC)
    {
        [self.rootVC startSSOLogin];
    }

    
}
@end
