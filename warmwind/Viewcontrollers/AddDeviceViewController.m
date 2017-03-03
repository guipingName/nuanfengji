//
//  AddDeviceViewController.m
//  warmwind
//
//  Created by guiping on 17/2/21.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()<UITextFieldDelegate>

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加设备";
    UILabel *temp = nil;
    NSArray *names = @[@"序列号", @"昵称", @"密码"];
    CGPoint numberLabelCenter = CGPointZero;
    CGPoint nameLabelCenter = CGPointZero;
    CGPoint passwordLabelCenter = CGPointZero;
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(myX(81), myY(129) + myY(186) * i, 46, 40)];
        if (i == 0) {
            numberLabelCenter = label.center;
        }
        else if (i == 1) {
            nameLabelCenter = label.center;
        }
        else{
            passwordLabelCenter = label.center;
        }
        label.text = names[i];
        temp = label;
        label.font = [UIFont systemFontOfSize:15];
        [label setAlignmentLeftAndRight];
        [self.view addSubview:label];
    }
    
    for (int i=0; i<3; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - myX(81) - CGRectGetMaxX(temp.frame) - 10, myY(150))];
        textField.delegate = self;
        if (i == 0) {
            textField.center = CGPointMake((myX(81) + 56) + (kScreenWIDTH - (myX(81) + 56) - myX(81)) / 2, numberLabelCenter.y);
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if (i == 1) {
            textField.center = CGPointMake((myX(81) + 56) + (kScreenWIDTH - (myX(81) + 56) - myX(81)) / 2, nameLabelCenter.y);
        }
        else{
            textField.center = CGPointMake((myX(81) + 56) + (kScreenWIDTH - (myX(81) + 56) - myX(81)) / 2, passwordLabelCenter.y);
        }
        textField.tag = 370 + i;
        textField.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
        textField.layer.borderWidth= 1.0f;
        textField.layer.cornerRadius = 5.0f;
        [self.view addSubview:textField];
    }
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sureButton];
    sureButton.frame = CGRectMake(kScreenWIDTH / 2 - myX(1077) / 2, CGRectGetMaxY([self.view viewWithTag:372].frame) + myY(114), myX(1077), myY(165));
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:20];
    sureButton.backgroundColor = [UIColor orangeColor];
    [sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) sureButtonClicked:(UIButton *) sender{
    UITextField *deviceIdTextField = (UITextField *)[self.view viewWithTag:370];
    UITextField *nickNameTextField = (UITextField *)[self.view viewWithTag:371];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:372];
    NSInteger aa = [deviceIdTextField.text integerValue];//2147483647
    if (aa > 0 && aa < 21474837) {
        BOOL insertState = [[DataBaseManager sharedManager] insertDeviceWithDeviceId:[deviceIdTextField.text integerValue] deviceName:nickNameTextField.text password:passwordTextField.text];
        if (insertState) {
            NSNotification *note = [[NSNotification alloc] initWithName:@"newDevice" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:note];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else{
            [GPUtil hintView:self.view message:@"序列号输入有误"];
        }
    }
    else{
        [GPUtil hintView:self.view message:@"序列号输入有误"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (int i=370; i<373; i++) {
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
