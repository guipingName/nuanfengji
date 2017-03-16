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
        self.title = CURRENT_LANGUAGE(@"添加设备");
    }
    if (_isModifyName) {
        self.title = CURRENT_LANGUAGE(@"修改昵称 ");
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
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - UIWIDTH(1077)) / 2, CGRectGetMaxY(tfPassword.frame) + POINT_Y(114), UIWIDTH(1077), UIHEIGHT(165));
    }
    else {
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - UIWIDTH(1077)) / 2, CGRectGetMaxY(tfName.frame) + POINT_Y(114), UIWIDTH(1077), UIHEIGHT(165));
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    btnAdd.frame = CGRectMake(0, KSCREEN_HEIGHT - UIHEIGHT(165), KSCREEN_WIDTH, UIHEIGHT(165));
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
    btnAdd.frame = CGRectMake(0, KSCREEN_HEIGHT - UIHEIGHT(165), KSCREEN_WIDTH, UIHEIGHT(165));
}

#pragma mark --------------- UIButton点击事件 ----------------
- (void) btnAddClicked:(UIButton *) sender{
    NSString *name = tfName.text;
    NSString *password = tfPassword.text;
    if (_isModifyName) {
        [tfName resignFirstResponder];
        BOOL updateState = [_model renameWithDeviceName:name];
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
    else if (_isAddDevice){
        NSInteger deviceId = arc4random() % 10000 + 999000999099;
        BOOL insertState = [[DataBaseManager sharedManager] addDeviceWithDeviceId:deviceId deviceName:name password:password];
        if (insertState) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else{
            [GPUtil hintView:self.view message:CURRENT_LANGUAGE(@"设备添加失败")];
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
    UIImageView *ImvName = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(81), POINT_Y(129) + 64, UIWIDTH(100), UIWIDTH(100))];
    ImvName.image = [UIImage imageNamed:@"用户名"];
    CGPoint nameImgCenter = ImvName.center;
    [self.view addSubview:ImvName];
    // 密码图片
    UIImageView *ImvPassword = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(81), POINT_Y(315) + 64, UIWIDTH(100), UIWIDTH(100))];
    ImvPassword.image = [UIImage imageNamed:@"密码"];
    CGPoint passwordImgCenter = ImvPassword.center;
    [self.view addSubview:ImvPassword];
    
    
    // 用户名文本框
    tfName = [GPUtil createTextField];
    tfName.frame = CGRectMake(0, 0, KSCREEN_WIDTH - UIWIDTH(331), UIHEIGHT(150));
    tfName.center = CGPointMake((CGRectGetMaxX(ImvName.frame) + UIWIDTH(39)) + (CGRectGetWidth(tfName.frame)) / 2, nameImgCenter.y);
    if (_isModifyName){
        tfName.text = _model.deviceName;
        tfName.placeholder = CURRENT_LANGUAGE(@"请设置新的昵称");
        [tfName becomeFirstResponder];
    }
    if (_isAddDevice) {
        tfName.placeholder = CURRENT_LANGUAGE(@"请设置设备名称");
        tfName.text = @"HC暖风机2000";
    }
    tfName.delegate = self;
    [self.view addSubview:tfName];
    
       
    // 密码文本框
    tfPassword = [GPUtil createTextField];
    tfPassword.frame = CGRectMake(0, 0, KSCREEN_WIDTH - UIWIDTH(331), UIHEIGHT(150));
    tfPassword.center = CGPointMake((CGRectGetMaxX(ImvPassword.frame) + UIWIDTH(39)) + (CGRectGetWidth(tfPassword.frame)) / 2, passwordImgCenter.y);
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    tfPassword.secureTextEntry = YES;
    if (_isAddDevice) {
        tfPassword.placeholder = CURRENT_LANGUAGE(@"请设置密码");
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
        [btnAdd setTitle:CURRENT_LANGUAGE(@"确定 ") forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - UIWIDTH(1077)) / 2, CGRectGetMaxY(tfPassword.frame) + POINT_Y(114), UIWIDTH(1077), UIHEIGHT(165));
    }
    else {
        [btnAdd setTitle:CURRENT_LANGUAGE(@"修改") forState:UIControlStateNormal];
        btnAdd.frame = CGRectMake((KSCREEN_WIDTH - UIWIDTH(1077)) / 2, CGRectGetMaxY(tfName.frame) + POINT_Y(114), UIWIDTH(1077), UIHEIGHT(165));
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
