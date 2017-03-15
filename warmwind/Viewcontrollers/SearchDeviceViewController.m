//
//  SearchDeviceViewController.m
//  warmwind
//
//  Created by guiping on 17/2/21.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "SearchResultViewController.h"

typedef NS_ENUM(NSInteger, btnHintView) {
    btnHintViewWait,      // 等待
    btnHintViewCancel     // 好的
};

@interface SearchDeviceViewController ()<UITextFieldDelegate>
{
    UIButton *btnSearch;
    NSTimer *timer;
    NSInteger totalTime;
    UITextField *tfPassword;
    BOOL btnSearchClicked;      // 是否点击搜索按钮
    BOOL backClicked;           // 是否点击返回按钮
    UIView *hintView;
}

@end


@implementation SearchDeviceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [ChangeLanguage getContentWithKey:@"search0"];
    
    [self creatViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    btnSearch.enabled = YES;
    btnSearchClicked = NO;
    tfPassword.enabled = YES;
    backClicked = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [hintView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    //NSLog(@"%s", object_getClassName(self));
}

#pragma mark --------------- UITextFieldDelegate ----------------
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect r = btnSearch.frame;
        r.origin.y = CGRectGetMaxY(tfPassword.frame) + POINT_Y(114);
        btnSearch.frame = r;
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect r = btnSearch.frame;
        r.origin.y = POINT_Y(1030) + 64;
        btnSearch.frame = r;
    }];
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tfPassword resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect r = btnSearch.frame;
        r.origin.y = POINT_Y(1030) + 64;
        btnSearch.frame = r;
    }];
}

#pragma mark --------------- UIButton点击事件 ----------------
- (void) btnClicked:(UIButton *) sender{
    [hintView removeFromSuperview];
    switch (sender.tag - BTN_WAIT_TAG) {
        case btnHintViewWait:
        {
            //timer.fireDate = [NSDate distantPast];
            backClicked = NO;
            if (totalTime == 0){
                SearchResultViewController *serVC = [[SearchResultViewController alloc] init];
                serVC.isAddDevice = YES;
                [self.navigationController pushViewController:serVC animated:YES];
            }
            break;
        }
        case btnHintViewCancel:
        {
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (void) btnSearchClicked:(UIButton *) sender{
    __weak typeof(self) weakSelf = self;
    btnSearchClicked = YES;
    totalTime = 5;
    [tfPassword resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect r = btnSearch.frame;
        r.origin.y = POINT_Y(1030) + 64;
        btnSearch.frame = r;
    } completion:^(BOOL finished) {
        sender.enabled = NO;
        [sender setTitle:[NSString stringWithFormat:@"%ld",(long)totalTime] forState:UIControlStateDisabled];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonTitle:) userInfo:nil repeats:YES];
        tfPassword.enabled = NO;
        [weakSelf createAnimation:sender];
    }];
}

#pragma mark --------------- NSTimer事件 ----------------
- (void) changeButtonTitle:(NSTimer *) sender{
    totalTime--;
    [btnSearch setTitle:[NSString stringWithFormat:@"%ld",(long)totalTime] forState:UIControlStateDisabled];
    if (totalTime == 0) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        if (!backClicked) {
            SearchResultViewController *serVC = [[SearchResultViewController alloc] init];
            serVC.isAddDevice = YES;
            [self.navigationController pushViewController:serVC animated:YES];
        }
    }
}

-(void)back:(UIButton *)sender{
    if (btnSearchClicked) {
        backClicked = YES;
        [self addhintView];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) creatViews{
    UILabel *lbTemp = nil;
    CGRect maxRect = CGRectZero;
    // 创建SSID标签
    UILabel *lbSSID = [[UILabel alloc] init];
    lbSSID.text = @"SSID";
    lbSSID.font = [UIFont systemFontOfSize:15];
    CGRect lbSSIDR = LABEL_RECT(lbSSID.text, 0, 0, 1, 15);
    maxRect = lbSSIDR;
    lbTemp = lbSSID;
    [self.view addSubview:lbSSID];
    
    // 创建SSID密码标签
    UILabel *lbPassword = [[UILabel alloc] init];
    lbPassword.text = [ChangeLanguage getContentWithKey:@"search2"];
    lbPassword.font = [UIFont systemFontOfSize:15];
    CGRect lbPasswordR = LABEL_RECT(lbPassword.text, 0, 0, 1, 15);
    if (lbPasswordR.size.width > maxRect.size.width) {
        maxRect = lbPasswordR;
        lbTemp = lbPassword;
    }
    [self.view addSubview:lbPassword];
    
    lbSSID.textAlignment = NSTextAlignmentRight;
    lbPassword.textAlignment = NSTextAlignmentRight;
    lbSSID.frame = CGRectMake(POINT_X(81), POINT_Y(129) + 64, maxRect.size.width, maxRect.size.height);
    lbPassword.frame = CGRectMake(POINT_X(81), POINT_Y(315) + 64, maxRect.size.width, maxRect.size.height);
    CGPoint lbSSIDCenter = lbSSID.center;
    CGPoint lbPasswordCenter = lbPassword.center;
    
    // 创建SSID输入框
    UITextField *tfSSID = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH - GPWIDTH(120) - CGRectGetMaxX(lbTemp.frame), GPHEIGHT(150))];// 120 = 81 + 39
    tfSSID.center = CGPointMake((CGRectGetMaxX(lbSSID.frame) + GPWIDTH(39)) + (CGRectGetWidth(tfSSID.frame)) / 2, lbSSIDCenter.y);
    tfSSID.enabled = NO;
    tfSSID.text = [GPUtil SSID];
    tfSSID.layer.borderColor = UICOLOR_RGBA(204, 204, 204, 1.0).CGColor;
    tfSSID.layer.borderWidth= 1.0f;
    tfSSID.layer.cornerRadius = 5.0f;
    [self.view addSubview:tfSSID];
    tfSSID.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GPWIDTH(39), 0)];
    tfSSID.leftViewMode = UITextFieldViewModeAlways;
    [tfSSID setValue:UICOLOR_RGBA(128, 128, 128, 1.0) forKeyPath:@"_placeholderLabel.textColor"];

    // SSID密码输入框
    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH - GPWIDTH(120) - CGRectGetMaxX(lbTemp.frame), GPHEIGHT(150))];
    tfPassword.center = CGPointMake((CGRectGetMaxX(lbPassword.frame) + GPWIDTH(39)) + (CGRectGetWidth(tfPassword.frame)) / 2, lbPasswordCenter.y);
    tfPassword.placeholder = [ChangeLanguage getContentWithKey:@"search1"];
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    tfPassword.secureTextEntry = YES;
    tfPassword.layer.borderColor = UICOLOR_RGBA(204, 204, 204, 1.0).CGColor;
    tfPassword.layer.borderWidth= 1.0f;
    tfPassword.layer.cornerRadius = 5.0f;
    tfPassword.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:tfPassword];
    tfPassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPWIDTH(39), 0)];
    tfPassword.leftViewMode = UITextFieldViewModeAlways;
    tfPassword.delegate = self;
    [tfPassword setValue:UICOLOR_RGBA(128, 128, 128, 1.0) forKeyPath:@"_placeholderLabel.textColor"];    
    
    // 添加按钮
    btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnSearch];
    btnSearch.frame = CGRectMake((KSCREEN_WIDTH - GPHEIGHT(432)) / 2, POINT_Y(1030) + 64, GPHEIGHT(432), GPHEIGHT(432));
    btnSearch.layer.cornerRadius = GPHEIGHT(216);
    btnSearch.layer.masksToBounds = YES;
    [btnSearch setTitle:[ChangeLanguage getContentWithKey:@"search3"] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:20];
    btnSearch.backgroundColor = THEME_COLOR;
    [btnSearch addTarget:self action:@selector(btnSearchClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) addhintView{
    hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    hintView.backgroundColor = UICOLOR_RGBA(0, 0, 0, 0.5);
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview:hintView];
    UIView *opView = [[UIView alloc] init];
    opView.backgroundColor = [UIColor whiteColor];
    opView.layer.cornerRadius = 10;
    opView.layer.masksToBounds = YES;
    [hintView addSubview:opView];
    
    UILabel *lbTitle = [[UILabel alloc] init];
    [opView addSubview:lbTitle];
    lbTitle.text = [ChangeLanguage getContentWithKey:@"search11"];
    lbTitle.numberOfLines = 0;
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.textColor = [UIColor blackColor];
    lbTitle.font = [UIFont boldSystemFontOfSize:17];
    CGRect lbTitleR = [lbTitle.text boundingRectWithSize:CGSizeMake(KSCREEN_WIDTH - 110, 0) options:1 attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil];// 110 = 80 + 30
    lbTitle.frame = CGRectMake(15, 20, lbTitleR.size.width, lbTitleR.size.height);
    
    opView.frame = CGRectMake(40, -CGRectGetHeight(lbTitleR) - 80, KSCREEN_WIDTH - 80, CGRectGetHeight(lbTitleR) + 80);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbTitle.frame) + 20, opView.frame.size.width, 1)];
    line.backgroundColor = [UIColor grayColor];
    [opView addSubview:line];
    UIView *rowline = [[UIView alloc] initWithFrame:CGRectMake(opView.frame.size.width / 2, CGRectGetMaxY(lbTitle.frame) + 20, 1, 40)];
    rowline.backgroundColor = [UIColor grayColor];
    [opView addSubview:rowline];
    
    NSArray *names = @[[ChangeLanguage getContentWithKey:@"search12"], [ChangeLanguage getContentWithKey:@"search13"]];
    for (int i=0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [opView addSubview:button];
        button.frame = CGRectMake(opView.bounds.size.width * i / 2 , CGRectGetMaxY(lbTitle.frame) + 20, opView.bounds.size.width  / 2, 40);
        [button setTitle:names[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 20];
        [button setTitleColor:UICOLOR_RGBA(61, 94, 227, 1.0) forState:UIControlStateNormal];
        button.tag = BTN_WAIT_TAG + i;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    opView.transform = CGAffineTransformMakeRotation(- M_PI / 6);
    [UIView animateWithDuration:0.5 animations:^{
        opView.transform = CGAffineTransformMakeRotation(0);
        CGRect rect = opView.frame;
        rect.origin.y = POINT_Y(800);
        opView.frame = rect;
    }];
}

- (void) createAnimation:(UIButton *) sender{
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(sender.bounds), -CGRectGetMidY(sender.bounds), sender.bounds.size.width, sender.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:sender.layer.cornerRadius];
    CGPoint shapePosition = [self.view convertPoint:sender.center fromView:self.view];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = UICOLOR_RGBA(250, 126, 20, 0.8).CGColor;
    circleShape.lineWidth = 4;
    [self.view.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 1)];
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.0f;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
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
