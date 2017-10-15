//
//  LoginViewController.m
//  GCP
//
//  Created by Points on 15-1-12.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "LoginViewController.h"
#import "ClassIconImageView.h"
#import "MainTabBarViewController.h"
#import "LoginScrollerView.h"
#import "SideslipViewController.h"
#import "HomeStartViewController.h"
@interface LoginViewController ()<LoginScrollerViewDelegate>
{
    UITextField *m_nameText;
    UITextField *m_pwdText;
    BOOL m_isNeedRemebmber;
}

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self startSSOLogin];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

- (void)startSSOLogin
{
    if([LoginUserUtil ssoIsNeedLogin])
    {
        [self showWaitingView];
        [HTTP_MANAGER startLogin:[LoginUserUtil ssoName]
                             pwd:[LoginUserUtil ssoPwd]
                  successedBlock:^(NSDictionary *retDic){
                      [self removeWaitingView];
                      [self processLoginReturnData:retDic];
                  }
                     failedBolck:FAILED_BLOCK
         {
             [self removeWaitingView];
             SHOW_ERROR_TIP
         }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    [title setText:@"登录少保"];

    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, MAIN_WIDTH, MAIN_HEIGHT-64)];
    [self.view addSubview:scroller];
    
    [self removeBackBtn];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((MAIN_WIDTH-150)/2,50,150, 60)];
    [icon setImage:[UIImage imageNamed:@"login_logo"]];
    [scroller addSubview:icon];
    
    LoginScrollerView *scr = [[LoginScrollerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+30, MAIN_WIDTH,102)];
    scr.scrollEnabled = NO;
    scr.m_delegate = self;
    [scroller addSubview:scr];

    BOOL flag = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUTO_SAVE]isEqualToString:@"1"];

    flag = YES;

    UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];
    
    m_nameText = [[UITextField alloc]initWithFrame:CGRectMake(30,0, MAIN_WIDTH-60, 50)];
    m_nameText.leftViewMode = UITextFieldViewModeAlways;
    [m_nameText setBackgroundColor:[UIColor whiteColor]];
    [m_nameText setLeftView:left];
    
    UIImageView *insertName = [[UIImageView alloc]initWithFrame:CGRectMake(10,15, 15, 18)];
    [insertName setImage:[UIImage imageNamed:@"login_account_icon"]];
    [m_nameText addSubview:insertName];
    
    [m_nameText setPlaceholder:@"用户账号"];
    if(flag)
    {
//        [m_nameText setText:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_ACCOUTN]];
#if DEBUG
        [m_nameText setText:@"test"];
#endif
    }
    [m_nameText setTextColor:[UIColor blackColor]];
//    m_nameText.layer.cornerRadius = 5;
//    m_nameText.layer.borderWidth = 0.5;
//    m_nameText.layer.borderColor = [UIColor grayColor].CGColor;
    [scr addSubview:m_nameText];

    UIView *sep1 =[[UIView alloc]initWithFrame:CGRectMake(28, CGRectGetMaxY(m_nameText.frame)+0.5-10, MAIN_WIDTH-56, 0.5)];
    [sep1 setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
    [scr addSubview:sep1];
    m_pwdText = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(m_nameText.frame)+1, MAIN_WIDTH-60, 50)];
    [m_pwdText setBackgroundColor:[UIColor whiteColor]];
    [m_pwdText setPlaceholder:@"密码"];
    if(flag)
    {
//        [m_pwdText setText:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD]];
#if DEBUG
        [m_pwdText setText:@"1234"];
#endif
    }
    UIImageView *leftPwd = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 44, 18)];
    [leftPwd setImage:[UIImage imageNamed:@""]];
    [m_pwdText setLeftView:leftPwd];
    
    
    UIImageView *insertPwd = [[UIImageView alloc]initWithFrame:CGRectMake(10,15, 18, 18)];
    [insertPwd setImage:[UIImage imageNamed:@"密码"]];
    [m_pwdText addSubview:insertPwd];
    
    m_pwdText.leftViewMode = UITextFieldViewModeAlways;
    [m_pwdText setTextColor:[UIColor blackColor]];
    [m_pwdText setSecureTextEntry:YES];
    [scr addSubview:m_pwdText];

    UIView *sep2 =[[UIView alloc]initWithFrame:CGRectMake(28, CGRectGetMaxY(m_pwdText.frame)+0.5-10, MAIN_WIDTH-56, 0.5)];
    [sep2 setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
    [scr addSubview:sep2];
    
    
    UIButton *rememberPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rememberPwdBtn setBackgroundColor:[UIColor clearColor]];
    rememberPwdBtn.selected = flag;
    [rememberPwdBtn addTarget:self action:@selector(rememberPwdBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rememberPwdBtn setFrame:CGRectMake(MAIN_WIDTH-90, CGRectGetMaxY(scr.frame)+10, 80, 30)];
    [rememberPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [rememberPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rememberPwdBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [scroller addSubview:rememberPwdBtn];
    rememberPwdBtn.hidden = YES;

 
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundColor:KEY_COMMON_CORLOR];
//    [loginBtn setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setFrame:CGRectMake(20, CGRectGetMaxY(rememberPwdBtn.frame)+30,(scr.frame.size.width-40), 50)];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = loginBtn.frame.size.height/2;
    [scroller addSubview:loginBtn];
    
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setBackgroundColor:[UIColor clearColor]];
    [logoutBtn addTarget:self action:@selector(logoutBtnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setFrame:CGRectMake((scr.frame.size.width-140)/2, CGRectGetMaxY(loginBtn.frame)+30,140, 30)];
    [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [logoutBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    [logoutBtn setImage:[UIImage imageNamed:@"注册箭头"] forState:UIControlStateNormal];
    [logoutBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 100, 5, 20)];
    [logoutBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
//    logoutBtn.layer.cornerRadius = 5;
//    logoutBtn.layer.borderWidth = 1;
//    logoutBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [scroller addSubview:logoutBtn];

    if(CGRectGetMaxY(logoutBtn.frame) > MAIN_HEIGHT-64){
        [scroller setContentSize:CGSizeMake(MAIN_WIDTH,CGRectGetMaxY(logoutBtn.frame)+20)];
    }else{
        [scroller setContentSize:CGSizeMake(MAIN_WIDTH, MAIN_HEIGHT-64)];
    }
    [self.view bringSubviewToFront:navigationBG];

}

- (void)setBtnClcikced
{
    [self.navigationController pushViewController:[[NSClassFromString(@"AddressSetViewController") alloc]init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)rememberPwdBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults]setObject:btn.selected ? @"1" : @"0" forKey:KEY_AUTO_SAVE];
}

- (void)forgetPwdBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"ResetPwdViewController") alloc]init] animated:YES];
}


- (void)logoutBtnBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"ShaobaoRegisterViewController") alloc]init] animated:YES];
}


- (void)loginBtnBtnClicked
{
    if(m_nameText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"账号不能为空" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(m_pwdText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self showWaitingView];
    [HTTP_MANAGER startLogin:m_nameText.text
                         loginPass:m_pwdText.text
              successedBlock:^(NSDictionary *retDic){
                  [self removeWaitingView];
                  [self processLoginReturnData:retDic];
              }
                 failedBolck:FAILED_BLOCK
      {
             [self removeWaitingView];
              SHOW_ERROR_TIP
      }];
}

- (void)registerBtnClicked
{
    
    [self.navigationController pushViewController:[[NSClassFromString(@"RegisterViewController") alloc]init] animated:YES];
}


- (void)processLoginReturnData:(NSDictionary *)data
{
  
    [[NSUserDefaults standardUserDefaults]setObject:m_nameText.text forKey:KEY_ACCOUTN];
    [[NSUserDefaults standardUserDefaults]setObject:m_pwdText.text forKey:KEY_PASSWORD];
    
    
    //写如当前帐号信息
    [self writeAutoLogDic];
    
    NSDictionary *resultDict=[data objectForKey:@"data"];

    if ([data[@"ret"]integerValue] == 0) {
        
        //add by huangfu
        [LoginUserUtil writeDictionaryToPlist:resultDict];
        
        //创建存放图片和音频的文件夹
        [LocalImageHelper createUploadFileInDocument];
        
        MainTabBarViewController *mainVC  = [[MainTabBarViewController alloc]init];
        [self.navigationController pushViewController:mainVC animated:YES];
        
        BOOL flag = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUTO_SAVE]isEqualToString:@"1"];
        if(!flag){
            [m_nameText setText:nil];
            [m_pwdText setText:nil];
        }
    }
}

#pragma mark - 自动保存密码

+ (void)saveUserToAutoPlist:(NSDictionary *)dic
{
    if([dic writeToFile:[self getPathOfSaveUserPlist] atomically:YES])
    {
        SpeLog(@"自动登陆写入成功");
    }
    else
    {
        SpeLog(@"自动登陆写入失败");
    }
    SpeLog(@"%@",[self getDicFromCurrentSavedUserPlist]);
}

+ (NSString *)getPathOfSaveUserPlist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doc = [paths objectAtIndex:0];
    NSString *path=[doc stringByAppendingPathComponent:@"CurrentSavedUser.plist"];
    if(![fileManager fileExistsAtPath:path isDirectory:NO])
    {
        NSDictionary * dic = [NSDictionary dictionary];
        [dic writeToFile:path atomically:YES];
    }
    SpeLog(@"当前登陆用户信息:%@",path);
    return path;
}

+ (NSDictionary *)getDicFromCurrentSavedUserPlist
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPathOfSaveUserPlist]];
    return data;
}



- (void)setInputViewWithAuotLoginDic
{
    NSDictionary *dic = [LoginViewController getDicFromCurrentSavedUserPlist];
    if([[dic objectForKey:@"autoLogin"]isEqualToString: @"1"])
    {
        // [m_loginView setloginUser:dic isRember:YES];
        m_isNeedRemebmber = YES;
    }
    else
    {
        // [m_loginView setloginUser:dic isRember:NO];
        m_isNeedRemebmber = NO;
    }
}

- (void)writeAutoLogDic
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:self.m_name ,@"userName",self.m_pwd,@"passWord",@"1",@"autoLogin",@"1",@"isLogined",[[NSUserDefaults standardUserDefaults]objectForKey:KEY_LOGIN_ROLE],@"userType",@"0",@"isXXT",nil];
    [LoginViewController saveUserToAutoPlist:dic];
}

- (void)onRemoveKeyboard
{
    [m_nameText resignFirstResponder];
    [m_pwdText resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.view.center =CGPointMake(MAIN_WIDTH/2, MAIN_HEIGHT/2-150);
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    self.view.center =CGPointMake(MAIN_WIDTH/2, MAIN_HEIGHT/2);
}

@end
