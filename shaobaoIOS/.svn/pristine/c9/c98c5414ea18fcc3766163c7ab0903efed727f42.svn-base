//
//  SpeCommonTableView.m
//  xxt_xj
//
//  Created by Points on 13-12-18.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "SpeCommonTableView.h"

@implementation SpeCommonTableView


- (id)initWithFrame:(CGRect)frame
              Style:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
 withViewController:(id<MJRefreshBaseViewDelegate>)VC
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
        if(isNeedPullDownRefresh)
        {
            self._header = [[MJRefreshHeaderView alloc]init];
            self._header.scrollView = self;
            self._header.delegate = VC;
        }
        
        if(isNeesLoadMore)
        {
            self._footer = [[MJRefreshFooterView alloc]init];;
            self._footer.scrollView = self;
            self._footer.delegate = VC;
        }
    }
    return self;
}

@end
