//
//  JMSInPutTextField.h
//  JMS_New
//
//  Created by 黄沐 on 08/06/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSInPutTextField : UIView

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *eyeBtn;

+ (instancetype)inputTextFieldWithFrame:(CGRect) frame WithPlaceholder:(NSString *)placeholder delegate:(id)delegate;

@end
