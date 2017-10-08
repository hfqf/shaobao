//
//  ReceivedImageview.m
//  JZH_Test
//
//  Created by Points on 13-10-28.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "ReceivedImageview.h"
#import "ExpanedImageView.h"
#import "LocalImageHelper.h"
@implementation ReceivedImageview
@synthesize m_delegate,m_origianPicturePath;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        self.isLocationSnap = NO;
        m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_btn setBackgroundColor:[UIColor clearColor]];
        [m_btn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //[m_btn addTarget:self action:@selector(imageTouched) forControlEvents:UIControlEventTouchDown];
        [self addSubview:m_btn];
        
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouched)];
        [m_btn addGestureRecognizer:tap];

        UILongPressGestureRecognizer * longPressed  = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPressed.delegate = self;
        [m_btn addGestureRecognizer:longPressed];
    }
    return self;
}


- (void)setNewFrame:(CGRect)frame
{
    [self setFrame:frame];
    [m_btn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)imageTouched
{
    SpeLog(@"imageTouched");
    self.isLocationSnap ? [self watchFullScreenMap] : [self expandImage:nil];
}

- (void)expandImage:(id)sender
{
    
    //如果已有imageid
    if(self.m_strImageUrl)
    {
        if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onSeeCurrentImageIdBigPic:)])
        {
            [self.m_delegate onSeeCurrentImageIdBigPic:self.m_strImageUrl];
        }
        return;
        
    }
    SpeLog(@"expandImage");
    ExpanedImageView *fullImageview = [[ExpanedImageView alloc]initWithFrame:CGRectMake(0,20, MAIN_WIDTH, MAIN_HEIGHT-20)];
    
    BOOL exist = NO;
    
    if ([self.m_origianPicturePath isKindOfClass:[NSString class]]) {
        exist = [[NSFileManager defaultManager] fileExistsAtPath:self.m_origianPicturePath];
    }
    
    if(self.m_origianPicturePath == nil || !exist)
    {
        [fullImageview setImage:self.image];
    }
    else
    {
        [fullImageview setImage:[UIImage imageWithContentsOfFile:self.m_origianPicturePath]];
    }
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(hideKeyboard)])
    {
        [self.m_delegate hideKeyboard];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:fullImageview];
    
}

- (void)watchFullScreenMap
{
    SpeLog(@"watchFullScreenMap");
    [self.m_delegate onSeeAllPic:self.tag];
}



#pragma mark - long press

- (void)longPress:(UIGestureRecognizer *)gest
{
    SpeLog(@"longPress");
    if(gest.state == UIGestureRecognizerStateBegan)
    {
        if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(longPressedInReceivedImageview)])
        {
            [self.m_delegate longPressedInReceivedImageview];
        }
    }
    
}

// 询问delegate，两个手势是否同时接收消息，返回YES同事接收。返回NO，不同是接收（如果另外一个手势返回YES，则并不能保证不同时接收消息）
// 这个函数一般在一个手势接收者要阻止另外一个手势接收自己的消息的时候调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
@end
