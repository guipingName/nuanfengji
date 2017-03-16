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
    
    self.title = CURRENT_LANGUAGE(@"修改密码 ");
    
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
    btnModify.frame = CGRectMake((KSCREEN_WIDTH - UIWIDTH(1077)) / 2, CGRectGetMaxY(tfConfirmPassword.frame) + POINT_Y(114), UIWIDTH(1077), UIHEIGHT(165));
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    btnModify.frame = CGRectMake(0, KSCREEN_HEIGHT - UIHEIGHT(165), KSCREEN_WIDTH, UIHEIGHT(165));
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
    btnModify.frame = CGRectMake(0, KSCREEN_HEIGHT - UIHEIGHT(165), KSCREEN_WIDTH, UIHEIGHT(165));
}

#pragma mark --------------- UIButton点击事件 ----------------
- (void) btnModifyClicked:(UIButton *) sender{
    if (![tfOriginpassword.text isEqualToString:_model.password]) {
        //原密码输入错误
        [GPUtil hintView:self.view message:CURRENT_LANGUAGE(@"旧密码错误")];
        return;
    }
    if (![tfNewPassword.text isEqualToString:tfConfirmPassword.text]) {
        // 两次密码输入不一致
        [GPUtil hintView:self.view message:CURRENT_LANGUAGE(@"密码不一致")];
        return;
    }
    BOOL updateState = [_model modifyPasswordWithPassword:tfConfirmPassword.text];
    if (updateState) {
        [GPUtil hintView:self.view message:CURRENT_LANGUAGE(@"修改成功")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }
    else{
        [GPUtil hintView:self.view message:CURRENT_LANGUAGE(@"修改失败")];
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
    NSArray *names = @[CURRENT_LANGUAGE(@"旧密码"), CURRENT_LANGUAGE(@"新密码"), CURRENT_LANGUAGE(@"确认密码")];
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
    NSArray *placeholders = @[CURRENT_LANGUAGE(@"请输入旧密码"), CURRENT_LANGUAGE(@"请输入新密码"), CURRENT_LANGUAGE(@"请再次输入新密码")];
    for (int i=0; i<3; i++) {
        UITextField *tf = [GPUtil createTextField];
        tf.frame = CGRectMake(0, 0, KSCREEN_WIDTH - CGRectGetMaxX(lbTemp.frame) - UIWIDTH(120), UIHEIGHT(150));
        if (i == 0) {
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + UIWIDTH(39) + CGRectGetWidth(tf.frame) / 2, lbOriginCenter.y);
            tfOriginpassword = tf;
            [tf becomeFirstResponder];
        }
        else if (i == 1) {
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + UIWIDTH(39) + CGRectGetWidth(tf.frame) / 2, lbNewCenter.y);
            tfNewPassword = tf;
        }
        else{
            tf.center = CGPointMake((CGRectGetMaxX(lbTemp.frame)) + UIWIDTH(39) + CGRectGetWidth(tf.frame) / 2, lbConfirmCenter.y);
            tfConfirmPassword = tf;
        }
        tf.delegate = self;
        tf.keyboardType = UIKeyboardTypeASCIICapable;
        tf.secureTextEntry = YES;
        tf.placeholder = placeholders[i];
        [self.view addSubview:tf];
    }
    
    // 创建添加按钮
    btnModify = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnModify];
    btnModify.frame = CGRectMake((KSCREEN_WIDTH - UIWIDTH(1077)) / 2, CGRectGetMaxY(tfConfirmPassword.frame) + POINT_Y(114), UIWIDTH(1077), UIHEIGHT(165));
    [btnModify setTitle:CURRENT_LANGUAGE(@"修改") forState:UIControlStateNormal];
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
