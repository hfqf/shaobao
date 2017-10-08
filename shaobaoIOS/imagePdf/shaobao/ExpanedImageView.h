//
//  ExpanedImageView.h
//  JZH_Test
//
//  Created by Points on 13-10-28.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface ExpanedImageView : UIView<EGOImageViewDelegate>
{
    UIScrollView *bg;
    EGOImageView *expandImageview;
    CGFloat lastScale;
    CGSize originalSize;
}

- (void)setImage:(UIImage *)image;
- (void)setImageUrl:(NSString *)url placeHolderImage:(UIImage *)image;

@end
