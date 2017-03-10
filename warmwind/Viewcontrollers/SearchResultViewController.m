//
//  SearchResultViewController.m
//  warmwind
//
//  Created by guiping on 17/2/22.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "SearchResultViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface SearchResultViewController ()<UITextFieldDelegate>
{
    UITextField *tfName;
    UITextField *tfPassword;
    UIButton *btnAdd;
}

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_isAddDevice) {
        self.title = [ChangeLanguage getContentWithKey:@"search0"];
    }
    if (_isModifyName) {
        self.title = [ChangeLanguage getContentWithKey:@"search5"];
    }
    // 用户名图片
    UIImageView *ImvName = [[UIImageView alloc] initWithFrame:CGRectMake(GPPointX(81), GPPointY(129) + 64, GPPointX(100), GPPointX(100))];
    ImvName.image = [UIImage imageNamed:@"用户名"];
    CGPoint nameImgCenter = ImvName.center;
    [self.view addSubview:ImvName];
    // 密码图片
    UIImageView *ImvPassword = [[UIImageView alloc] initWithFrame:CGRectMake(GPPointX(81), GPPointY(315) + 64, GPPointX(100), GPPointX(100))];
    ImvPassword.image = [UIImage imageNamed:@"密码"];
    CGPoint passwordImgCenter = ImvPassword.center;
    [self.view addSubview:ImvPassword];
    
    // 用户名文本框
    tfName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - GPPointX(331), GPPointY(150))];
    tfName.center = CGPointMake((CGRectGetMaxX(ImvName.frame) + GPPointX(39)) + (CGRectGetWidth(tfName.frame)) / 2, nameImgCenter.y);
    if (_isModifyName){
        tfName.text = _model.deviceName;
        [tfName becomeFirstResponder];
    }
    if (_isAddDevice) {
        tfName.text = @"HC暖风机2000";
    }
    tfName.delegate = self;
    tfName.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
    [tfName setValue:GPColor(128, 128, 128, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    tfName.layer.borderWidth= 1.0f;
    tfName.layer.cornerRadius = 5.0f;
    tfName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPPointX(39), 0)];
    tfName.leftViewMode = UITextFieldViewModeAlways;
    tfName.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:tfName];
    
    // 密码文本框
    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - GPPointX(331), GPPointY(150))];
    tfPassword.center = CGPointMake((CGRectGetMaxX(ImvPassword.frame) + GPPointX(39)) + (CGRectGetWidth(tfPassword.frame)) / 2, passwordImgCenter.y);
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    tfPassword.secureTextEntry = YES;
    if (_isAddDevice) {
        [tfPassword becomeFirstResponder];
    }
    if (_isModifyName) {
        tfPassword.hidden = YES;
        ImvPassword.hidden = YES;
    }
    tfPassword.delegate = self;
    tfPassword.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
    [tfPassword setValue:GPColor(128, 128, 128, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    tfPassword.layer.borderWidth= 1.0f;
    tfPassword.layer.cornerRadius = 5.0f;
    tfPassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPPointX(39), 0)];
    tfPassword.leftViewMode = UITextFieldViewModeAlways;
    tfPassword.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:tfPassword];
    
    // 确认按钮
    btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnAdd];
    //btnAdd.frame = CGRectMake(0, kScreenHEIGHT - 64 - GPPointY(165), kScreenWIDTH, GPPointY(165));
    if (_isAddDevice) {
        [btnAdd setTitle:[ChangeLanguage getContentWithKey:@"search4"] forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((kScreenWIDTH - GPPointX(1077)) / 2, CGRectGetMaxY(tfPassword.frame) + GPPointY(114), GPPointX(1077), GPPointY(165));
    }
    else {
        [btnAdd setTitle:[ChangeLanguage getContentWithKey:@"search16"] forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((kScreenWIDTH - GPPointX(1077)) / 2, CGRectGetMaxY(tfName.frame) + GPPointY(114), GPPointX(1077), GPPointY(165));
    }
    btnAdd.backgroundColor = GPColor(250, 126, 20, 1.0);
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnAdd addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) btnAddClicked:(UIButton *) sender{
    NSString *name = tfName.text;
    NSString *password = tfPassword.text;
    if (_isModifyName) {
        [tfName resignFirstResponder];
        if (name.length == 0) {
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search7"]];
            return;
        }
        if ([name isEqualToString:_model.deviceName]) {
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search10"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
            return;
        }
        BOOL updateState = [[DataBaseManager sharedManager] updateDeviceNameWithDeviceId:_model.deviceId deviceName:name];
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
    else if (_isAddDevice){
        if (name.length == 0) {
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search7"]];
            return;
        }
        if (password.length == 0) {
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search8"]];
            return;
        }
        NSInteger deviceId = arc4random() % 10000 + 999000999099;//max 2147483647
        BOOL insertState = [[DataBaseManager sharedManager] addDeviceWithDeviceId:deviceId deviceName:name password:password];
        if (insertState) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else{
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search9"]];
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_isAddDevice) {
        btnAdd.frame = CGRectMake((kScreenWIDTH - GPPointX(1077)) / 2, CGRectGetMaxY(tfPassword.frame) + GPPointY(114), GPPointX(1077), GPPointY(165));
    }
    else {
        btnAdd.frame = CGRectMake((kScreenWIDTH - GPPointX(1077)) / 2, CGRectGetMaxY(tfName.frame) + GPPointY(114), GPPointX(1077), GPPointY(165));
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    btnAdd.frame = CGRectMake(0, kScreenHEIGHT - GPPointY(165), kScreenWIDTH, GPPointY(165));
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfName) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (tfName.text.length >= 10) {
            tfName.text = [textField.text substringToIndex:10];
            return NO;
        }
    }
    else if (textField == tfPassword) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (tfPassword.text.length >= 32) {
            tfPassword.text = [textField.text substringToIndex:32];
            return NO;
        }
    }
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tfName resignFirstResponder];
    [tfPassword resignFirstResponder];
    btnAdd.frame = CGRectMake(0, kScreenHEIGHT - GPPointY(165), kScreenWIDTH, GPPointY(165));
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
