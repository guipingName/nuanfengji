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

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (_isAddDevice) {
        self.title = @"搜索设备";
    }
    if (_isModifyName) {
        self.title = @"修改用户名";
    }
    if (_isModifyPassword) {
        self.title = @"修改密码";
    }
    NSArray *imageNames = @[@"用户名", @"密码"];
    CGPoint nameImgCenter = CGPointZero;
    CGPoint passwordImgCenter = CGPointZero;
    for (int i=0; i<2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(myX(81), myY(129) + myY(186) * i, myX(100), myX(100))];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        if (i == 0) {
            nameImgCenter = imageView.center;
        }
        else{
            passwordImgCenter = imageView.center;
        }
        [self.view addSubview:imageView];
    }
    
    for (int i=0; i<2; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - myX(331), myY(150))];
        textField.tag = 600 + i;
        if (i == 0) {
            textField.center = CGPointMake((nameImgCenter.x + myX(50) + 10) + (kScreenWIDTH - (nameImgCenter.x + myX(50) + 10) - myX(81)) / 2, nameImgCenter.y);
            if (_isModifyPassword) {
                textField.placeholder = self.model.deviceName;
                textField.enabled = NO;
            }
        }
        if (i == 1) {
            textField.center = CGPointMake((passwordImgCenter.x + myX(50) + 10) + (kScreenWIDTH - (passwordImgCenter.x + myX(50) + 10) - myX(81)) / 2, passwordImgCenter.y);
            textField.secureTextEntry = YES;
            if (_isModifyName) {
                textField.enabled = NO;
                textField.text = @"888888888";
                textField.textColor = [UIColor grayColor];
            }
        }
        textField.delegate = self;
        textField.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
        textField.layer.borderWidth= 1.0f;
        textField.layer.cornerRadius = 5.0f;
        [self.view addSubview:textField];
    }
    
    // 确认按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addBtn];
    addBtn.frame = CGRectMake(0, kScreenHEIGHT - 64 - myY(165), kScreenWIDTH, myY(165));
    [addBtn setTitle:@"确认" forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor orangeColor];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [addBtn addTarget:self action:@selector(addDeviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) addDeviceButtonClicked:(UIButton *) sender{
    UITextField *nameTextField = (UITextField *)[self.view viewWithTag:600];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:601];
    NSString *name = nameTextField.text;
    NSString *password = passwordTextField.text;
    if (_isModifyName) {
        // 修改用户名
        if (name.length > 0) {
            BOOL updateState = [[DataBaseManager sharedManager] updateDeviceNameWithDeviceId:_model.deviceId deviceName:name];
            if (updateState) {
                NSLog(@"修改用幕后");
                NSNotification *note = [[NSNotification alloc] initWithName:@"newDevice" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:note];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            else{
                [GPUtil hintView:self.view message:@"修改失败"];
            }
        }
        else{
            [GPUtil hintView:self.view message:@"请输入用户名"];
        }
    }
    else if (_isModifyPassword){
        BOOL updateState = [[DataBaseManager sharedManager] updateDevicePasswordWithDeviceId:_model.deviceId password:password];
        if (updateState) {
            NSLog(@"密码修改 成功");
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else{
            NSLog(@"密码修改 失败");
        }
    }
    else if (_isAddDevice){
        // 添加设备
        if (name.length > 0) {
            if (password.length > 0) {
                NSInteger deviceId = arc4random() % 7 + 1111111100;//max 2147483647
                BOOL insertState = [[DataBaseManager sharedManager] insertDeviceWithDeviceId:deviceId deviceName:name password:password];
                if (insertState) {
                    NSNotification *note = [[NSNotification alloc] initWithName:@"newDevice" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:note];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }
                else{
                    [GPUtil hintView:self.view message:@"设备添加失败"];
                }
            }
            else{
                [GPUtil hintView:self.view message:@"密码不能为空"];
            }
        }
        else{
            [GPUtil hintView:self.view message:@"请设置昵称"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (int i=600; i<602; i++) {
        UITextField *textField = (id) [self.view viewWithTag:i];
        if ([textField becomeFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
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
