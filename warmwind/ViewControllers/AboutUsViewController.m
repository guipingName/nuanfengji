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
    self.title = CURRENT_LANGUAGE(@"关于");
    //[GPUtil addBgImageViewWithImageName:@"bimar背景" SuperView:self.view];
    
    UIImageView *Imv = [[UIImageView alloc] initWithFrame:CGRectMake((KSCREEN_WIDTH - UIWIDTH(345)) / 2, POINT_Y(81) + 64, UIWIDTH(345), UIWIDTH(345))];
    Imv.backgroundColor = THEME_COLOR;
    Imv.layer.cornerRadius = 10;
    Imv.layer.masksToBounds = YES;
    Imv.image = [UIImage imageNamed:@"左侧边栏logo"];
    [self.view addSubview:Imv];
    
    UILabel *lbAppName = [[UILabel alloc] init];
    lbAppName.text = CURRENT_LANGUAGE(@"暖风机");
    lbAppName.textColor = THEME_COLOR;
    lbAppName.font = [UIFont systemFontOfSize:20];
    CGRect lbAppNameR = LABEL_RECT(lbAppName.text, 0, 0, 1, 20);
    lbAppName.frame = CGRectMake(0, CGRectGetMaxY(Imv.frame) + POINT_Y(39), KSCREEN_WIDTH, lbAppNameR.size.height);
    lbAppName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbAppName];

    
    UILabel *lbInfo = [[UILabel alloc] init];
    lbInfo.textColor = THEME_COLOR;
    lbInfo.numberOfLines = 0;
    lbInfo.font = [UIFont systemFontOfSize:16];
    NSString *textStr = CURRENT_LANGUAGE(@"bimar暖风机系列秉承科技改变生活的理念，把小产品落地和大数据挖掘完美相结合，为千家万户提供一系列智能舒适、节能环保、价廉物美的智能硬件。");
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:POINT_Y(63)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
    lbInfo.attributedText = attributedString;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
    CGRect lbInfoR = [lbInfo.text boundingRectWithSize:CGSizeMake(KSCREEN_WIDTH - POINT_Y(198), 0) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attr context:nil];
    lbInfo.frame = CGRectMake(0, 0, lbInfoR.size.width, lbInfoR.size.height);
    [self.view addSubview:lbInfo];
    [lbInfo sizeToFit];
    lbInfo.userInteractionEnabled = YES;
    
    UIScrollView *scroView = [[UIScrollView alloc] init];
    [scroView addSubview:lbInfo];
    scroView.showsVerticalScrollIndicator = NO;
    scroView.contentSize = CGSizeMake(KSCREEN_WIDTH - UIWIDTH(198), lbInfoR.size.height);
    [self.view addSubview:scroView];
    
    UIView *telQQbackView = [[UIView alloc] init];
    [self.view addSubview:telQQbackView];
    
    UILabel *lbTelePhone = [[UILabel alloc] init];
    lbTelePhone.text = @"Tel: 400-000-9879";
    lbTelePhone.textColor = THEME_COLOR;
    lbTelePhone.textAlignment = NSTextAlignmentRight;
    lbTelePhone.font = [UIFont systemFontOfSize:16];
    CGRect lbTelePhoneR = LABEL_RECT(lbTelePhone.text, 0, 0, 1, 16);
    [telQQbackView addSubview:lbTelePhone];
    UILabel *lbQQ = [[UILabel alloc] init];
    lbQQ.text = @"QQ: 4000009879";
    lbQQ.textColor = THEME_COLOR;
    lbQQ.textAlignment = NSTextAlignmentLeft;
    lbQQ.font = [UIFont systemFontOfSize:16];
    CGRect lbQQR = LABEL_RECT(lbQQ.text, 0, 0, 1, 16);
    [telQQbackView addSubview:lbQQ];
    
    UILabel *lbVersion = [[UILabel alloc] init];
    lbVersion.text = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    lbVersion.textColor = UICOLOR_RGBA(153, 153, 153, 1.0);
    lbVersion.font = [UIFont systemFontOfSize:15];
    lbVersion.textAlignment = NSTextAlignmentCenter;
    CGRect lbVersionR = LABEL_RECT(lbVersion.text, 0, 0, 1, 15);
    [self.view addSubview:lbVersion];
    
    // 获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy"];
    NSString *year = [formater stringFromDate:date];

    UILabel *lbRight = [[UILabel alloc] init];
    lbRight.text = [NSString stringWithFormat:@"Copyright©%@ GALAXYWIND Network Systems Co.,Ltd.\nAll rights reserved", year];
    lbRight.textAlignment = NSTextAlignmentCenter;
    lbRight.numberOfLines = 0;
    lbRight.font = [UIFont systemFontOfSize:15];
    lbRight.textColor = UICOLOR_RGBA(153, 153, 153, 1.0);
    CGRect lbRightR = LABEL_RECT(lbRight.text, KSCREEN_WIDTH - POINT_X(198), 0, 1, 15);
    lbRight.frame = CGRectMake(POINT_X(99), KSCREEN_HEIGHT - lbRightR.size.height - POINT_Y(200), lbRightR.size.width, lbRightR.size.height);
    [self.view addSubview:lbRight];
    
    lbVersion.frame = CGRectMake(0, CGRectGetMinY(lbRight.frame) - POINT_Y(27) - lbVersionR.size.height, KSCREEN_WIDTH, lbVersionR.size.height);
    telQQbackView.frame = CGRectMake(0, CGRectGetMinY(lbVersion.frame) - POINT_Y(69) - lbTelePhoneR.size.height, KSCREEN_WIDTH, lbTelePhoneR.size.height);
    lbTelePhone.frame = CGRectMake((KSCREEN_WIDTH - lbTelePhoneR.size.width - lbQQR.size.width - POINT_X(30)) / 2, 0, lbTelePhoneR.size.width, lbTelePhoneR.size.height);
    lbQQ.frame = CGRectMake(CGRectGetMaxX(lbTelePhone.frame) + POINT_X(30), 0, lbQQR.size.width, lbQQR.size.height);
    
    scroView.frame = CGRectMake(POINT_X(99), CGRectGetMaxY(lbAppName.frame) + POINT_Y(90), KSCREEN_WIDTH - UIWIDTH(198), CGRectGetMinY(telQQbackView.frame) - POINT_Y(150) - CGRectGetMaxY(lbAppName.frame));
    
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
