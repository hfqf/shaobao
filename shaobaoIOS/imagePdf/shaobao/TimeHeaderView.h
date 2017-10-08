//
//  TimeHeaderView.h
//  JZH_BASE
//
//  Created by Points on 13-11-13.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeHeaderView : UIView
{
    UIImageView                 *leftLine;
    UILabel                    *m_timeLab;
    UIImageView                 *rightLine;
}

- (void)setTime:(NSString *)time isHidden:(BOOL)flag;
@end
