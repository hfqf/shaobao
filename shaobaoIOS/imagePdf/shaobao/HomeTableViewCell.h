//
//  HomeTableViewCell.h
//  shaobao
//
//  Created by points on 2017/9/17.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell{
    EGOImageView *m_head;
    UILabel *m_userType;
    UILabel *m_name;
    UILabel *m_time;

    UILabel *m_address;
    UILabel *m_desc;
    UILabel *m_promiss;
    UILabel *m_state;
}
@property(nonatomic,strong)NSDictionary *infoData;
@end
