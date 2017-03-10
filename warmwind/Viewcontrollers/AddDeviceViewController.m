//
//  AddDeviceViewController.m
//  warmwind
//
//  Created by guiping on 17/2/21.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()<UITextFieldDelegate>
{
    UITextField *tfDeviceId;
    UITextField *tfPassword;
}

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [ChangeLanguage getContentWithKey:@"add0"];
    
    
    UILabel *lbTemp = nil;
    CGRect maxRect = CGRectZero;
    // 创建序列号标签
    UILabel *lbDeviceId = [[UILabel alloc] init];
    lbDeviceId.text = [ChangeLanguage getContentWithKey:@"add1"];
    lbDeviceId.font = [UIFont systemFontOfSize:15];
    CGRect lbDeviceIdR = HSGetLabelRect(lbDeviceId.text, 0, 0, 1, 15);
    maxRect = lbDeviceIdR;
    lbTemp = lbDeviceId;
    [self.view addSubview:lbDeviceId];
    // 创建密码标签
    UILabel *lbPassword = [[UILabel alloc] init];
    lbPassword.text = [ChangeLanguage getContentWithKey:@"search2"];
    lbPassword.font = [UIFont systemFontOfSize:15];
    CGRect lbPasswordR = HSGetLabelRect(lbPassword.text, 0, 0, 1, 15);
    if (lbPasswordR.size.width > maxRect.size.width) {
        maxRect = lbPasswordR;
        lbTemp = lbPassword;
    }
    [self.view addSubview:lbPassword];
    lbDeviceId.frame = CGRectMake(GPPointX(81), GPPointY(129) + 64, maxRect.size.width + 1, maxRect.size.height);
    lbPassword.frame = CGRectMake(GPPointX(81), GPPointY(315) + 64, maxRect.size.width + 1, maxRect.size.height);
    CGPoint SSIDLabelCenter = lbDeviceId.center;
    CGPoint passwordLabelCenter = lbPassword.center;
    [lbDeviceId setAlignmentLeftAndRight];
    [lbPassword setAlignmentLeftAndRight];
    
    // 创建序列号输入框
    tfDeviceId = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - GPPointX(81) - CGRectGetMaxX(lbTemp.frame) - GPPointX(39), GPPointY(150))];
    tfDeviceId.center = CGPointMake((passwordLabelCenter.x * 2 - GPPointX(81)) + GPPointX(39) +(kScreenWIDTH - (passwordLabelCenter.x * 2 - GPPointX(81) + GPPointX(39)) - GPPointX(81)) / 2, SSIDLabelCenter.y);
    tfDeviceId.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
    tfDeviceId.keyboardType = UIKeyboardTypeNumberPad;
    tfDeviceId.layer.borderWidth= 1.0f;
    tfDeviceId.layer.cornerRadius = 5.0f;
    [self.view addSubview:tfDeviceId];
    tfDeviceId.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GPPointX(39), 0)];
    tfDeviceId.leftViewMode = UITextFieldViewModeAlways;
    tfDeviceId.delegate = self;
    [tfDeviceId setValue:GPColor(128, 128, 128, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    tfDeviceId.returnKeyType = UIReturnKeyDone;
    [tfDeviceId becomeFirstResponder];
    // 密码输入框
    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - GPPointX(81) - CGRectGetMaxX(lbTemp.frame) - GPPointX(39), GPPointY(150))];
    tfPassword.center = CGPointMake((passwordLabelCenter.x * 2 - GPPointX(81)) + GPPointX(39) +(kScreenWIDTH - (passwordLabelCenter.x * 2 - GPPointX(81) + GPPointX(39)) - GPPointX(81)) / 2, passwordLabelCenter.y);
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    tfPassword.secureTextEntry = YES;
    tfPassword.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
    tfPassword.layer.borderWidth= 1.0f;
    tfPassword.layer.cornerRadius = 5.0f;
    [self.view addSubview:tfPassword];
    tfPassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPPointX(39), 0)];
    tfPassword.leftViewMode = UITextFieldViewModeAlways;
    tfPassword.delegate = self;
    [tfPassword setValue:GPColor(128, 128, 128, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    tfPassword.returnKeyType = UIReturnKeyDone;
    
    
    // 创建添加按钮
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnAdd];
    btnAdd.frame = CGRectMake(kScreenWIDTH / 2 - GPPointX(1077) / 2, CGRectGetMaxY(tfPassword.frame) + GPPointY(114), GPPointX(1077), GPPointY(165));
    [btnAdd setTitle:[ChangeLanguage getContentWithKey:@"add3"] forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:20];
    btnAdd.backgroundColor = GPColor(250, 126, 20, 1.0);
    [btnAdd addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) btnAddClicked:(UIButton *) sender{
    if (tfDeviceId.text.length == 14) {
        if (tfPassword.text.length == 0) {
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search8"]];
            return;
        }
        BOOL insertState = [[DataBaseManager sharedManager] addDeviceWithDeviceId:(long long)[[tfDeviceId.text stringByReplacingOccurrencesOfString:@" "withString:@""] integerValue] deviceName:@"HC暖风机200" password:tfPassword.text];
        if (insertState) {
            //NSNotification *note = [[NSNotification alloc] initWithName:@"newDevice" object:nil userInfo:nil];
            //[[NSNotificationCenter defaultCenter] postNotification:note];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else{
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search9"]];
        }
    }
    else{
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"add4"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfDeviceId) {
//        if (range.length == 1 && string.length == 0) {
//            return YES;
//        }
//        else if (tfDeviceId.text.length >= 12) {
//            tfDeviceId.text = [textField.text substringToIndex:12];
//            return NO;
//        }
        NSString *text = textField.text;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" "withString:@""];
        if ([text length] >= 13) {
            return NO;
        }
        NSString *newString =@"";
        while (text.length >0) {
            NSString *subString = [text substringToIndex:MIN(text.length,4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length ==4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length,4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        [textField setText:newString];
        return NO;
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
    if ([tfDeviceId becomeFirstResponder] || [tfPassword becomeFirstResponder]) {
        [tfDeviceId resignFirstResponder];
        [tfPassword resignFirstResponder];
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
