//
//  ChatInputView.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ChatInputView.h"

@implementation ChatInputView

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:UIColorFromRGB(0xF9F9F9)];
        self.layer.borderColor = UIColorFromRGB(0xEBEBEB).CGColor;
        self.layer.borderWidth = 0.5;

        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 addTarget:self action:@selector(btn1Clicked) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setFrame:CGRectMake(0, 0, 40, 50)];
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
        [btn1 setImage:[UIImage imageNamed:@"chat_library"] forState:UIControlStateNormal];
        [self addSubview:btn1];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
        [btn2 addTarget:self action:@selector(btn2Clicked) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setFrame:CGRectMake(40, 0, 40, 50)];
        [btn2 setImage:[UIImage imageNamed:@"chat_photo"] forState:UIControlStateNormal];
        [self addSubview:btn2];

        UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, MAIN_WIDTH-95, 40)];
        [input setBackgroundColor:UIColorFromRGB(0xffffff)];
        input.layer.borderColor = UIColorFromRGB(0xEBEBEB).CGColor;
        input.layer.borderWidth = 0.5;
        input.layer.cornerRadius = 3;
        [self addSubview:input];
        input.delegate = self;
        input.returnKeyType = UIReturnKeySend;
    }
    return self;
}

- (void)btn1Clicked
{
    [self.m_delegate onChatInputViewDelegateSendLibrary];
}

- (void)btn2Clicked
{
    [self.m_delegate onChatInputViewDelegateSendPhoto];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.m_delegate onChatInputViewDelegateSendText:textField.text];
    [textField setText:nil];
    return YES;
}

@end
