//
//  EvaStaffViewController.m
//  shaobao
//
//  Created by Points on 2019/5/20.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "EvaStaffViewController.h"
#import "StaffWorkItemTableViewCell.h"
@interface EvaStaffViewController ()<UITableViewDelegate,UITableViewDataSource,StaffWorkItemTableViewCellDelegate>{
   
}
@property (nonatomic,strong)ADTGroupItem *m_group;
@property (nonatomic,strong)ADTStaffItem *m_staff;


@end

@implementation EvaStaffViewController
- (id)initWith:(ADTGroupItem *)group withStaff:(ADTStaffItem *)staff
{
    self.m_group = group;
    self.m_staff = staff;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

- (void)evalueBtnClicked{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"点评"];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setFrame:CGRectMake(MAIN_WIDTH-60, HEIGHT_STATUSBAR, 60, 44)];
//    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [navigationBG addSubview:rightBtn];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 5;
    }else{
        return 7;
    }
    return 0;
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
    NSString *iden1 = @"cell1";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    if(indexPath.section ==0){
        UILabel *input = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, MAIN_WIDTH-130, 30)];
        input.tag = indexPath.row;
        input.layer.cornerRadius = 4;
        input.layer.borderWidth = 0.5;
        input.layer.borderColor = GRAY_3.CGColor;
        input.font = [UIFont systemFontOfSize:14];
        [cell addSubview:input];
        if(indexPath.row == 0){
            [cell.textLabel setText:@"姓名"];
            [input setText:self.m_staff.m_name];
        }else if (indexPath.row == 1){
            [cell.textLabel setText:@"工号"];
            [input setText:self.m_staff.m_jobNumber];
        }else if (indexPath.row == 2){
            [cell.textLabel setText:@"职务"];
            [input setText:self.m_staff.m_duty];
        }else if (indexPath.row == 3){
            [cell.textLabel setText:@"级别"];
            [input setText:self.m_staff.m_grade];
        }else if (indexPath.row == 4){
            [cell.textLabel setText:@"单位"];
            [input setText:self.m_group.m_name];
        }
    }else if(indexPath.section == 1){
        NSString *iden1 = @"cell3";
            StaffWorkItemTableViewCell *cell = [[StaffWorkItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden1];
            cell.m_delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row == 0){
                [cell setTip:@"工作态度"];
//                [cell setIndex:self.m_staff.m_gztd.integerValue];
            }else if (indexPath.row == 1){
                [cell setTip:@"业务能力"];
//                [cell setIndex:self.m_staff.m_ywnl.integerValue];
            }else if (indexPath.row == 2){
                [cell setTip:@"契约精神"];
//                [cell setIndex:self.m_staff.m_qyjs.integerValue];
            }else if (indexPath.row == 3){
                [cell setTip:@"品行品质"];
//                [cell setIndex:self.m_staff.m_pxpz.integerValue];
            }else if (indexPath.row == 4){
                [cell setTip:@"廉洁自律"];
//                [cell setIndex:self.m_staff.m_ljzl.integerValue];
            }else if (indexPath.row == 5){
                [cell setTip:@"社会贡献"];
//                [cell setIndex:self.m_staff.m_shgx.integerValue];
            }else if (indexPath.row == 6){
                [cell setTip:@"自我膨胀"];
//                [cell setIndex:self.m_staff.m_zwpz.integerValue];
            }
            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self highOf:indexPath]-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:GRAY_3];
            [cell addSubview:sep];
            return cell;
   
    }
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,[self highOf:indexPath]-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:GRAY_3];
    [cell addSubview:sep];
    return cell;
}


- (void)addBtnClicked{

}

#pragma mark - StaffWorkItemTableViewCellDelegate
- (void)onWorkItemClicked:(NSString *)item index:(NSInteger)index{
    
    if([item isEqualToString:@"工作态度"]){
        self.m_staff.m_gztd = [NSString stringWithFormat:@"%lu",index];
        NSString *pj1 = @"";
        if(self.m_staff.m_gztd.integerValue == 1){
            pj1 = @"gztd_g";
        }
        
        if(self.m_staff.m_gztd.integerValue == 2){
            pj1 = @"gztd_z";
        }
        
        if(self.m_staff.m_gztd.integerValue == 3){
            pj1 = @"gztd_d";
        }
        [HTTP_MANAGER scorePerson:self.m_staff.m_id
                           option:pj1
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       if([succeedResult[@"ret"]integerValue]==0){
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   }];

    }else if ([item isEqualToString:@"业务能力"]){
        self.m_staff.m_ywnl = [NSString stringWithFormat:@"%lu",index];
        NSString *pj2 = @"";
        if(self.m_staff.m_ywnl.integerValue == 1){
            pj2 = @"ywnl_g";
        }
        
        if(self.m_staff.m_ywnl.integerValue == 2){
            pj2 = @"ywnl_z";
        }
        
        if(self.m_staff.m_ywnl.integerValue == 3){
            pj2 = @"ywnl_d";
        }
        [HTTP_MANAGER scorePerson:self.m_staff.m_id
                           option:pj2
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       if([succeedResult[@"ret"]integerValue]==0){
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   }];
    }else if ([item isEqualToString:@"契约精神"]){
        self.m_staff.m_qyjs = [NSString stringWithFormat:@"%lu",index];
        
        
        NSString *pj3 = @"";
        if(self.m_staff.m_qyjs.integerValue == 1){
            pj3 = @"qyjs_g";
        }
        
        if(self.m_staff.m_qyjs.integerValue == 2){
            pj3 = @"qyjs_z";
        }
        
        if(self.m_staff.m_qyjs.integerValue == 3){
            pj3 = @"qyjs_d";
        }
        [HTTP_MANAGER scorePerson:self.m_staff.m_id
                           option:pj3
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       if([succeedResult[@"ret"]integerValue]==0){
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   }];
    }else if ([item isEqualToString:@"品行品质"]){
        self.m_staff.m_pxpz = [NSString stringWithFormat:@"%lu",index];
        
        NSString *pj4 = @"";
        if(self.m_staff.m_pxpz.integerValue == 1){
            pj4 = @"pxpz_g";
        }
        
        if(self.m_staff.m_pxpz.integerValue == 2){
            pj4 = @"pxpz_z";
        }
        
        if(self.m_staff.m_pxpz.integerValue == 3){
            pj4 = @"pxpz_d";
        }
        [HTTP_MANAGER scorePerson:self.m_staff.m_id
                           option:pj4
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       if([succeedResult[@"ret"]integerValue]==0){
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   }];
    }else if ([item isEqualToString:@"廉洁自律"]){
        self.m_staff.m_ljzl = [NSString stringWithFormat:@"%lu",index];
        
        NSString *pj5 = @"";
        if(self.m_staff.m_ljzl.integerValue == 1){
            pj5 = @"ljzl_g";
        }
        
        if(self.m_staff.m_pxpz.integerValue == 2){
            pj5 = @"ljzl_z";
        }
        
        if(self.m_staff.m_pxpz.integerValue == 3){
            pj5 = @"ljzl_d";
        }
        [HTTP_MANAGER scorePerson:self.m_staff.m_id
                           option:pj5
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       if([succeedResult[@"ret"]integerValue]==0){
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   }];
    }else if ([item isEqualToString:@"社会贡献"]){
        self.m_staff.m_shgx = [NSString stringWithFormat:@"%lu",index];
        
        NSString *pj6 = @"";
        if(self.m_staff.m_shgx.integerValue == 1){
            pj6 = @"shgx_g";
        }
        
        if(self.m_staff.m_shgx.integerValue == 2){
            pj6 = @"shgx_z";
        }
        
        if(self.m_staff.m_shgx.integerValue == 3){
            pj6 = @"shgx_d";
        }

        [HTTP_MANAGER scorePerson:self.m_staff.m_id
                           option:pj6
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       if([succeedResult[@"ret"]integerValue]==0){
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   }];
    }else if ([item isEqualToString:@"自我膨胀"]){
        self.m_staff.m_zwpz = [NSString stringWithFormat:@"%lu",index];
    
        
        NSString *pj7 = @"";
        if(self.m_staff.m_zwpz.integerValue == 1){
            pj7 = @"zwpz_g";
        }
        
        if(self.m_staff.m_zwpz.integerValue == 2){
            pj7 = @"zwpz_z";
        }
        
        if(self.m_staff.m_zwpz.integerValue == 3){
            pj7 = @"zwpz_d";
        }
        [HTTP_MANAGER scorePerson:self.m_staff.m_id
                           option:pj7
                   successedBlock:^(NSDictionary *succeedResult) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       if([succeedResult[@"ret"]integerValue]==0){
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                       }
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                   }];
    }else{
        
    }
    
    
   
    [self reloadDeals];
}




@end

