//
//  AuthenticationViewController.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/15.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "UIButton+AFNetworking.h"
#import "EGOImageButton.h"
@interface AuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSMutableDictionary *m_authInfo;
@property(nonatomic,strong)NSString *m_pic1;
@property(nonatomic,strong)NSString *m_pic2;
@property(assign)NSInteger m_uploadType;
@end

@implementation AuthenticationViewController
- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_authInfo = [NSMutableDictionary dictionary];
        self.m_arrData = @[
                           @[
                               @{@"name":@"头像"},
                               @{@"name":@"真实姓名*"},
                               @{@"name":@"身份证号码*"},
                               @{@"name":@"手机号码*"},
                               @{@"name":@"邮箱"},
                               @{@"name":@"微信"},
                               @{@"name":@"身份证拍照上传*"},
                               ],
                           @[
                               @{@"name":@"紧急联系人1",},
                               @{@"name":@"姓名",},
                               @{@"name":@"手机",},
                               @{@"name":@"微信",},
                               ],
                           @[
                               @{@"name":@"紧急联系人2",},
                               @{@"name":@"姓名",},
                               @{@"name":@"手机",},
                               @{@"name":@"微信",},
                               ],
                           @[
                               @{@"name":@"提交",},
                               ]
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
    [self.tableView setFrame:CGRectMake(0, 64, MAIN_WIDTH, MAIN_HEIGHT-64-kbSize.height)];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, 64, MAIN_WIDTH, MAIN_HEIGHT-64)];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"身份认证"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadDeals];
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *arr = self.m_arrData;
    return  arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.m_arrData objectAtIndex:section];
    return arr.count;
}

- (float)high:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return 80;
        }else if (indexPath.row == 1){
            return 50;
        }else if (indexPath.row == 2){
            return 50;
        }else if (indexPath.row == 3){
            return 50;
        }else if (indexPath.row == 4){
            return 50;
        }else if (indexPath.row == 5){
            return 50;
        }else if (indexPath.row == 6){
            return 100;
        }

    }else if (indexPath.section == 1 || indexPath.section == 2){
        if(indexPath.row == 0){
            return 30;
        }else{
            return 50;
        }

    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 10)];
    [vi setBackgroundColor:UIColorFromRGB(0xfafafa)];
    return vi;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr =  [self.m_arrData objectAtIndex:indexPath.section];
    NSDictionary *info = [arr objectAtIndex:indexPath.row];
    static NSString * identify = @"spe1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 140, 20)];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:UIColorFromRGB(0x333333)];
    [tip setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:tip];
    [tip setText:info[@"name"]];
    NSString *value  = [self.m_authInfo stringWithFilted:[NSString stringWithFormat:@"%ld",indexPath.section*arr.count+indexPath.row]];

    if(indexPath.section == 0){
        if(indexPath.row == 0){
            EGOImageView *head = [[EGOImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-90, 10, 60, 60)];
            head.layer.cornerRadius = 30;
            head.clipsToBounds = YES;
            [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://121.196.222.155:8800/files",value]] placeholderImage:[UIImage imageNamed:@"logo"]];
            [cell addSubview:head];
        }else if (indexPath.row == 1){
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入真实姓名"];
            [input setText:value];
            input.delegate = self;
            input.tag = indexPath.section*arr.count+indexPath.row;
            [cell addSubview:input];
        }else if (indexPath.row == 2){
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入身份证号码"];
            [input setText:value];
            input.delegate = self;
            input.tag = indexPath.section*arr.count+indexPath.row;
            [cell addSubview:input];

        }else if (indexPath.row == 3){
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入手机号码"];
            [input setText:value];
            input.delegate = self;
            input.tag = indexPath.section*arr.count+indexPath.row;
            [cell addSubview:input];

        }else if (indexPath.row == 4){
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入邮箱"];
            [input setText:value];
            input.delegate = self;
            input.tag = indexPath.section*arr.count+indexPath.row;
            [cell addSubview:input];

        }else if (indexPath.row == 5){
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入微信账号"];
            [input setText:value];
            input.delegate = self;
            input.tag = indexPath.section*arr.count+indexPath.row;
            [cell addSubview:input];

        }else if (indexPath.row == 6){

            [tip setFrame:CGRectMake(10, 10, 200, 20)];

            UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10,30, MAIN_WIDTH/2-10, [self high:indexPath]-30)];
            [tip2 setTextAlignment:NSTextAlignmentLeft];
            [tip2 setTextColor:[UIColor lightGrayColor]];
            [tip2 setFont:[UIFont systemFontOfSize:12]];
            [cell addSubview:tip2];
            tip2.numberOfLines = 0;
            [tip2 setText:@"拍照上传，本人手持身份证上半身清晰照+身份证正面清晰照，共2张"];

             UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sfzBtnClicked)];

            EGOImageButton *btn1 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"find_add"]];
            btn1.userInteractionEnabled = YES;
            [btn1 setFrame:CGRectMake(MAIN_WIDTH-180, 10, 80, 80)];
            [cell addSubview:btn1];
            [btn1 setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://121.196.222.155:8800/files",self.m_pic1]]];
            [btn1 addTarget:self action:@selector(sfzWihtHandBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:[UIColor blackColor] forState:0];

            if(self.m_pic1.length == 0){
                UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-180,63,80, 25)];
                [tip3 setTextAlignment:NSTextAlignmentCenter];
                [tip3 setTextColor:[UIColor lightGrayColor]];
                [tip3 setFont:[UIFont systemFontOfSize:12]];
                [cell addSubview:tip3];
                [tip3 setText:@"手持正面"];
            }


            EGOImageView *btn2 = [[EGOImageView alloc]init];
            btn2.userInteractionEnabled = YES;
            [btn2 setFrame:CGRectMake(MAIN_WIDTH-90, 10, 80, 80)];
            [cell addSubview:btn2];
            [btn2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://121.196.222.155:8800/files",self.m_pic2]] placeholderImage:[UIImage imageNamed:@"find_add"]];
            [btn2 addGestureRecognizer:tap2];

            if(self.m_pic2.length == 0){
                UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-90,63,80, 25)];
                [tip3 setTextAlignment:NSTextAlignmentCenter];
                [tip3 setTextColor:[UIColor lightGrayColor]];
                [tip3 setFont:[UIFont systemFontOfSize:12]];
                [cell addSubview:tip3];
                [tip3 setText:@"正面"];
            }

        }

    }else if (indexPath.section == 1){
        if(indexPath.row == 0){

        }else if(indexPath.row == 1){
            value  = [self.m_authInfo stringWithFilted:@"8"];

            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入联系人姓名"];
            [input setText:value];
            input.delegate = self;
            input.tag = 8;
            [cell addSubview:input];

        }else if(indexPath.row == 2){
            value  = [self.m_authInfo stringWithFilted:@"9"];
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入联系人手机号"];
            [input setText:value];
            input.delegate = self;
            input.tag = 9;
            [cell addSubview:input];
        }else if(indexPath.row == 3){
            value  = [self.m_authInfo stringWithFilted:@"10"];
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入联系人微信号"];
            [input setText:value];
            input.delegate = self;
            input.tag = 10;
            [cell addSubview:input];
        }

    }else if (indexPath.section == 2){
        if(indexPath.row == 0){


        }else if(indexPath.row == 1){
            value  = [self.m_authInfo stringWithFilted:@"12"];
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入联系人姓名"];
            [input setText:value];
            input.delegate = self;
            input.tag = 12;
            [cell addSubview:input];

        }else if(indexPath.row == 2){
            value  = [self.m_authInfo stringWithFilted:@"13"];
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入联系人手机号"];
            [input setText:value];
            input.delegate = self;
            input.tag =13;
            [cell addSubview:input];
        }else if(indexPath.row == 3){
            value  = [self.m_authInfo stringWithFilted:@"14"];
            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(MAIN_WIDTH-150, ([self high:indexPath]-20)/2, 140, 20)];
            [input setFont:[UIFont systemFontOfSize:14]];
            [input setPlaceholder:@"请输入联系人微信号"];
            [input setText:value];
            input.delegate = self;
            input.tag = 14;
            [cell addSubview:input];
        }

    }else{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"提交" forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn setFrame:CGRectMake(10,0, MAIN_WIDTH-20, 50)];
        btn.layer.cornerRadius = 3;
        [btn setBackgroundColor:KEY_COMMON_CORLOR];
        [cell addSubview:btn];
    }

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
    [cell addSubview:sep];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row == 0){
        [self headBtnClicked];
    }
}

- (void)headBtnClicked
{
    self.m_uploadType = 0;
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"相机",@"图库", nil];
    [act showInView:self.view];
}

- (void)sfzWihtHandBtnClicked
{
    self.m_uploadType = 1;
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"相机",@"图库", nil];
    [act showInView:self.view];
}

- (void)sfzBtnClicked
{
    self.m_uploadType = 2;
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"相机",@"图库", nil];
    [act showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [LocalImageHelper selectPhotoFromCamera:self];

    }else{
        [LocalImageHelper selectPhotoFromLibray:self];
    }
}

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
                                       NSString *pic = [NSString stringWithFormat:@"%@",succeedResult[@"data"][@"fileUrl"]];
                                       if(self.m_uploadType == 0){
                                           [self.m_authInfo setObject:pic forKey:@"0"];
                                       }else if(self.m_uploadType == 1){
                                           self.m_pic1 = pic;
                                       }else{
                                           self.m_pic2 = pic;
                                       }
                                       [self reloadDeals];
                                   }

                               } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                   [self removeWaitingView];
                               }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.m_authInfo setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    [self reloadDeals];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.m_authInfo setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    [self reloadDeals];
    return YES;
}

- (void)sendBtnClicked
{
    if(self.m_authInfo[@"1"] == nil){
        [PubllicMaskViewHelper showTipViewWith:@"真实姓名不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_authInfo[@"3"] == nil){
        [PubllicMaskViewHelper showTipViewWith:@"手机号不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_pic1 == nil){
        [PubllicMaskViewHelper showTipViewWith:@"身份证手持正面照不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_pic2 == nil){
        [PubllicMaskViewHelper showTipViewWith:@"身份证正面照不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    [HTTP_MANAGER authentication:self.m_authInfo[@"1"]
                           phone:self.m_authInfo[@"3"]
                          picUrl:[NSString stringWithFormat:@"%@,%@",self.m_pic1,self.m_pic2]
                          avatar:self.m_authInfo[@"0"]
                           email:self.m_authInfo[@"4"]
                          weixin:self.m_authInfo[@"5"]
                              qq:nil
                 contactUserName:self.m_authInfo[@"8"]
                contactUserPhone:self.m_authInfo[@"9"]
               contactUserWeixin:self.m_authInfo[@"10"]
                contactUserName2:self.m_authInfo[@"12"]
               contactUserPhone2:self.m_authInfo[@"13"]
              contactUserWeixin2:self.m_authInfo[@"14"]
                  successedBlock:^(NSDictionary *succeedResult) {
                      [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];

                      if([succeedResult[@"ret"]integerValue]==0){
                          [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                      }

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [PubllicMaskViewHelper showTipViewWith:@"提交失败" inSuperView:self.view withDuration:1];
    }];
}
@end
