//
//  SaveMoneyViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/11/7.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "SaveMoneyViewController.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
@interface SaveMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
{
    UITextField *m_input1;
    UITextField *m_input2;
    UITextField *m_input3;
}
@property(nonatomic,strong) NSString *m_netMoney;
@property(nonatomic,strong) NSString *m_payType;
@property(nonatomic,strong) NSString *m_payId;

@end

@implementation SaveMoneyViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
        [self.tableView setFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT)];
        [self.view bringSubviewToFront:navigationBG];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [navigationBG setBackgroundColor:[UIColor clearColor]];
    [navigationBG setImage:[UIImage imageNamed:@""]];
    [title setText:@"充值"];
    [title setTextColor:[UIColor whiteColor]];

    [self.view bringSubviewToFront:navigationBG];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter]addObserverForName:kWeixinPay object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {

        PayResp *resp = note.object;

        [HTTP_MANAGER payResult:self.m_payId
                     resultCode:@"SUCCESS"
                responseContent:@""
                 successedBlock:^(NSDictionary *succeedResult1) {

                     if([succeedResult1[@"ret"]integerValue] == 0){
                         [PubllicMaskViewHelper showTipViewWith:succeedResult1[@"msg"] inSuperView:self.view withDuration:1];
                         [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                     }else{
                         [PubllicMaskViewHelper showTipViewWith:succeedResult1[@"msg"] inSuperView:self.view withDuration:1];

                     }

                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                     [PubllicMaskViewHelper showTipViewWith:@"支付失败" inSuperView:self.view withDuration:1];

                 }];

    }];

}


- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height)];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y)];
}

- (void)rightBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"TradeHistoryViewController") alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER getCash:^(NSDictionary *succeedResult) {

        if([succeedResult[@"ret"]integerValue]==0){
            self.m_netMoney = succeedResult[@"data"][@"netMoney"];
            //            self.m_netMoney =@"1000";
        }

        [self reloadDeals];
        self.tableView.tableHeaderView = [self headrView];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self reloadDeals];
        self.tableView.tableHeaderView = [self headrView];
    }];
}

- (UIView *)headrView
{
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200+HEIGHT_STATUSBAR)];
    [bg setImage:[UIImage imageNamed:@"set_ye_bg"]];
    bg.userInteractionEnabled = YES;

    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20+HEIGHT_NAVIGATION, 90, 20)];
    [tip1 setText:@"网钞币"];
    [tip1 setFont:[UIFont systemFontOfSize:18]];
    [tip1 setTextAlignment:NSTextAlignmentLeft];
    [tip1 setTextColor:[UIColor whiteColor]];
    [bg addSubview:tip1];

    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50+HEIGHT_NAVIGATION, MAIN_WIDTH-20, 50)];
    [tip2 setText:[NSString stringWithFormat:@"%.2fWCB",self.m_netMoney.floatValue]];
    [tip2 setFont:[UIFont boldSystemFontOfSize:50]];
    [tip2 setTextAlignment:NSTextAlignmentLeft];
    [tip2 setTextColor:[UIColor whiteColor]];
    [bg addSubview:tip2];

    UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 110+HEIGHT_NAVIGATION, MAIN_WIDTH-20, 20)];
    [tip3 setText:@"备注: 1网钞币等于1元人民币"];
    [tip3 setFont:[UIFont systemFontOfSize:18]];
    [tip3 setTextAlignment:NSTextAlignmentLeft];
    [tip3 setTextColor:[UIColor whiteColor]];
    [bg addSubview:tip3];

    return bg;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.accessoryType = UITableViewCellAccessoryNone;
    UILabel *tit = [[UILabel alloc]initWithFrame:CGRectMake(10,20,100, 20)];
    [tit setTextAlignment:NSTextAlignmentLeft];
    [tit setFont:[UIFont systemFontOfSize:16]];
    [tit setTextColor:UIColorFromRGB(0x333333)];
    [cell addSubview:tit];

    if(indexPath.row == 0){
        [tit setText:@"充值金额"];
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-200, 20, 190, 20)];
        m_input1.delegate  = self;
        m_input1.returnKeyType = UIReturnKeyDone;
        m_input1.keyboardType = UIKeyboardTypeDecimalPad;
        [m_input1 setTextColor:UIColorFromRGB(0x333333)];
        [m_input1 setPlaceholder:@"请输入充值金额"];
        [cell addSubview:m_input1];
        [m_input1 resignFirstResponder];
    }else if (indexPath.row == 1){
        [tit setText:@"充值账号类型"];
        m_input2 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-200, 20, 190, 20)];
        m_input2.returnKeyType = UIReturnKeyDone;
        [m_input2 setTextColor:UIColorFromRGB(0x333333)];
        m_input2.enabled = NO;
        [m_input2 setPlaceholder:@"请选择充值账号类型"];
        [cell addSubview:m_input2];
    }
//    else if (indexPath.row == 2){
//        [tit setText:@"提取账号"];
//        m_input3 = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-200, 20, 190, 20)];
//        m_input3.delegate  = self;
//        m_input3.returnKeyType = UIReturnKeyDone;
//        //        m_input3.keyboardType = UIKeyboardTypeNumberPad;
//        [m_input3 setTextColor:UIColorFromRGB(0x333333)];
//        [m_input3 setPlaceholder:@"请输入提现账号"];
//        [cell addSubview:m_input3];
//    }
    else if (indexPath.row == 2){

        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm addTarget:self action:@selector(sendBtnClikced) forControlEvents:UIControlEventTouchUpInside];
        [confirm setFrame:CGRectMake(5, 5, MAIN_WIDTH-10, 50)];
        [confirm setBackgroundColor:KEY_COMMON_CORLOR];
        confirm.layer.cornerRadius = 4;
        [confirm setTitle:@"确定" forState:0];
        [confirm setTitleColor:[UIColor whiteColor] forState:0];
        [cell addSubview:confirm];
    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
    [cell addSubview:sep];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 1){
        [m_input1 resignFirstResponder];

        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择提取方式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
        [act showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [m_input2 setText:@"支付宝"];
    }else
    {
        [m_input2 setText:@"微信"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)sendBtnClikced
{
    if(m_input1.text.floatValue == 0){
        [PubllicMaskViewHelper showTipViewWith:@"充值金额不能为0" inSuperView:self.view withDuration:1];
        return;
    }

    if(m_input2.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"充值账号方式不能为空" inSuperView:self.view withDuration:1];
        return;
    }


    [HTTP_MANAGER recharge:[m_input2.text isEqualToString:@"支付宝"] ? @"1" : @"2"
                  relMoney:m_input1.text
            successedBlock:^(NSDictionary *succeedResult) {

                        [self precessPay:succeedResult];

                         }
               failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {



                         }];

}


- (void)precessPay:(NSDictionary *)succeedResult
{
    if([m_input2.text isEqualToString:@"支付宝"]){
        NSString *payId = succeedResult[@"data"][@"payId"];
        self.m_payId = payId;
        [self doAlipayPay:m_input1.text
                     body:@"少保充值"
                    payId:payId
    callback:^(NSDictionary *resultDic) {
                     if([resultDic[@"code"]integerValue] == 10000){

                         [HTTP_MANAGER payResult:payId
                                      resultCode:@"SUCCESS"
                                 responseContent:[resultDic JSONString]
                                  successedBlock:^(NSDictionary *succeedResult1) {

                                      if([succeedResult1[@"ret"]integerValue] == 0){
                                          [PubllicMaskViewHelper showTipViewWith:succeedResult1[@"msg"] inSuperView:self.view withDuration:1];

                                          [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                                      }else{
                                          [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];

                                      }



                                  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                      [PubllicMaskViewHelper showTipViewWith:@"支付失败" inSuperView:self.view withDuration:1];

                                  }];


                     }else{
                         [PubllicMaskViewHelper showTipViewWith:resultDic[@"msg"] inSuperView:self.view withDuration:1];
                     }
                 }];
}else{

    NSString *payId = succeedResult[@"data"][@"payId"];
    self.m_payId = payId;
    [self WXPay:succeedResult[@"data"]
           body:@"少保充值"
          payId:payId
       callback:^(NSDictionary *resultDic) {
           if([resultDic[@"code"]integerValue] == 10000){



           }else{
               [PubllicMaskViewHelper showTipViewWith:resultDic[@"msg"] inSuperView:self.view withDuration:1];
           }
       }];
}


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
}









#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay:(NSString *)money  body:(NSString *)body payId:(NSString *)payId  callback:(CompletionBlock)completionBlock

{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017092608939918";

    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCwhg/qwvMv9Ay+TQ7+ES1goQLZ3Fj2dbvEuqQYYDbOE63R7l/81EXFHwR8orJQpFjN4HnRgujq1ZSL4LmuUuENgfemUwTLtBRFtQOnmIzUzELp7ih5DtPXyNEUDPYiM+6u9yI2UyPZiBPuf4ctwI9g6AttW3cuasQd1bpnrFBNHVYtpiBEpUHphpX/3bnTeMPzVc+/GVWhWs8eMa20gIJuYAVPzRCDn6JVMrESuOKljB7H5qBt418FGPPOBmtd7uNIgEHa2SS3vz/2TM3FlTXHbtq31kSygllVcV9R+9XTNNwnhWoDdlwrjInfQ6DXCcitjBo8k6k5BCgqOmE/5B4rAgMBAAECggEBAJr5yAWijCDAkWONgaka6YzZLwiYBF60dFo+RgzEg7ke287gCdONhYePOMA3kndsIi71cd23ocdyJY08iaf7SWwze3nBjwdMHTQpvICqVJIKloCMP2ow01myC6Uf0AOtNlLT02yAR4wWhPExczt+wCIi9s1WrObKg01yM8oLJSDdODFJHT9wdKtlAZtXaAWQ2Rmm0SsKpAlzZzozF1WwmN7ikokfC1MOGVT5Qu8559Bg1oOJucG0UwmoZD1ykR9exT5+ib2awYC7sSqfh71JZAVyKUEfbzZnWe6Z1g9F+13jNd5KIJAJZtbMgIeAZW3TFvpR8E1QBwZTAg0sm/jwu5kCgYEA26gC9eNP1qkNTSuQmA5CHN3oByqO55c/ZLG1+u7sPtDpFUmjShz4p/MhM5V2ZSR5fWJN6OK6rbmCdKoaX+J7/DWxqwYUbwE335GPnDhzLFRnba93+Cv7Mna1xaUrSOsFh2Ctz2y1FaDQQ9q643Y6yDGJod3pMMb2Q0yfjhIbNh8CgYEAzbsUxHY6nILGPoTJoGApTB2FwvvPYomgeCbSyEWXMHRHoXI3cPlJS8z6aXqD5Rrp6AlyIHTYZaFfhXs2xLvoDySNQ2tUs8+b1Jll4hQaK04Lp3JJHBz/JfQl/B2WMeIwaLLSALn+YgiIo0Z24EcO4avN9OemWnbpq6WNys/LXnUCgYAHv72a/xHp+LzHZCoNszMR4aI13oJ8GRHbc4l/+L3M2YHfhmGEU9FR23noX/V1S/wdOEKXXKhJSKoZg4a6qzrEgwBpkCVYZSqbcH8oe7VUcwXTEMWis6qA9T8kYddNEz12sSpwjt00jh/KxQSi0aDxPw4j77gySFKXvTRDxs++8QKBgFvXncDK6wV92BSG4SAIbcc+Er3l/kIGIK4i3sxrTMBj2Kp5O8jicNc3Db9S41i++BcPSHS21Pgh32vOgre3DzTbY3jqjGitUOrLBFG2Gaylbcx116+GPl1qLh7r8mYYjPXghqGuZqLLHnyNc3pSHpGeShZ/56LRHSX0hWU5+JcVAoGAV8Mtpdokpe2U7L5p2yJKEngVFn3xJiMUl2OES2ppkDELWE2UcX3Gt9nJ0Sa4yfBIn7bNAlaUbAIttBKt9aYuYxtSWIPN64rlJixHluyFVbWtA2OLsR8xK1oSVbAOJynTNs2JKQrdT/2Y0Guw6PRt8l1g9yj0VlTKbenZaSJBeUk=";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/

    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];

    // NOTE: app_id设置
    order.app_id = appID;

    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";

    // NOTE: 参数编码格式
    order.charset = @"utf-8";

    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];

    // NOTE: 支付版本
    order.version = @"1.0";

    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";

    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = body;
    order.biz_content.subject = body;
    order.biz_content.out_trade_no = payId; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", money.floatValue ]; //商品价格

    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);

    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }

    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"shaobao";

        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];

        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSDictionary *ret= [resultDic[@"result"] objectFromJSONString][@"alipay_trade_app_pay_response"];
            completionBlock(ret);
        }];
    }
}

#pragma mark 微信支付方法
- (void)WXPay:(NSDictionary *)payInfo body:(NSString *)body payId:(NSString *)payId  callback:(CompletionBlock)completionBlock; {

    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = @"wxc508d5fdc6898b52";

    // 商家id，在注册的时候给的
    req.partnerId = payInfo[@"partnerid"];

    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = payInfo[@"prepayid"];

    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = @"Sign=WXPay";

    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = payInfo[@"noncestr"];

    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = payInfo[@"timestamp"];
    req.timeStamp = stamp.intValue;

    // 这个签名也是后台做的
    req.sign = payInfo[@"sign"];

    //发送请求到微信，等待微信返回onResp
    BOOL ret = [WXApi sendReq:req];


}

@end


