//
//  WebViewViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()
{
    UIWebView *m_webView;
}
@property(nonatomic,strong) NSString *m_url;
@property(nonatomic,strong) NSString *m_title;
@end

@implementation WebViewViewController
-(id)initWith:(NSString *)url withTitle:(NSString *)title
{
    self.m_title = title;
    self.m_url = url;
    if(self = [super init]){
        m_webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MAIN_WIDTH, MAIN_HEIGHT-64)];
        [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:m_webView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
