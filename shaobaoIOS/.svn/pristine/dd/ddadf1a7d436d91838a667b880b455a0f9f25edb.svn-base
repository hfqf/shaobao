//
//  TabbarCustomButton.h
//  xxt_xj
//
//  Created by Points on 13-12-20.
//  Copyright (c) 2013年 Points. All rights reserved.
//
@class TabbarCustomButton;
@protocol TabbarCustomButtonDelegate <NSObject>

@required
- (void)onSelectedIndex:(TabbarCustomButton *)selectedBtn;
@end
#import <UIKit/UIKit.h>
#import "LKBadgeView.h"

@interface TabbarCustomButton : UIButton
{
    UILabel * titleLab;
    LKBadgeView *m_numLab;
}
@property(weak)id<TabbarCustomButtonDelegate>m_delegate;

@property(nonatomic, assign) NSInteger index;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withUnselectedImg:(NSString *)unSelectedImg withSelectedImg:(NSString *)selecredImg withUnreadType:(ENUM_UNREAD_MESSAGE_TYPE)type;

- (void)setButton:(BOOL)isSelected;
@end
