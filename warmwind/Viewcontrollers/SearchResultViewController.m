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
    
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChanged:) name:UITextFieldTextDidChangeNotification object:nil];
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
    if (_isAddDevice) {
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - GPWIDTH(1077)) / 2, CGRectGetMaxY(tfPassword.frame) + POINT_Y(114), GPWIDTH(1077), GPHEIGHT(165));
    }
    else {
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - GPWIDTH(1077)) / 2, CGRectGetMaxY(tfName.frame) + POINT_Y(114), GPWIDTH(1077), GPHEIGHT(165));
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    btnAdd.frame = CGRectMake(0, KSCREEN_HEIGHT - GPHEIGHT(165), KSCREEN_WIDTH, GPHEIGHT(165));
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
    btnAdd.frame = CGRectMake(0, KSCREEN_HEIGHT - GPHEIGHT(165), KSCREEN_WIDTH, GPHEIGHT(165));
}

#pragma mark --------------- UIButton点击事件 ----------------
- (void) btnAddClicked:(UIButton *) sender{
    NSString *name = tfName.text;
    NSString *password = tfPassword.text;
    if (_isModifyName) {
        [tfName resignFirstResponder];
//        if (name.length == 0) {
//            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search7"]];
//            return;
//        }
//        if ([name isEqualToString:_model.deviceName]) {
//            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search10"]];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popToRootViewControllerAnimated:NO];
//            });
//            return;
//        }
//        BOOL updateState = [[DataBaseManager sharedManager] updateDeviceNameWithDeviceId:_model.deviceId deviceName:name];
        BOOL updateState = [_model renameWithDeviceName:name];
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
        NSInteger deviceId = arc4random() % 10000 + 999000999099;
        BOOL insertState = [[DataBaseManager sharedManager] addDeviceWithDeviceId:deviceId deviceName:name password:password];
        if (insertState) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else{
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search9"]];
        }
    }
}

- (void) textFieldContentChanged:(NSNotification *) sender{
    if (_isAddDevice) {
        if (tfName.text.length > 0 &&
            tfPassword.text.length > 0) {
            btnAdd.enabled = YES;
            btnAdd.backgroundColor = THEME_COLOR;
        }
        else{
            btnAdd.enabled = NO;
            btnAdd.backgroundColor = BTN_ENABLED_BGCOLOR;
        }
    }
    else if (_isModifyName){
        if (tfName.text.length > 0 && ![tfName.text isEqualToString:_model.deviceName]) {
            btnAdd.enabled = YES;
            btnAdd.backgroundColor = THEME_COLOR;
        }
        else{
            btnAdd.enabled = NO;
            btnAdd.backgroundColor = BTN_ENABLED_BGCOLOR;
        }
    }
}

- (void) createViews{
    // 用户名图片
    UIImageView *ImvName = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(81), POINT_Y(129) + 64, GPWIDTH(100), GPWIDTH(100))];
    ImvName.image = [UIImage imageNamed:@"用户名"];
    CGPoint nameImgCenter = ImvName.center;
    [self.view addSubview:ImvName];
    // 密码图片
    UIImageView *ImvPassword = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(81), POINT_Y(315) + 64, GPWIDTH(100), GPWIDTH(100))];
    ImvPassword.image = [UIImage imageNamed:@"密码"];
    CGPoint passwordImgCenter = ImvPassword.center;
    [self.view addSubview:ImvPassword];
    
    
    // 用户名文本框
    tfName = [GPUtil createTextField];
    tfName.frame = CGRectMake(0, 0, KSCREEN_WIDTH - GPWIDTH(331), GPHEIGHT(150));
    tfName.center = CGPointMake((CGRectGetMaxX(ImvName.frame) + GPWIDTH(39)) + (CGRectGetWidth(tfName.frame)) / 2, nameImgCenter.y);
    if (_isModifyName){
        tfName.text = _model.deviceName;
        tfName.placeholder = [ChangeLanguage getContentWithKey:@"search18"];
        [tfName becomeFirstResponder];
    }
    if (_isAddDevice) {
        tfName.placeholder = [ChangeLanguage getContentWithKey:@"search17"];
        tfName.text = @"HC暖风机2000";
    }
    tfName.delegate = self;
    [self.view addSubview:tfName];
    
       
    // 密码文本框
    tfPassword = [GPUtil createTextField];
    tfPassword.frame = CGRectMake(0, 0, KSCREEN_WIDTH - GPWIDTH(331), GPHEIGHT(150));
    tfPassword.center = CGPointMake((CGRectGetMaxX(ImvPassword.frame) + GPWIDTH(39)) + (CGRectGetWidth(tfPassword.frame)) / 2, passwordImgCenter.y);
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    tfPassword.secureTextEntry = YES;
    if (_isAddDevice) {
        tfPassword.placeholder = [ChangeLanguage getContentWithKey:@"search8"];
        [tfPassword becomeFirstResponder];
    }
    if (_isModifyName) {
        tfPassword.hidden = YES;
        ImvPassword.hidden = YES;
    }
    tfPassword.delegate = self;
    [self.view addSubview:tfPassword];
    
    // 确认按钮
    btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnAdd];
    //btnAdd.frame = CGRectMake(0, kScreenHEIGHT - 64 - GPPointY(165), kScreenWIDTH, GPPointY(165));
    if (_isAddDevice) {
        [btnAdd setTitle:[ChangeLanguage getContentWithKey:@"search4"] forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - GPWIDTH(1077)) / 2, CGRectGetMaxY(tfPassword.frame) + POINT_Y(114), GPWIDTH(1077), GPHEIGHT(165));
    }
    else {
        [btnAdd setTitle:[ChangeLanguage getContentWithKey:@"search16"] forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - GPWIDTH(1077)) / 2, CGRectGetMaxY(tfName.frame) + POINT_Y(114), GPWIDTH(1077), GPHEIGHT(165));
    }
    btnAdd.backgroundColor = BTN_ENABLED_BGCOLOR;
    btnAdd.enabled = NO;
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnAdd addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
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
