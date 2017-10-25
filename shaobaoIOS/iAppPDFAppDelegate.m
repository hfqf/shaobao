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
#import <AlipaySDK/AlipaySDK.h>
#import "MainTabBarViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
@interface iAppPDFAppDelegate() <WXApiDelegate>
@property (nonatomic,strong)MainTabBarViewController *rootVC ;
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

    [WXApi registerApp:@"wxc508d5fdc6898b52"];

    
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
    self.rootVC = [[MainTabBarViewController alloc]init];

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



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }else
    {
         return [WXApi handleOpenURL:url delegate:self];
    }
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }else{
        return  [WXApi handleOpenURL:url delegate:self];
    }

}

//前面的两个方法被iOS9弃用了，如果是Xcode7.2网上的话会出现无法进入进入微信的onResp回调方法，就是这个原因。本来我是不想写着两个旧方法的，但是一看官方的demo上写的这两个，我就也写了。。。。

//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}



//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                [[NSNotificationCenter defaultCenter]postNotificationName:kWeixinPay object:resp];
                payResoult = @"支付结果：成功";
                break;
            case -1:
                payResoult = @"支付结果：失败";
                break;
            case -2:
                payResoult = @"用户已经退出支付";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
    [PubllicMaskViewHelper showTipViewWith:payResoult inSuperView:self.window withDuration:1];
}



@end
