//
//  ClassIconImageView.h
//  xxt_xj
//
//  Created by Points on 14-6-18.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@protocol ClassIconImageViewDelegate;

@interface ClassIconImageView : UIImageView
{
    EGOImageView *classIconView;
}
@property(nonatomic,strong) EGOImageView *classIconView;
@property(nonatomic,strong)UIButton *classIconBtn;
@property(nonatomic,retain)id<ClassIconImageViewDelegate> m_headClkDelegate;

- (void)setImage:(UIImage *)img WithSpeWith:(int)sepWidth;

- (void)setNewImage:(id)url withDefaultImg:(NSString *)defaultImgage;

- (void)setNewImage:(id)url WithSpeWith:(int)sepWidth  withDefaultImg:(NSString *)defaultImgage;

- (void)setClassImage:(id)url withDefaultImg:(NSString *)defaultImgage;
@end

@protocol ClassIconImageViewDelegate <NSObject>
@optional
-(void)headBeClicked;
@end
