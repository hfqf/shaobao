//
//  FindFilterView.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/9/21.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

@protocol FindFilterViewDelegate

@required
- (void)onFindFilterViewDelegateSelected:(BOOL)isSaller
                                withArea:(NSDictionary *)area
                                withType:(NSString *)type
                           withStartTime:(NSString *)startTime
                             withEndTime:(NSString *)endTime
                               withState:(NSString *)state;
@end

#import <UIKit/UIKit.h>


@interface FindFilterView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *m_table;
}
@property(weak)id<FindFilterViewDelegate>m_delegate;
@end
