//
//  StaffWorkItemTableViewCell.h
//  shaobao
//
//  Created by Points on 2019/5/16.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//
@protocol StaffWorkItemTableViewCellDelegate <NSObject>

@required

- (void)onWorkItemClicked:(NSString *)item index:(NSInteger )index;

@end
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaffWorkItemTableViewCell : UITableViewCell{
    UILabel *m_tipLab;
    
    UILabel *m_option1Lab;
    UILabel *m_option2Lab;
    UILabel *m_option3Lab;
    UIButton *m_btn1;
    UIButton *m_btn2;
    UIButton *m_btn3;
}

@property(nonatomic,strong) NSString *tip;
@property(nonatomic,assign) NSInteger      index;
@property(nonatomic,weak) id<StaffWorkItemTableViewCellDelegate>m_delegate;
@end


@interface StaffWorkItemTableViewCell2 : UITableViewCell{
    UILabel *m_tipLab;
    UILabel *m_option1Lab;
    UILabel *m_option2Lab;
    UILabel *m_option3Lab;
    UIButton *m_btn1;
    UIButton *m_btn2;
    UIButton *m_btn3;
}

@property(nonatomic,strong)ADTStaffItem *staff;
@property(nonatomic,assign)NSInteger index;
- (void)setStaff:(ADTStaffItem *)staff withIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
