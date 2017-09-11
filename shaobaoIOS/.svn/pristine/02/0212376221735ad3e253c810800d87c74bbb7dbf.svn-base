//
//  AddressSetViewController.m
//  officeMobile
//
//  Created by Points on 15/7/3.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

#import "AddressSetViewController.h"

@interface AddressSetViewController ()
{
    UITextField *m_input;
}

@end

@implementation AddressSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"地址设置"];
    
    NSString *server = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SERVER_PRE];
    UILabel *serverLab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(navigationBG.frame)+40, 80, 20)];
    [serverLab setText:@"服务地址"];
    [self.view addSubview:serverLab];
    
    m_input =[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serverLab.frame), CGRectGetMaxY(navigationBG.frame)+35, MAIN_WIDTH- CGRectGetMaxX(serverLab.frame)+10-20, 30)];
    [m_input setTextAlignment:NSTextAlignmentLeft];
    [m_input setFont:[UIFont systemFontOfSize:14]];
    m_input.layer.cornerRadius = 4;
    m_input.layer.borderColor = [UIColor grayColor].CGColor;
    m_input.layer.borderWidth =0.5;
    [m_input setText:server];
    [self.view addSubview:m_input];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setFrame:CGRectMake(MAIN_WIDTH-60,DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [navigationBG addSubview:saveBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)saveBtnClicked
{
    [m_input resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults]setObject:m_input.text forKey:KEY_SERVER_PRE];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [PubllicMaskViewHelper showTipViewWith:@"设置成功" inSuperView:self.view withDuration:1];
    [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
