//
//  SearchDeviceViewController.m
//  warmwind
//
//  Created by guiping on 17/2/21.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "SearchResultViewController.h"

@interface SearchDeviceViewController ()<UITextFieldDelegate>

@end

@implementation SearchDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索设备";
    
    UILabel *temp = nil;
    NSArray *names = @[@"SSID", @"密码"];
    CGPoint SSIDLabelCenter = CGPointZero;
    CGPoint passwordLabelCenter = CGPointZero;
    for (int i=0; i<2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(myX(81), myY(129) + myY(186) * i, 40, 40)];
        if (i == 0) {
            SSIDLabelCenter = label.center;
        }
        else{
            passwordLabelCenter = label.center;
        }
        label.text = names[i];
        temp = label;
        label.font = [UIFont systemFontOfSize:15];
        //[label setAlignmentLeftAndRight];
        [self.view addSubview:label];
    }

    NSArray *placeholders = @[@"TPLink_8888", @"路由器WIFI密码"];
    for (int i=0; i<2; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH - myX(81) - CGRectGetMaxX(temp.frame) - 10, myY(150))];
        textField.placeholder = placeholders[i];
        if (i == 0) {
            textField.center = CGPointMake((myX(81) + 50) + (kScreenWIDTH - (myX(81) + 50) - myX(81)) / 2, SSIDLabelCenter.y);
            textField.enabled = NO;
        }
        else{
            textField.center = CGPointMake((myX(81) + 50) + (kScreenWIDTH - (myX(81) + 50) - myX(81)) / 2, passwordLabelCenter.y);
            textField.secureTextEntry = YES;
        }
        textField.tag = 360 + i;
        textField.layer.borderColor = GPColor(204, 204, 204, 1.0).CGColor;
        textField.layer.borderWidth= 1.0f;
        textField.layer.cornerRadius = 5.0f;
        [self.view addSubview:textField];
        textField.delegate = self;
    }
    
    // 添加按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:searchBtn];
    searchBtn.frame = CGRectMake(kScreenWIDTH /2 - myY(432) / 2, myY(1030), myY(432), myY(432));
    searchBtn.layer.cornerRadius = myY(432) / 2;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn setTitle:@"开始搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    searchBtn.backgroundColor = [UIColor orangeColor];
    [searchBtn addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) searchButtonClicked:(UIButton *) sender{
    //UITextField *textField = (UITextField *)[self.view viewWithTag:361];
    //if (textField.text.length > 7) {
        SearchResultViewController *serVC = [[SearchResultViewController alloc] init];
        serVC.isAddDevice = YES;
        [self.navigationController pushViewController:serVC animated:YES];
    //}
//    else{
//        [GPUtil hintView:self.view message:@"wifi密码错误"];
//    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField *textField = (id) [self.view viewWithTag:361];
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
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
