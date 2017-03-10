//
//  AboutUsViewController.m
//  warmwind
//
//  Created by guiping on 17/3/10.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [ChangeLanguage getContentWithKey:@"about0"];
    //[GPUtil addBgImageViewWithImageName:@"bimar背景" SuperView:self.view];
    
    UIImageView *Imv = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWIDTH - GPWidth(400)) / 2, GPPointY(30) + 64, GPWidth(400), GPWidth(400))];
    Imv.image = [UIImage imageNamed:@"1024"];
    [self.view addSubview:Imv];
    
    UILabel *lbAppName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(Imv.frame) + GPPointY(10), kScreenWIDTH, 50)];
    lbAppName.text = [ChangeLanguage getContentWithKey:@"title"];
    lbAppName.textColor = GPColor(250, 126, 20, 1.0);
    lbAppName.font = [UIFont systemFontOfSize:30];
    lbAppName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbAppName];

    UILabel *lbInfo = [[UILabel alloc] init];
    lbInfo.textColor = GPColor(250, 126, 20, 1.0);
    lbInfo.numberOfLines = 0;
    lbInfo.font = [UIFont systemFontOfSize:18];
    NSString *textStr = [ChangeLanguage getContentWithKey:@"about1"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
    lbInfo.attributedText = attributedString;
    CGRect lbInfoR = HSGetLabelRect(lbInfo.text, kScreenWIDTH - GPPointX(200), 0, 1, 18);
    lbInfo.frame = CGRectMake(GPPointX(100), CGRectGetMaxY(lbAppName.frame) + GPPointY(60), lbInfoR.size.width, lbInfoR.size.height);
    [self.view addSubview:lbInfo];
    [lbInfo sizeToFit];
    
    UILabel *lbTelePhone = [[UILabel alloc] init];
    lbTelePhone.text = @"Tel: 400-000-9879   QQ: 4000009879";
    lbTelePhone.textColor = GPColor(250, 126, 20, 1.0);
    lbTelePhone.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbTelePhone];
    
    UILabel *lbVersion = [[UILabel alloc] init];
    lbVersion.text = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    lbVersion.textColor = [UIColor grayColor];
    lbVersion.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbVersion];
    
    UILabel *lbRight = [[UILabel alloc] init];
    lbRight.text = @"Copyright©2017 GALAXYWIND Network Systems Co.,Ltd.\nAll rights reserved";
    lbRight.textAlignment = NSTextAlignmentCenter;
    lbRight.numberOfLines = 0;
    lbRight.font = [UIFont systemFontOfSize:14];
    lbRight.textColor = [UIColor grayColor];
    CGRect lbRightR = HSGetLabelRect(lbRight.text, kScreenWIDTH - GPPointX(200), 0, 1, 14);
    lbRight.frame = CGRectMake(GPPointX(100), kScreenHEIGHT - lbRightR.size.height - 10, lbRightR.size.width, lbRightR.size.height);
    [self.view addSubview:lbRight];
    
    lbVersion.frame = CGRectMake(0, CGRectGetMinY(lbRight.frame) - GPPointY(100), kScreenWIDTH, GPPointY(60));
    lbTelePhone.frame = CGRectMake(0, CGRectGetMinY(lbVersion.frame) - GPPointY(100), kScreenWIDTH, GPPointY(60));
    
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
