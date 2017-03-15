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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldLengthChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    //NSLog(@"%s", object_getClassName(self));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --------------- UITextFieldDelegate ----------------
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    btnModify.frame = CGRectMake((KSCREEN_WIDTH - GPWIDTH(1077)) / 2, CGRectGetMaxY(tfConfirmPassword.frame) + POINT_Y(114), GPWIDTH(1077), GPHEIGHT(165));
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    btnModify.frame = CGRectMake(0, KSCREEN_HEIGHT - GPHEIGHT(165), KSCREEN_WIDTH, GPHEIGHT(165));
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
    btnModify.frame = CGRectMake(0, KSCREEN_HEIGHT - GPHEIGHT(165), KSCREEN_WIDTH, GPHEIGHT(165));
}

#pragma mark --------------- UIButton点击事件 ----------------
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
//    if (tfNewPassword.text.length == 0) {
//        // 密码不能为空
//        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"password6"]];
//        return;
//    }
    //BOOL updateState = [[DataBaseManager sharedManager] updateDevicePasswordWithDeviceId:_model.deviceId password:tfConfirmPassword.text];
    BOOL updateState = [_model modifyPasswordWithPassword:tfConfirmPassword.text];
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

- (void) textFieldLengthChanged:(NSNotification *) sender{
    if (tfOriginpassword.text.length > 0 &&
        tfNewPassword.text.length > 0 &&
        tfConfirmPassword.text.length > 0) {
        btnModify.enabled = YES;
        btnModify.backgroundColor = THEME_COLOR;
    }
    else{
        btnModify.enabled = NO;
        btnModify.backgroundColor = BTN_ENABLED_BGCOLOR;
    }
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
        label.tag = LB_ORIGIN_TAG + i;
        label.font = [UIFont systemFontOfSize:15];
        CGRect temperatureLabelR = LABEL_RECT(label.text, 0, 0, 1, 15);
        if (temperatureLabelR.size.width > maxRect.size.width) {
            maxRect = temperatureLabelR;
            lbTemp = label;
        }
        [self.view addSubview:label];
    }
    for (int i=0; i<3; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:LB_ORIGIN_TAG + i];
        label.frame = CGRectMake(POINT_X(81), 64 + POINT_Y(129) + POINT_Y(186) * i, maxRect.size.width, maxRect.size.height);
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
    NSArray *placeholders = @[[ChangeLanguage getContentWithKey:@"password8"], [ChangeLanguage getContentWithKey:@"password9"], [ChangeLanguage getContentWithKey:@"password10"]];
    for (int i=0; i<3; i++) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH - CGRectGetMaxX(lbTemp.frame) - GPWIDTH(120), GPHEIGHT(150))];
        if (i == 0) {
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + GPWIDTH(39) + CGRectGetWidth(tf.frame) / 2, lbOriginCenter.y);
            tfOriginpassword = tf;
            [tf becomeFirstResponder];
        }
        else if (i == 1) {
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + GPWIDTH(39) + CGRectGetWidth(tf.frame) / 2, lbNewCenter.y);
            tfNewPassword = tf;
        }
        else{
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + GPWIDTH(39) + CGRectGetWidth(tf.frame) / 2, lbConfirmCenter.y);
            tfConfirmPassword = tf;
        }
        tf.delegate = self;
        tf.keyboardType = UIKeyboardTypeASCIICapable;
        tf.secureTextEntry = YES;
        tf.layer.borderColor = UICOLOR_RGBA(204, 204, 204, 1.0).CGColor;
        tf.layer.borderWidth= 1.0f;
        tf.layer.cornerRadius = 5.0f;
        tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPWIDTH(39), 0)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.returnKeyType = UIReturnKeyDone;
        tf.placeholder = placeholders[i];
        [tf setValue:UICOLOR_RGBA(128, 128, 128, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        [self.view addSubview:tf];
    }
    
    // 创建添加按钮
    btnModify = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnModify];
    btnModify.frame = CGRectMake((KSCREEN_WIDTH - GPWIDTH(1077)) / 2, CGRectGetMaxY(tfConfirmPassword.frame) + POINT_Y(114), GPWIDTH(1077), GPHEIGHT(165));
    [btnModify setTitle:[ChangeLanguage getContentWithKey:@"search16"] forState:UIControlStateNormal];
    btnModify.titleLabel.font = [UIFont systemFontOfSize:20];
    btnModify.backgroundColor = BTN_ENABLED_BGCOLOR;
    btnModify.enabled = NO;
    [btnModify addTarget:self action:@selector(btnModifyClicked:) forControlEvents:UIControlEventTouchUpInside];
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
