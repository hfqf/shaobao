//
//  AddLZGSGroupViewController.m
//  shaobao
//
//  Created by Points on 2019/5/11.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "AddLZGSGroupViewController.h"

@interface AddLZGSGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)ADTGroupItem *m_group;
@property (nonatomic,strong)UITextField *m_input;
@end

@implementation AddLZGSGroupViewController
- (id)initWith:(ADTGroupItem *)parent
{
     self.m_group = parent;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_group.m_isNew?@"新增机构":@"机构详情"];
    if(self.m_group.m_isNew){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setFrame:CGRectMake(MAIN_WIDTH-60, HEIGHT_STATUSBAR, 60, 44)];
        [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        [navigationBG addSubview:rightBtn];
    }else{
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setFrame:CGRectMake(MAIN_WIDTH-60, HEIGHT_STATUSBAR, 60, 44)];
        [rightBtn setTitle:@"评论" forState:UIControlStateNormal];
        [navigationBG addSubview:rightBtn];
    }

}

- (void)rightBtnClicked{
    [self showWaitingView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)highOf:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self highOf:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *iden1 = @"cell2";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    
    UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, MAIN_WIDTH-130, 30)];
    input.delegate = self;
    input.tag = indexPath.row;
    input.layer.cornerRadius = 4;
    input.layer.borderWidth = 0.5;
    input.layer.borderColor = GRAY_3.CGColor;
    input.font = [UIFont systemFontOfSize:14];
    input.returnKeyType = UIReturnKeyDone;
    [cell addSubview:input];
    input.userInteractionEnabled = self.m_group.m_isNew;
    if(indexPath.row == 0){
        [cell.textLabel setText:@"机构名称"];
        
        [input setText:self.m_group.m_name];
    }else if (indexPath.row == 1){
        [cell.textLabel setText:@"地址"];
        [input setText:self.m_group.m_address];
    }else if (indexPath.row == 2){
        [cell.textLabel setText:@"邮箱"];
        [input setText:self.m_group.m_email];
    }else if (indexPath.row == 3){
        [cell.textLabel setText:@"应急电话1"];
        [input setText:self.m_group.m_tel1];
    }else if (indexPath.row == 4){
        [cell.textLabel setText:@"应急电话2"];
        [input setText:self.m_group.m_tel2];
    }else if (indexPath.row == 5){
        [cell.textLabel setText:@"应急电话3"];
        [input setText:self.m_group.m_tel3];
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self highOf:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:GRAY_3];
    [cell addSubview:sep];
    return cell;
}


- (void)addBtnClicked{
    if(self.m_group.m_name.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"机构名称不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_group.m_address.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"机构地址不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_group.m_tel1.length == 0 || self.m_group.m_tel2.length == 0 || self.m_group.m_tel3.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"应急电话不能都为空" inSuperView:self.view withDuration:1];
        return;
    }
    [self showWaitingView];
    [HTTP_MANAGER addOrg:self.m_group.m_orgId
                    name:self.m_group.m_name
                 address:self.m_group.m_address
                   email:self.m_group.m_email
                    tel1:self.m_group.m_tel1
                    tel2:self.m_group.m_tel2
                    tel3:self.m_group.m_tel3
          successedBlock:^(NSDictionary *succeedResult) {
              [self removeWaitingView];
              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
              if([succeedResult[@"ret"]integerValue]==0){
                  [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
              }
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
    }];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.m_input = textField;
    if(textField.tag == 0){
        self.m_group.m_name = textField.text;
    }else if (textField.tag == 1){
        self.m_group.m_address = textField.text;
    }else if (textField.tag == 2){
        self.m_group.m_email = textField.text;
    }else if (textField.tag == 3){
        self.m_group.m_tel1 = textField.text;
    }else if (textField.tag == 4){
        self.m_group.m_tel2 = textField.text;
    }else if (textField.tag == 5){
        self.m_group.m_tel3 = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.m_input = textField;
    if(textField.tag == 0){
        self.m_group.m_name = textField.text;
    }else if (textField.tag == 1){
        self.m_group.m_address = textField.text;
    }else if (textField.tag == 2){
        self.m_group.m_email = textField.text;
    }else if (textField.tag == 3){
        self.m_group.m_tel1 = textField.text;
    }else if (textField.tag == 4){
        self.m_group.m_tel2 = textField.text;
    }else if (textField.tag == 5){
        self.m_group.m_tel3 = textField.text;
    }
    return YES;
}
@end
