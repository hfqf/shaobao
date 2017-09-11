//
//  DownloadUrlSetViewController.m
//  officeMobile
//
//  Created by Points on 15/8/9.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "DownloadUrlSetViewController.h"

@interface DownloadUrlSetViewController ()<UITextFieldDelegate>
{
    UITextField *m_input;
}

@end

@implementation DownloadUrlSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"下载地址设置"];
    
    NSString *server = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_DOWNLOAD_PRE];
    
    UILabel *serverLab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(navigationBG.frame)+40, 80, 20)];
    [serverLab setText:@"下载地址"];
    [self.view addSubview:serverLab];
    
    m_input =[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serverLab.frame), CGRectGetMaxY(navigationBG.frame)+35, MAIN_WIDTH- CGRectGetMaxX(serverLab.frame)+10-20, 30)];
    [m_input setTextAlignment:NSTextAlignmentLeft];
    [m_input setReturnKeyType:UIReturnKeyDone];
    [m_input setFont:[UIFont systemFontOfSize:14]];
    m_input.layer.cornerRadius = 4;
    m_input.delegate = self;
    m_input.layer.borderColor = [UIColor grayColor].CGColor;
    m_input.layer.borderWidth =0.5;
    [m_input setText:server];
    [self.view addSubview:m_input];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setFrame:CGRectMake(MAIN_WIDTH-60,DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
    [saveBtn setTitle:@"下载" forState:UIControlStateNormal];
    [navigationBG addSubview:saveBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)saveBtnClicked
{
    [m_input resignFirstResponder];
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:m_input.text]])
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:m_input.text]];
    }
    else
    {
        [PubllicMaskViewHelper showTipViewWith:@"地址错误" inSuperView:self.view withDuration:1];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults]setObject:m_input.text forKey:KEY_DOWNLOAD_PRE];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return YES;
}

@end
