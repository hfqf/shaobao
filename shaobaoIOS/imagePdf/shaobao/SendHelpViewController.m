//
//  SendHelpViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/20.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "SendHelpViewController.h"
#import "SelectProviceViewController.h"
#import "FindSendConfirmOrderViewController.h"
@interface SendHelpViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)ADTHelpInfo *m_helpInfo;
@property(nonatomic,strong)UITextField *m_currentTextField;
@end

@implementation SendHelpViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.m_helpInfo = [[ADTHelpInfo alloc]init];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@""]];
        self.m_helpInfo.m_arrPics = arr;
        [self requestData:YES];

        self.m_arrData = @[
                           @[@"需求信息",@"需求类型",@"需求说明",@"需求区域",@"具体地址"],
                           @[@"费用信息",@"费用承诺",@"定金承诺"],
                           @[@"联系信息",@"发布人",@"手机号码"],
                           @[@"添加图片",@""],
                           ];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"发布需求"];
}


- (void)requestData:(BOOL)isRefresh
{
    self.tableView.tableFooterView = [self footerView];
    [self reloadDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.m_arrData objectAtIndex:section];
    return arr.count;
}

- (CGFloat)high:(NSIndexPath *)path
{
    if(path.row == 0){
        return 30;
    }else if(path.section == 3 && path.row == 1){
        NSInteger sep = 10;
        NSInteger num = 4.0;
        NSInteger width = (MAIN_WIDTH-(num+1)*sep)/num;
        NSInteger row = ceil((self.m_helpInfo.m_arrPics.count*1.0)/num);
        return row *(width+sep*2);
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    NSArray *arr = [self.m_arrData objectAtIndex:indexPath.section];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5, ([self high:indexPath]-20)/2, 120, 20)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setFont:[UIFont systemFontOfSize:15]];
    [tip setText:[arr objectAtIndex:indexPath.row]];
    [cell addSubview:tip];
    [tip setTextColor:UIColorFromRGB(0x333333)];

    if(indexPath.section == 0){
        if(indexPath.row == 0){

        }else if(indexPath.row == 1){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 120, 20)];
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            NSInteger type = self.m_helpInfo.m_type.integerValue;
            if(type == 1){
                [content setText:@"叫人帮忙"];
            }else if (type == 2){
                [content setText:@"律师侦探"];
            }else if (type == 3){
                [content setText:@"护卫保镖"];
            }else if (type == 4){
                [content setText:@"纠纷债务"];
            }else{
                [content setText:@"个性需求"];
            }
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];

        }else if(indexPath.row == 2){

            UITextField *content = [[UITextField alloc]initWithFrame:CGRectMake(100, ([self high:indexPath]-20)/2,MAIN_WIDTH-110, 20)];
            content.tag = 2;
            content.delegate = self;
            content.returnKeyType= UIReturnKeyDone;
            content.placeholder = @"200字以内";
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            [content setText:self.m_helpInfo.m_desc];
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];

        }else if(indexPath.row == 3){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-230, ([self high:indexPath]-20)/2, 200, 20)];
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            NSDictionary *provice = self.m_helpInfo.m_area[@"provice"];
            NSDictionary *city = self.m_helpInfo.m_area[@"city"];
            NSDictionary *area = self.m_helpInfo.m_area[@"area"];
            [content setText:[NSString stringWithFormat:@"%@ %@ %@",provice == nil ? @"" : [provice stringWithFilted:@"name"],city==nil?@"" :[city stringWithFilted:@"name"],area==nil?@"":[area stringWithFilted:@"name"]]];
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];
        }
        else{
            UITextField *content = [[UITextField alloc]initWithFrame:CGRectMake(100, ([self high:indexPath]-20)/2,MAIN_WIDTH-110, 20)];
            content.tag = 4;
            content.delegate = self;
            content.returnKeyType= UIReturnKeyDone;
            content.placeholder = @"请输入具体地址";
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            [content setText:self.m_helpInfo.m_address];
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){

        }else if(indexPath.row == 1){
            UITextField *content = [[UITextField alloc]initWithFrame:CGRectMake(100, ([self high:indexPath]-20)/2,MAIN_WIDTH-110, 20)];
            content.tag = 6;
            content.delegate = self;
            content.returnKeyType= UIReturnKeyDone;
            content.placeholder = @"请输入承诺费用";
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            [content setText:self.m_helpInfo.m_promise1];
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];

        }else if(indexPath.row == 2){

            UITextField *content = [[UITextField alloc]initWithFrame:CGRectMake(100, ([self high:indexPath]-20)/2,MAIN_WIDTH-110, 20)];
            content.tag = 7;
            content.delegate = self;
            content.returnKeyType= UIReturnKeyDone;
            content.placeholder = @"请输入承诺定金";
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            [content setText:self.m_helpInfo.m_promise2];
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];

        }

    }else if (indexPath.section == 2){
        if(indexPath.row == 0){

        }else if(indexPath.row == 1){
            UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 120, 20)];
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            [content setText:[LoginUserUtil shaobaoUserName]];
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];

        }else if(indexPath.row == 2){

            UITextField *content = [[UITextField alloc]initWithFrame:CGRectMake(100, ([self high:indexPath]-20)/2,MAIN_WIDTH-110, 20)];
            content.tag = 10;
            content.delegate = self;
            content.returnKeyType= UIReturnKeyDone;
            content.placeholder = @"请输入手机号码";
            [content setTextAlignment:NSTextAlignmentRight];
            [content setFont:[UIFont systemFontOfSize:15]];
            [content setText:self.m_helpInfo.m_tel];
            [cell addSubview:content];
            [content setTextColor:UIColorFromRGB(0xcdcdcd)];

        }

    }else{
        if(indexPath.row == 0){

        }else{
            for(NSString *url in self.m_helpInfo.m_arrPics){
                NSInteger sep = 10;
                NSInteger num = 4;
                NSInteger index = [self.m_helpInfo.m_arrPics indexOfObject:url];
                NSInteger row = index/num;
                NSInteger coulmn = index%num;
                NSInteger width = (MAIN_WIDTH-(num+1)*sep)/num;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picTaped:)];
                EGOImageView *img = [[EGOImageView alloc]initWithFrame:CGRectMake(sep+(sep+width)*coulmn, sep+(sep+width)*row, width, width)];
                img.tag = index;
                img.userInteractionEnabled = YES;
                [img addGestureRecognizer:tap];
                [img setImageForAllSDK:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://121.196.222.155:8800/files",url]] withDefaultImage:[UIImage imageNamed:@"find_add"]];
                [cell addSubview:img];
            }

        }

    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
    [cell addSubview:sep];
    return cell;
}

- (void)picTaped:(UITapGestureRecognizer *)gest
{
    EGOImageView *v = (EGOImageView *)gest.view;
    if(v.tag == self.m_helpInfo.m_arrPics.count-1){
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库", nil];
        act.tag = 1000;
        [act showInView:self.view];
    }else{

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
         if(indexPath.row == 1){ //需求类型
             UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"叫人帮忙",@"律师侦探",@"护卫保镖",@"纠纷债务",@"个性需求", nil];
             [act showInView:self.view];

        }else if(indexPath.row == 3){//需求区域
            SelectProviceViewController *select = [[SelectProviceViewController alloc]init];
            select.m_delegate = self;
            [self.navigationController pushViewController:select animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 10)];
    [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    return bg;
}

- (UIView *)footerView
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 80)];
    [bg setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(10, 5, MAIN_WIDTH-20, 50)];
    [sendBtn setBackgroundColor:KEY_COMMON_CORLOR];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [bg addSubview:sendBtn];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    sendBtn.layer.cornerRadius = 3;
    return bg;
}

- (void)sendBtnClicked
{
    [self.m_currentTextField resignFirstResponder];
    NSMutableString *pics =[NSMutableString  string];
    for(NSString *url in self.m_helpInfo.m_arrPics){
        if(url.length > 0){
            [pics appendFormat:@"%@,",url];
        }
    }

    if(self.m_helpInfo.m_desc.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"发布内容不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_helpInfo.m_area == nil){
        [PubllicMaskViewHelper showTipViewWith:@"服务区域不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_helpInfo.m_promise1.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"服务费用不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_helpInfo.m_promise2.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"承诺定金不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_helpInfo.m_tel.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"联系人手机号码不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    [self showWaitingView];
    [HTTP_MANAGER findSend:[NSString stringWithFormat:@"%lu",self.m_helpInfo.m_type.integerValue]
                   content:self.m_helpInfo.m_desc
                  province:self.m_helpInfo.m_area[@"provice"][@"id"] city:self.m_helpInfo.m_area[@"city"][@"id"]
                    county:self.m_helpInfo.m_area[@"area"][@"id"]
                   address:self.m_helpInfo.m_address
                serviceFee:self.m_helpInfo.m_promise1
                 creditFee:self.m_helpInfo.m_promise2
                     phone:self.m_helpInfo.m_tel
                    weixin:@""
                        qq:@""
                   picUrls:pics
                     email:self.m_helpInfo.m_email
            successedBlock:^(NSDictionary *succeedResult) {
                [self removeWaitingView];
                if([succeedResult[@"ret"]integerValue] == 0){

                    [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                    ADTFindItem *item = [[ADTFindItem alloc]init];
                    item.m_id = [NSString stringWithFormat:@"%ld",[succeedResult[@"data"][@"helpId"]integerValue]];
                    item.m_creditFee = [NSString stringWithFormat:@"%@", @([succeedResult[@"data"][@"creditFee"]doubleValue])];
                    item.m_serviceFee = [NSString stringWithFormat:@"%@", @([succeedResult[@"data"][@"serviceFee"]doubleValue])];


                    FindSendConfirmOrderViewController *add = [[FindSendConfirmOrderViewController alloc]initWith:item];
                    [self.navigationController pushViewController:add animated:YES];
                    
                }else{
                    [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                }

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                [self removeWaitingView];

        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.m_currentTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 2){
        self.m_helpInfo.m_desc = textField.text;
    }else if (textField.tag == 4){
        self.m_helpInfo.m_address = textField.text;
    }else if (textField.tag == 6){
        self.m_helpInfo.m_promise1 = textField.text;
    }else if (textField.tag == 7){
        self.m_helpInfo.m_promise2 = textField.text;
    }else if (textField.tag == 10){
        self.m_helpInfo.m_tel = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 2){
        self.m_helpInfo.m_desc = textField.text;
    }else if (textField.tag == 4){
        self.m_helpInfo.m_address = textField.text;
    }else if (textField.tag == 6){
        self.m_helpInfo.m_promise1 = textField.text;
    }else if (textField.tag == 7){
        self.m_helpInfo.m_promise2 = textField.text;
    }else if (textField.tag == 10){
        self.m_helpInfo.m_tel = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
- (void)onSelectedProvice:(NSDictionary *)pInfo withCity:(NSDictionary *)cInfo withArea:(NSDictionary *)aInfo
{
    
    NSMutableDictionary *area = [NSMutableDictionary dictionary];
    if(pInfo){
        [area setObject:pInfo forKey:@"provice"];
    }
    if(cInfo){
        [area setObject:cInfo forKey:@"city"];
    }
    if(aInfo){
        [area setObject:aInfo forKey:@"area"];
    }
    self.m_helpInfo.m_area = area;
    [self reloadDeals];
}

//UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1000){
        if(buttonIndex == 0)
        {
            [LocalImageHelper selectPhotoFromCamera:self];
        }else if (buttonIndex == 1)
        {
            [LocalImageHelper selectPhotoFromLibray:self];
        }
        else
        {

        }
    }else{
        self.m_helpInfo.m_type = @(buttonIndex+1);
        [self reloadDeals];
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    [self showWaitingView];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:NO completion:NULL];
    NSString *path = [LocalImageHelper saveImage2:image];
    [HTTP_MANAGER uploadShaobaoFileWithPath:path
                               successBlock:^(NSDictionary *succeedResult) {
                               [self removeWaitingView];
                                   if([succeedResult[@"ret"]integerValue] == 0){
                                       [self.m_helpInfo.m_arrPics insertObject:succeedResult[@"data"][@"fileUrl"] atIndex:self.m_helpInfo.m_arrPics.count-1];
                                       [self reloadDeals];
                                   }

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            [self removeWaitingView];
    }];

}
@end
