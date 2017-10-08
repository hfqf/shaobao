//
//  ChatInputView.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/8.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

@protocol ChatInputViewDelegate<NSObject>
@required
- (void)onChatInputViewDelegateSendText:(NSString *)msg;
- (void)onChatInputViewDelegateSendLibrary;
- (void)onChatInputViewDelegateSendPhoto;
@end
#import <UIKit/UIKit.h>

@interface ChatInputView : UIView<UITextFieldDelegate>
@property(nonatomic,weak)id<ChatInputViewDelegate>m_delegate;
@end
