//
//  ModifyPasswordViewController.m
//  warmwind
//
//  Created by guiping on 17/3/9.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *tfOriginpassword;
    UITextField *tfNewPassword;
    UITextField *tfConfirmPassword;
    UIButton *btnModify;
}

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [ChangeLanguage getContentWithKey:@"search6"];
    
    [self createView];
}

- (void) createView{
    UILabel *lbTemp = nil;
    NSArray *names = @[[ChangeLanguage getContentWithKey:@"password1"], [ChangeLanguage getContentWithKey:@"password2"], [ChangeLanguage getContentWithKey:@"password3"]];
    CGPoint lbOriginCenter = CGPointZero;
    CGPoint lbNewCenter = CGPointZero;
    CGPoint lbConfirmCenter = CGPointZero;
    CGRect maxRect = CGRectZero;
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = names[i];
        label.tag = 647 + i;
        label.font = [UIFont systemFontOfSize:15];
        CGRect temperatureLabelR = HSGetLabelRect(label.text, 0, 0, 1, 15);
        if (temperatureLabelR.size.width > maxRect.size.width) {
            maxRect = temperatureLabelR;
            lbTemp = label;
        }
        [self.view addSubview:label];
    }
    for (int i=0; i<3; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:647 + i];
        label.frame = CGRectMake(GPPointX(81), 64 + GPPointY(129) + GPPointY(186) * i, maxRect.size.width, maxRect.size.height);
        if (i == 0) {
            lbOriginCenter = label.center;
        }
        else if (i == 1) {
            lbNewCenter = label.center;
        }
        else{
            lbConfirmCenter = label.center;
        }
        if (![[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
            [label setAlignmentLeftAndRight];
        }
        else{
            label.textAlignment = NSTextAlignmentRight;
        }
    }
    
    for (int i=0; i<3; i++) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - CGRectGetMaxX(lbTemp.frame) - GPPointX(120), GPPointY(150))];// 120 = 81 + 39
        if (i == 0) {
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + GPPointX(39) + CGRectGetWidth(tf.frame) / 2, lbOriginCenter.y);
            tfOriginpassword = tf;
            [tf becomeFirstResponder];
        }
        else if (i == 1) {
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + GPPointX(39) + CGRectGetWidth(tf.frame) / 2, lbNewCenter.y);
            tfNewPassword = tf;
        }
        else{
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + GPPointX(39) + CGRectGetWidth(tf.frame) / 2, lbConfirmCenter.y);
            tfConfirmPassword = tf;
        }
        tf.delegate = self;
        tf.keyboardType = UIKeyboardTypeASCIICapable;
        tf.secureTextEntry = YES;
        tf.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
        tf.layer.borderWidth= 1.0f;
        tf.layer.cornerRadius = 5.0f;
        tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPPointX(39), 0)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:tf];
    }
    
    // 创建添加按钮
    btnModify = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnModify];
    btnModify.frame = CGRectMake((kScreenWIDTH - GPPointX(1077)) / 2, CGRectGetMaxY(tfConfirmPassword.frame) + GPPointY(114), GPPointX(1077), GPPointY(165));
    [btnModify setTitle:[ChangeLanguage getContentWithKey:@"password7"] forState:UIControlStateNormal];
    btnModify.titleLabel.font = [UIFont systemFontOfSize:20];
    btnModify.backgroundColor = GPColor(250, 126, 20, 1.0);
    [btnModify addTarget:self action:@selector(btnModifyClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) btnModifyClicked:(UIButton *) sender{
    if (![tfOriginpassword.text isEqualToString:_model.password]) {
        //原密码输入错误
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"password4"]];
        return;
    }
    if (![tfNewPassword.text isEqualToString:tfConfirmPassword.text]) {
        // 两次密码输入不一致
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"password5"]];
        return;
    }
    if (tfNewPassword.text.length == 0) {
        // 密码不能为空
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"password6"]];
        return;
    }
    BOOL updateState = [[DataBaseManager sharedManager] updateDevicePasswordWithDeviceId:_model.deviceId password:tfConfirmPassword.text];
    if (updateState) {
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search15"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }
    else{
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search10"]];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    btnModify.frame = CGRectMake((kScreenWIDTH - GPPointX(1077)) / 2, CGRectGetMaxY(tfConfirmPassword.frame) + GPPointY(114), GPPointX(1077), GPPointY(165));
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    btnModify.frame = CGRectMake(0, kScreenHEIGHT - GPPointY(165), kScreenWIDTH, GPPointY(165));
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfNewPassword || textField == tfConfirmPassword) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (textField.text.length >= 32) {
            textField.text = [textField.text substringToIndex:32];
            return NO;
        }
    }
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tfOriginpassword resignFirstResponder];
    [tfNewPassword resignFirstResponder];
    [tfConfirmPassword resignFirstResponder];
    btnModify.frame = CGRectMake(0, kScreenHEIGHT - GPPointY(165), kScreenWIDTH, GPPointY(165));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
