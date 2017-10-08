//
//  ClassIconImageView.m
//  xxt_xj
//
//  Created by Points on 14-6-18.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "ClassIconImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ClassIconImageView
@synthesize classIconView= classIconView;


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        classIconView = [[EGOImageView alloc]initWithFrame:CGRectMake(3,3, frame.size.width-6, frame.size.height-6)];
        classIconView.userInteractionEnabled = NO;
        [self addSubview:classIconView];
        
        
        self.classIconBtn = [[UIButton alloc]initWithFrame:CGRectMake(3,3, frame.size.width-6, frame.size.height-6)];
        [self.classIconBtn addTarget:self action:@selector(headIconClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.classIconBtn];
        
    }
    return self;
}

- (void)setNewImage:(id)url withDefaultImg:(NSString *)defaultImgage
{
    
    [self setImage:[UIImage imageNamed:@"parent_head_boundry"]];
    classIconView.layer.masksToBounds = YES;
    classIconView.layer.cornerRadius = (self.frame.size.width-6)/2;
    
    if([url isKindOfClass:[NSURL class]])
    {
        if([[(NSURL *)url absoluteString]rangeOfString:@"jpg"].length == 0 && [[(NSURL *)url absoluteString]rangeOfString:@"png"].length == 0)
        {
            [classIconView setImageForAllSDK:nil withDefaultImage:[UIImage imageNamed:defaultImgage]];
        }
        else
        {
            [classIconView setImageForAllSDK:(NSURL *)url withDefaultImage:[UIImage imageNamed:defaultImgage]];
        }
        
    }
    else
    {
        [classIconView setImage:(UIImage *)url];
    }
}

- (void)setNewImage:(id)url WithSpeWith:(int)sepWidth withDefaultImg:(NSString *)defaultImgage
{
    [classIconView setFrame:CGRectMake(sepWidth,sepWidth, self.frame.size.width-sepWidth*2, self.frame.size.height-sepWidth*2)];
    [self setImage:[UIImage imageNamed:@"parent_head_boundry"]];
    classIconView.layer.masksToBounds = YES;
    classIconView.layer.cornerRadius = (self.frame.size.width-sepWidth*2)/2;
    
    if([url isKindOfClass:[NSURL class]] && url != nil)
    {
        [classIconView setImageForAllSDK:(NSURL *)url withDefaultImage:[UIImage imageNamed:defaultImgage]];
    }
    else if ([url isKindOfClass:[NSString class]] && url != nil)
    {
        [classIconView setImageForAllSDK:[NSURL URLWithString:url] withDefaultImage:[UIImage imageNamed:defaultImgage]];
    }
    else
    {
        [classIconView setImage:(UIImage *)url];
    }
}

- (void)setImage:(UIImage *)img WithSpeWith:(int)sepWidth
{
    [classIconView setFrame:CGRectMake(sepWidth,sepWidth, self.frame.size.width-sepWidth*2, self.frame.size.height-sepWidth*2)];
    [self setImage:img];
    classIconView.layer.masksToBounds = YES;
    classIconView.layer.cornerRadius = (self.frame.size.width-sepWidth*2)/2;
    
    
}

- (void)setClassImage:(id)url withDefaultImg:(NSString *)defaultImgage
{
    if([url isKindOfClass:[NSURL class]])
    {
        if([[(NSURL *)url absoluteString]rangeOfString:@"jpg"].length == 0 && [[(NSURL *)url absoluteString]rangeOfString:@"png"].length == 0)
        {
            [classIconView setImageForAllSDK:nil withDefaultImage:[UIImage imageNamed:defaultImgage]];
        }
        else
        {
            [classIconView setImageForAllSDK:(NSURL *)url withDefaultImage:[UIImage imageNamed:defaultImgage]];
        }
        
    }
    else
    {
        [classIconView setImage:(UIImage *)url];
    }
}

-(void)headIconClicked{
    if(self.m_headClkDelegate && [self.m_headClkDelegate respondsToSelector:@selector(headBeClicked)])
    {
        [self.m_headClkDelegate headBeClicked];
    }
}

@end
