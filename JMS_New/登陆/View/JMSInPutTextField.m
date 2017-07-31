//
//  JMSInPutTextField.m
//  JMS_New
//
//  Created by 黄沐 on 08/06/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSInPutTextField.h"

#define RGBA(r, g, b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@implementation JMSInPutTextField

+(instancetype)inputTextFieldWithFrame:(CGRect)frame WithPlaceholder:(NSString *)placeholder delegate:(id)delegate{
    JMSInPutTextField *inputTextField = [[JMSInPutTextField alloc]initWithFrame:frame];
    UITextField *phoneTextField = [[UITextField alloc]init];
    phoneTextField.delegate = delegate;
    inputTextField.textField = phoneTextField;
    phoneTextField.font = [UIFont systemFontOfSize:16];
    phoneTextField.placeholder = placeholder;
    [inputTextField addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(inputTextField);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBA(238, 238, 238, 1);
    [inputTextField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(inputTextField);
        make.height.equalTo(@1);
    }];
    UIButton *eyeBtn = [[UIButton alloc]init];
    inputTextField.eyeBtn = eyeBtn;
    eyeBtn.hidden = YES;
    [eyeBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [inputTextField addSubview:eyeBtn];
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@42);
        make.right.top.bottom.equalTo(inputTextField);
    }];
    [eyeBtn addTarget:inputTextField action:@selector(eyeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    return inputTextField;
}


#pragma mark --眼睛点击 标识符
-(void)eyeBtnClick{
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
