//
//  FilePreviewViewController.m
//  Education
//
//  Created by Points on 14-12-9.
//  Copyright (c) 2014年 Education. All rights reserved.
//

#import "FilePreviewViewController.h"

@interface FilePreviewViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
 
}

@end

@implementation FilePreviewViewController

- (id)init
{
    if(self = [super  init])
    {
        web = [[UIWebView alloc]initWithFrame:CGRectMake(0,HEIGHT_NAVIGATION+DISTANCE_TOP, MAIN_WIDTH, MAIN_HEIGHT-(HEIGHT_NAVIGATION+DISTANCE_TOP)-CIRCLE_TOP)];
        web.delegate = self;
        //web.scrollView.maximumZoomScale =10;
        web.scrollView.delegate = self;
        [self.view addSubview:web];
        
        web.scalesPageToFit = YES;
    }
    return self;
}



- (void)setCurrentTitle:(NSString *)currentTitle
{
    [title setText:currentTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFileLocalUrl:(NSString *)fileLocalUrl
{
    if(fileLocalUrl == nil)
    {
        [PubllicMaskViewHelper showTipViewWith:@"打开失败" inSuperView:self.view withDuration:1];
        return;
    }
    fileLocalUrl  = [fileLocalUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _fileLocalUrl = fileLocalUrl;
    
    NSURL *url = [NSURL fileURLWithPath:fileLocalUrl];
    
    [web loadRequest:[NSURLRequest requestWithURL:url]];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showWaitingViewWith:10];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeWaitingView];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeWaitingView];
}


@end
