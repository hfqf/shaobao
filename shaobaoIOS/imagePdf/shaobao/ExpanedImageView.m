//
//  ExpanedImageView.m
//  JZH_Test
//
//  Created by Points on 13-10-28.
//  Copyright (c) 2013年 Points. All rights reserved.
//
#define MAX_EXPAND_NUM   3//最大放大倍数
#define MAX_HEIGHT_PIC (MAIN_HEIGHT-44-DISTANCE_TOP-40-(HEIGTH_IS_480 && !OS_ABOVE_IOS7 ? HEIGHT_STATUSBAR : 0))
#import "ExpanedImageView.h"
#import "NSData+Image.h"

@implementation ExpanedImageView

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        bg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, frame.size.height)];
//        [bg setBackgroundColor:[UIColor clearColor]];
//        bg.userInteractionEnabled = YES;
//        [self addSubview:bg];
        
//        UIImageView *navi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION - 20)];
//        navi.userInteractionEnabled = YES;
//        navi.backgroundColor = NAVIGATIONBGBACKGROUNDCOLOR;
////        [navi setImage:[UIImage imageNamed:@"navigationBG"]];
//        [self addSubview:navi];
//        [navi release];
//        
//        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(31,0, MAIN_WIDTH - 62, HEIGHT_NAVIGATION - 20)];
//        [title setBackgroundColor:[UIColor clearColor]];
//        [title setFont:[UIFont systemFontOfSize:16]];
//        [title setTextColor:[UIColor blackColor]];
//        [title setTextAlignment:NSTextAlignmentCenter];
//        [title setText:@"图片"];
//        [navi addSubview:title];
//        [title release];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(0,0,MAIN_WIDTH, frame.size.height)];
        [backBtn setBackgroundColor:[UIColor clearColor]];
        [backBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"topbar_back"] forState:UIControlStateNormal];
        [self addSubview:backBtn];
//        [backBtn release];
        
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.userInteractionEnabled  = YES;
        expandImageview = [[EGOImageView alloc]init];
        expandImageview.clipsToBounds = YES;
        expandImageview.userInteractionEnabled = YES;
        [expandImageview setBackgroundColor:[UIColor clearColor]];
        [self addSubview:expandImageview];

        
//        UIPinchGestureRecognizer *pinTap = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
//        [expandImageview addGestureRecognizer:pinTap];
//        [pinTap release];
        lastScale = 1.0;
        
        
    }
    return self;
}

- (void)setImageUrl:(NSString *)url placeHolderImage:(UIImage *)image
{
    expandImageview.placeholderImage = image;
    expandImageview.delegate = self;
    expandImageview.imageURL = [NSURL URLWithString:url];
}

- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    CGSize size = imageView.image.size;
    [self setSize:size];
    
    NSData* data = [NSData dataWithImage:imageView.image];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[imageView.imageURL absoluteString]];
}

- (void)setImage:(UIImage *)image
{
    [expandImageview setImage:image];
    CGSize size = image.size;
    [self setSize:size];
}

- (void)setSize:(CGSize)size
{
    SpeLog(@"ExpanedImageView setSize:%f,%f", size.width, size.height);
    if(size.height>=MAIN_WIDTH || size.width >= MAX_HEIGHT_PIC)
    {
        CGSize currentSize = CGSizeZero;
        if(size.height > size.width)
        {
            currentSize = CGSizeMake(size.width/size.height*MAX_HEIGHT_PIC , MAX_HEIGHT_PIC);
            [expandImageview setFrame:CGRectMake((MAIN_WIDTH-currentSize.width)/2, (MAIN_HEIGHT - currentSize.height)/2, currentSize.width, currentSize.height)];
            
        }
        else
        {
            currentSize = CGSizeMake(MAIN_WIDTH , size.height/size.width*MAIN_WIDTH);
            [expandImageview setFrame:CGRectMake(0, (MAX_HEIGHT_PIC-currentSize.height)/2, currentSize.width, currentSize.height)];
        }
        
        originalSize = currentSize;
        
    }
    else
    {
        if(size.height < 200)
        {
            originalSize = CGSizeMake(200 , size.height/size.width*200);

        }
        else
        {
            originalSize = size;

        }
        [expandImageview setFrame:CGRectMake((MAIN_WIDTH-originalSize.width)/2,(MAX_HEIGHT_PIC-originalSize.height)/2, originalSize.width, originalSize.height)];
    }
}
-(void)scaGesture:(id)sender
{
    UIPinchGestureRecognizer*gest = (UIPinchGestureRecognizer *)sender;
    //当手指离开屏幕时,将lastscale设置为1.0
    if(gest.state == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (lastScale -gest.scale);
    if(scale*originalSize.height > MAX_HEIGHT_PIC*MAX_EXPAND_NUM || scale*originalSize.width > MAIN_WIDTH*MAX_EXPAND_NUM)
    {
        return;
    }
    CGAffineTransform currentTransform = expandImageview.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [expandImageview setTransform:newTransform];
    lastScale = gest.scale;
    
    originalSize = CGSizeMake(scale*originalSize.width, scale*originalSize.height);
    
    [bg setContentSize:originalSize];
    if(originalSize.height < MAIN_WIDTH || originalSize.width < MAX_HEIGHT_PIC)
    {
//        if(originalSize.height > originalSize.width)
//        {
        [expandImageview setFrame:CGRectMake((MAIN_WIDTH - expandImageview.frame.size.width)/2,  44+(MAX_HEIGHT_PIC-expandImageview.frame.size.height)/2 , expandImageview.frame.size.width, expandImageview.frame.size.height)];
            
//        }
//        else
//        {
//            [expandImageview setFrame:CGRectMake(0, 44+DISTANCE_TOP+20+(MAX_HEIGHT_PIC-currentSize.height)/2, expandImageview.frame.size.width, expandImageview.frame.size.height)];
//        }
    }
    else
    {
       [expandImageview setFrame:CGRectMake((originalSize.width-expandImageview.frame.size.width)/2, (originalSize.height-expandImageview.frame.size.height)/2, expandImageview.frame.size.width, expandImageview.frame.size.width)];
    }
    
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)closeSelf
{
    [self removeFromSuperview];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
