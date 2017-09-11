//
//  SignPDFViewController.h
//  SignPDF
//
//  Created by 百润百成 on 2017/1/6.
//  Copyright © 2017年 百润百成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignPDFViewController : UIViewController
typedef void(^BlockOfSave)();
//保存按钮的回调方法
-(void)callBackOfSave:(BlockOfSave)blockOfSave;
@property(nonatomic,strong) NSString *PDFFilePath;
@end
