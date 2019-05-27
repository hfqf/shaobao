//
//  LZGSGroupViewController.h
//  shaobao
//
//  Created by Points on 2019/5/11.
//  Copyright © 2019 com.kinggrid. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
#import "ADTGroupItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface LZGSGroupViewController : SpeRefreshAndLoadViewController
@property(nonatomic,strong)ADTGroupItem *m_currentGroup;

- (instancetype)initWith:(ADTGroupItem *)parent;
@end

NS_ASSUME_NONNULL_END
