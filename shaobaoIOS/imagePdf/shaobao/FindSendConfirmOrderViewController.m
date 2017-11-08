//
//  FindSendConfirmOrderViewController.m
//  shaobao
//
//  Created by points on 2017/10/10.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "FindSendConfirmOrderViewController.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
@interface FindSendConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,WXApiDelegate>
{
    UIButton *btn;
}
@property(nonatomic,strong)ADTFindItem *m_helpInfo;
@property(nonatomic,strong)NSString *m_netMoney;
@property(nonatomic,strong)NSString *m_weixnPayId;


@end

@implementation FindSendConfirmOrderViewController
- (id)initWith:(ADTFindItem *)item
{
    self.m_helpInfo = item;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
        self.m_netMoney = @"0";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"确认订单"];

    [[NSNotificationCenter defaultCenter]addObserverForName:kWeixinPay object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {

        PayResp *resp = note.object;

        [HTTP_MANAGER payResult:self.m_weixnPayId
                     resultCode:@"SUCCESS"
                responseContent:@""
                 successedBlock:^(NSDictionary *succeedResult1) {

                     if([succeedResult1[@"ret"]integerValue] == 0){
                         [PubllicMaskViewHelper showTipViewWith:succeedResult1[@"msg"] inSuperView:self.view withDuration:1];
                         [self performSelector:@selector(backToMain) withObject:nil afterDelay:1];
                     }else{
                         [PubllicMaskViewHelper showTipViewWith:succeedResult1[@"msg"] inSuperView:self.view withDuration:1];

                     }

                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                     [PubllicMaskViewHelper showTipViewWith:@"支付失败" inSuperView:self.view withDuration:1];

                 }];

    }];
}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER getCash:^(NSDictionary *succeedResult) {

        if([succeedResult[@"ret"]integerValue]==0){
            self.m_netMoney = succeedResult[@"data"][@"netMoney"];
//            self.m_netMoney =@"1000";
        }
        [self reloadDeals];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self reloadDeals];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 7 ? 60 : 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor clearColor]];

    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(10,0, MAIN_WIDTH-20, indexPath.row == 7 ? 60 : 40)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:bg];

    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 120, 20)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:UIColorFromRGB(0x333333)];
    [tip setFont:[UIFont systemFontOfSize:15]];
    [bg addSubview:tip];


    UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-200, 15, 170, 20)];
    [value setTextAlignment:NSTextAlignmentRight];
    [value setTextColor:UIColorFromRGB(0x333333)];
    [value setFont:[UIFont systemFontOfSize:15]];
    [bg addSubview:value];

    if(indexPath.row == 0){
        [tip setText:@"订单编号"];
        [value setText:self.m_helpInfo.m_id];

    }else if (indexPath.row == 1){
        [tip setText:@"服务费用"];
        [value setText:[NSString stringWithFormat:@"%@元",self.m_helpInfo.m_serviceFee]];
    }else if (indexPath.row == 2){
        [tip setText:@"履约定金"];
        [value setText:[NSString stringWithFormat:@"%@元",self.m_helpInfo.m_creditFee]];
    }else if (indexPath.row == 3){
        [tip setText:@"合计"];

        [value setText:[NSString stringWithFormat:@"%.2f元",[self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]]];
    }else if (indexPath.row == 4){
        [tip setText:@"网钞币余额"];

        [value setText:[NSString stringWithFormat:@"%@网币",self.m_netMoney]];
    }else if (indexPath.row == 5){

        if(btn == nil){
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.selected = NO;
        }
        [btn addTarget:self action:@selector(sameFeeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(MAIN_WIDTH-120,5, 30, 30)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [btn setImage:[UIImage imageNamed:@"find_select_un"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"find_select_on"] forState:UIControlStateSelected];
        [bg addSubview:btn];

        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-90,12,80, 16)];
        [content setTextAlignment:NSTextAlignmentLeft];
        [content setFont:[UIFont systemFontOfSize:14]];
        [content setText:@"网钞币抵扣"];
        [bg addSubview:content];
        [content setTextColor:[UIColor blackColor]];

    }else if (indexPath.row == 6){
        [tip setText:@"实付款"];


        if(btn.selected){
            float more = 0.0;
            if([self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]-[self.m_netMoney floatValue] >0){
                more = [self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]-[self.m_netMoney floatValue];
            }else{
                more = 0;
            }

            [value setText:[NSString stringWithFormat:@"%.2f元",more]];
        }else{
            [value setText:[NSString stringWithFormat:@"%.2f元",[self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]]];
        }
    }else if (indexPath.row == 7){

        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setFrame:CGRectMake(10, 10, MAIN_WIDTH-40, 40)];
        [sendBtn setBackgroundColor:KEY_COMMON_CORLOR];
        [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [bg addSubview:sendBtn];
        [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        sendBtn.layer.cornerRadius = 3;

    }
    return cell;
}

- (void)sameFeeBtnClicked:(UIButton *)_btn
{
    if(self.m_netMoney.floatValue >= [self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]){
        _btn.selected = !_btn.selected;
        [self reloadDeals];
    }else{
        [PubllicMaskViewHelper showTipViewWith:@"网币余额不够抵扣" inSuperView:self.view withDuration:1];
    }
}

- (void)backToMain
{
    NSArray *arr = self.navigationController.viewControllers;
    for(UIViewController *vc in arr){
        if([vc isKindOfClass:NSClassFromString(@"MainTabBarViewController")]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
- (void)sendBtnClicked
{
    if(btn.selected){//有网币抵扣

        float more = 0.0;
        if([self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]<=[self.m_netMoney floatValue]){

            [HTTP_MANAGER netMoneyPay:self.m_helpInfo.m_id
                           serviceFee:self.m_helpInfo.m_serviceFee
                            creditFee:self.m_helpInfo.m_creditFee
                                total:[NSString stringWithFormat:@"%@", @([self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue])]
                             netMoney:[NSString stringWithFormat:@"%@", @([self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue])]
                             relMoney:[NSString stringWithFormat:@"%@", @(more)]
                       successedBlock:^(NSDictionary *succeedResult) {

                           if([succeedResult[@"ret"]integerValue] == 0){
                               [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];

                               [self performSelector:@selector(backToMain) withObject:nil afterDelay:1];
                           }else{
                               [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                           }


                       } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {



                       }];

        }else{//还要通过第三方支付的金额

            UIActionSheet *act =[[UIActionSheet alloc]initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
            [act showInView:self.view];

        }




    }else{

        UIActionSheet *act =[[UIActionSheet alloc]initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
        [act showInView:self.view];
    }

}


- (NSString *)generateTradeNO
{
    static int kNumber = 15;

    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){

        NSString *netMoney = btn.selected?self.m_netMoney : @"0";
        NSString *relMoney = [NSString stringWithFormat:@"%.2f",[self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]-[netMoney floatValue]];
        [HTTP_MANAGER aliPay:self.m_helpInfo.m_id
                       serviceFee:self.m_helpInfo.m_serviceFee
                        creditFee:self.m_helpInfo.m_creditFee
                            total:[NSString stringWithFormat:@"%@", @([self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue])] 
                         netMoney:[NSString stringWithFormat:@"%@", @([netMoney doubleValue])]
                         relMoney:[NSString stringWithFormat:@"%@", @([relMoney doubleValue])]
                   successedBlock:^(NSDictionary *succeedResult) {


                       if([succeedResult[@"ret"]integerValue] == 0){

                           NSString *payId = succeedResult[@"data"][@"payId"];
                           [self doAlipayPay:relMoney
                                        body:self.m_helpInfo.m_content
                                       payId:payId
                                    callback:^(NSDictionary *resultDic) {
                                        if([resultDic[@"code"]integerValue] == 10000){

                                            [HTTP_MANAGER payResult:payId
                                                         resultCode:@"SUCCESS"
                                                    responseContent:[resultDic JSONString]
                                                     successedBlock:^(NSDictionary *succeedResult1) {


                                                         if([succeedResult1[@"ret"]integerValue] == 0){
                                                             [PubllicMaskViewHelper showTipViewWith:succeedResult1[@"msg"] inSuperView:self.view withDuration:1];

                                                             [self performSelector:@selector(backToMain) withObject:nil afterDelay:1];
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
                           [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       }




                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {



                   }];





    }else if (buttonIndex == 1){

        NSString *netMoney = btn.selected?self.m_netMoney : @"0";
        NSString *relMoney = [NSString stringWithFormat:@"%.2f",[self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue]-[netMoney floatValue]];
        [HTTP_MANAGER wxPay:self.m_helpInfo.m_id
                  serviceFee:self.m_helpInfo.m_serviceFee
                   creditFee:self.m_helpInfo.m_creditFee
                       total:[NSString stringWithFormat:@"%@", @([self.m_helpInfo.m_serviceFee floatValue]+[self.m_helpInfo.m_creditFee floatValue])]
                    netMoney:[NSString stringWithFormat:@"%@", @([netMoney doubleValue])]
                    relMoney:[NSString stringWithFormat:@"%@", @([relMoney doubleValue])]
              successedBlock:^(NSDictionary *succeedResult) {


                  if([succeedResult[@"ret"]integerValue] == 0){

                      NSString *payId = succeedResult[@"data"][@"payId"];
                      self.m_weixnPayId = payId;
                      [self WXPay:succeedResult[@"data"]
                                   body:self.m_helpInfo.m_content
                                  payId:payId
                               callback:^(NSDictionary *resultDic) {
                                   if([resultDic[@"code"]integerValue] == 10000){



                                   }else{
                                       [PubllicMaskViewHelper showTipViewWith:resultDic[@"msg"] inSuperView:self.view withDuration:1];
                                   }
                               }];
                  }else{
                      [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                  }




              } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {



              }];





    }else if (buttonIndex == 2){

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



@end
