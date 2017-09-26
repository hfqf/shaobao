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

- (void)onSelectArea;
@end

#import <UIKit/UIKit.h>


@interface FindFilterView : UIView<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *m_table;
    UITextField *m_startTime;
    UITextField *m_endTime;
}
@property(weak)id<FindFilterViewDelegate>m_delegate;

@property (assign) BOOL m_isSaller;
@property (nonatomic,strong) NSMutableDictionary *m_area;
@property (nonatomic,strong)NSString *m_type;
@property (nonatomic,strong)NSString *m_startTime;
@property (nonatomic,strong)NSString *m_endTime;
@property (nonatomic,strong)NSString *m_state;
@end
