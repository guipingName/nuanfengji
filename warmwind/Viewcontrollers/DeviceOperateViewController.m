//
//  DeviceOperateViewController.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "DeviceOperateViewController.h"
#import "MoreViewController.h"
#import "CircleView.h"
#import <AudioToolbox/AudioToolbox.h>

static NSUInteger currentWorkMode;

typedef NS_ENUM(NSInteger, BimarOperateButton) {
    BimarOperateButtonTime,                         // 定时设置
    BimarOperateButtonOnOff,                        // 开关
    BimarOperateButtonIncreaseTemperature,          // 增加温度
    BimarOperateButtonWind,                         // 风速控制
    BimarOperateButtonMode,                         // 模式切换
    BimarOperateButtonDecreaseTemperature           // 减小温度
};


@interface DeviceOperateViewController (){
    CircleView *myCircleView;           // 倒计时进度
    NSArray *modeImgNamesArray;         // 模式图片资源
    NSUInteger timetotal;               // 设置总时长
    NSUInteger timelong;                // timer对应的时长 repeat
    NSTimer *timer;                     // 定时器
    UILabel *lbTemperatureType;         // 设备温度单位标签
    UILabel *lbTemperature;             // 温度标签
    UIImageView *modeImageView;         // 模式图片
    UIImageView *innerImageView;
    UILabel *lbIndoorTemperature;
    UILabel *lbIndoorTemperatureType;
}

@end

@implementation DeviceOperateViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _model.deviceName;
    [GPUtil addBgImageViewWithImageName:@"bimar背景" SuperView:self.view];
    currentWorkMode = _model.workMode;
    
    [self addNavigationItemImageName:@"更多" target:self action:@selector(more:) isLeft:NO];
    
    [self creatSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTemperatureType:) name:@"temperatureFlag" object:nil];
    
    // 显示数据
    [self showInfomation];
}

- (void) creatSubviews{
    // 室内温度图标
    innerImageView = [[UIImageView alloc] init];
    UIImage *innerImage = [UIImage imageNamed:@"室温144px"];
    innerImageView.image = innerImage;
    innerImageView.frame = CGRectMake(GPPointX(51), GPPointY(90) + 64, 48, 48);
    //innerImageView.frame = CGRectMake(myX(51), myY(90), innerImage.size.width, innerImage.size.height);
    //NSLog(@"%f %f", innerImage.size.width, innerImage.size.height);
    [self.view addSubview:innerImageView];
    
    // 创建温度及温度单位标签
    lbIndoorTemperature = [[UILabel alloc] init];
    [self.view addSubview:lbIndoorTemperature];
    lbIndoorTemperature.textColor = [UIColor whiteColor];
    
    lbIndoorTemperatureType = [[UILabel alloc] init];
    [self.view addSubview:lbIndoorTemperatureType];
    lbIndoorTemperatureType.textColor = [UIColor whiteColor];
    
    lbTemperature = [[UILabel alloc] init];
    [self.view addSubview:lbTemperature];
    lbTemperature.textColor = [UIColor whiteColor];
    
    lbTemperatureType = [[UILabel alloc] init];
    [self.view addSubview:lbTemperatureType];
    lbTemperatureType.textColor = [UIColor whiteColor];
    
    
    // 添加定时器进度条
    myCircleView = [[CircleView alloc] initWithFrame:CGRectMake(kScreenWIDTH - GPPointX(51) - GPPointY(206), GPPointY(50) + 64, GPPointY(206), GPPointY(206))];
    myCircleView.hidden = YES;
    [self.view addSubview:myCircleView];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decreseTime:) userInfo:nil repeats:YES];
    timer.fireDate = [NSDate distantFuture];
    
    // 模式图片
    modeImgNamesArray = @[@"bimar模式小火", @"bimar模式中火", @"bimar模式大火", @"bimar模式防冻"];
    modeImageView = [[UIImageView alloc] init];
    [self.view addSubview:modeImageView];
    
    // 添加6个按钮
    NSArray *imageNamesN = @[@"bimarBtn定时",@"bimarBtn开关",@"bimarBtn温度加",@"bimarBtn风速",@"bimarBtn模式",@"bimarBtn温度减"];
    NSArray *imageNamesH = @[@"bimarBtn定时_gray",@"bimarBtn开关_gray",@"bimarBtn温度加_gray",@"bimarBtn风速_gray",@"bimarBtn模式_gray",@"bimarBtn温度减_gray"];
    for (int i=0; i<6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.frame = CGRectMake(GPPointX(33) +(i % 3) * GPPointX(399) , GPPointY(1033) + (i / 3) * GPPointY(346) + 64, GPPointX(378), GPPointY(316));
        button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setImage:[UIImage imageNamed:imageNamesN[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageNamesH[i]] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:imageNamesH[i]] forState:UIControlStateHighlighted];
        button.tag = 800 + i;
        [button addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 开机状态下按钮状态
- (void) onlineButtonState{
    UIButton *btnTime = [self.view viewWithTag:800];
    UIButton *btnIsOn = [self.view viewWithTag:801];
    UIButton *btnWind = [self.view viewWithTag:803];
    [btnWind setImage:[UIImage imageNamed:@"bimarBtn风速_gray"] forState:UIControlStateNormal];
    [btnWind setImage:[UIImage imageNamed:@"bimarBtn风速"] forState:UIControlStateSelected];
    [btnTime setImage:[UIImage imageNamed:@"bimarBtn定时_gray"] forState:UIControlStateNormal];
    [btnTime setImage:[UIImage imageNamed:@"bimarBtn定时"] forState:UIControlStateSelected];
    btnIsOn.selected = YES;
    if (_model.autoTime == BimarAutoOffTimeNone) {
        btnTime.selected = NO;
    }
    else{
        if (_model.endtime > [GPUtil nowTimeIntervalSince1970]) {
            btnTime.selected = YES;
            myCircleView.hidden = NO;
//            if (_model.autoTime == BimarAutoOffTimeOne) {
//                timetotal = 1 * 60 * 60;
//            }
//            else if (_model.autoTime == BimarAutoOffTimeFifteen) {
//                timetotal = 15 * 60 * 60;
//            }
            timetotal = 15 * 60 * 60;
            timelong = _model.endtime - [GPUtil nowTimeIntervalSince1970] + 1;
            myCircleView.progress = timelong / (CGFloat)timetotal;
            NSInteger hour = timelong / 60 / 60;
            NSInteger min = timelong / 60 % 60;
            NSString *str = nil;
            if (hour == 0) {
                if (min == 59) {
                    str = @"1H";
                }
                else{
                    str = [NSString stringWithFormat:@"%luM", min+1];
                }
            }
            else if (min == 0){
                str = [NSString stringWithFormat:@"%luH", hour];
            }
            else{
                if (min == 59) {
                    str = [NSString stringWithFormat:@"%luH", hour + 1];
                }
                else{
                    str = [NSString stringWithFormat:@"%luH%luM", hour, min+1];
                }
            }
            myCircleView.newtimeLabel.text = str;
            timer.fireDate = [NSDate distantPast];
        }
        else{
            btnTime.selected = NO;
        }
    }
    if (_model.windState) {
        btnWind.selected = YES;
    }
    else{
        btnWind.selected = NO;
    }
}

- (void) changeTemperatureType:(NSNotification *) sender{
    if ([sender.object boolValue]) {
        _model.temperatureFlag = YES;
    }
    else{
        _model.temperatureFlag = NO;
    }
    [self showInfomation];
}

- (void) showInfomation{
    if (_model.workState == BimarWorkStateOnMode) {
        // 开机状态
        if (_model.temperatureFlag) {
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorCentigrade];
            lbIndoorTemperatureType.text = @"℃";
            lbTemperature.text = [NSString stringWithFormat:@"%ld",(long)_model.Centigrade];
            lbTemperatureType.text = @"℃";
        }
        else{
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorFahrenheit];
            lbIndoorTemperatureType.text = @"℉";
            lbTemperature.text = [NSString stringWithFormat:@"%ld",(long)_model.Fahrenheit];
            lbTemperatureType.text = @"℉";
        }
        // 设备温度
        lbTemperature.font = [UIFont systemFontOfSize:97];
        CGRect temperatureLabelRect = HSGetLabelRect(lbTemperature.text, 0, 0, 1, 97);
        lbTemperature.frame = CGRectMake((kScreenWIDTH - temperatureLabelRect.size.width) / 2, GPPointY(396) + 64, temperatureLabelRect.size.width, temperatureLabelRect.size.height - 30);
        [self onlineButtonState];
    }
    else if (_model.workState == BimarWorkStateStandbyMode){
        // 关机状态
        if (_model.temperatureFlag) {
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorCentigrade];
            lbIndoorTemperatureType.text = @"℃";
            lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState2"];
        }
        else{
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorFahrenheit];
            lbIndoorTemperatureType.text = @"℉";
            lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState2"];
        }
        [self offState];
        [self offWithButton];
    }
    else{
        // 离线
        lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState0"];
        lbIndoorTemperature.text = @"";
        lbIndoorTemperatureType.text = @"";
        lbTemperatureType.text = @"";
        [self offState];
        [self offWithButton];
    }
        
    // 室温
    lbIndoorTemperature.font = [UIFont systemFontOfSize:17];
    CGRect innerLabelRect = HSGetLabelRect(lbIndoorTemperature.text, 0, 0, 1, 17);
    lbIndoorTemperature.frame = CGRectMake(CGRectGetMaxX(innerImageView.frame) + GPPointX(24), CGRectGetMaxY(innerImageView.frame) - innerLabelRect.size.height, innerLabelRect.size.width, innerLabelRect.size.height);
    //NSLog(@"innerLabelRect  %@",NSStringFromCGRect(innerLabelRect));
    
    // 室温单位
    lbIndoorTemperatureType.font = [UIFont systemFontOfSize:12];
    CGRect innerTypeLabelRect = HSGetLabelRect(lbIndoorTemperatureType.text, 0, 0, 1, 12);
    lbIndoorTemperatureType.frame = CGRectMake(CGRectGetMaxX(lbIndoorTemperature.frame), CGRectGetMaxY(lbIndoorTemperature.frame) - innerTypeLabelRect.size.height, innerTypeLabelRect.size.width, innerTypeLabelRect.size.height);
    //NSLog(@"innerTypeLabelRect  %@",NSStringFromCGRect(innerTypeLabelRect));
    
    // 设备温度
//    temperatureLabel.font = [UIFont systemFontOfSize:97];
//    CGRect temperatureLabelRect = HSGetLabelRect(temperatureLabel.text, 0, 0, 1, 97);
//    temperatureLabel.frame = CGRectMake((kScreenWIDTH - temperatureLabelRect.size.width) / 2, myY(396), temperatureLabelRect.size.width, temperatureLabelRect.size.height - 30);
    //NSLog(@"temperatureLabelRect  %@",NSStringFromCGRect(temperatureLabelRect));
    
    // 设备温度单位
    lbTemperatureType.font = [UIFont systemFontOfSize:20];
    CGRect temperatureTypeLabelRect = HSGetLabelRect(lbTemperatureType.text, 0, 0, 1, 20);
    lbTemperatureType.frame = CGRectMake(CGRectGetMaxX(lbTemperature.frame), CGRectGetMaxY(lbTemperature.frame) - temperatureTypeLabelRect.size.height, temperatureTypeLabelRect.size.width, temperatureTypeLabelRect.size.height);
    //NSLog(@"temperatureTypeLabelRect  %@",NSStringFromCGRect(temperatureTypeLabelRect));
    
    if (_model.workState == BimarWorkStateOnMode) {
        // 运行模式图片
        UIImage *imagea = [UIImage imageNamed:modeImgNamesArray[_model.workMode]];
        modeImageView.image = imagea;
        modeImageView.frame = CGRectMake((kScreenWIDTH - imagea.size.width) / 2, CGRectGetMaxY(lbTemperature.frame) + GPPointY(50), imagea.size.width, imagea.size.height);
        switch (_model.autoTime) {
            case BimarAutoOffTimeNone:
                myCircleView.hidden = YES;
                break;
            case BimarAutoOffTimeOne:
            case BimarAutoOffTimeFifteen:
                myCircleView.hidden = NO;
            default:
                break;
        }
    }
}

- (void) decreseTime:(NSTimer *) sender{
    timelong -= 1;
    myCircleView.progress = timelong / (CGFloat)timetotal;
    if (timelong % 60 == 0) {
        NSInteger hour = timelong / 60 / 60;
        NSInteger min = timelong / 60 % 60;
        NSString *str = nil;
        if (hour == 0) {
            str = [NSString stringWithFormat:@"%luM", min];
        }
        else if(min == 0){
            str = [NSString stringWithFormat:@"%luH", hour];
        }
        else{
            str = [NSString stringWithFormat:@"%luH%luM", hour, min];
        }
        myCircleView.newtimeLabel.text = str;
    }
    if (timelong == 0) {
        UIButton *button = [self.view viewWithTag:801];
        button.selected = YES;
        [self offWithButton];
        [self offState];
    }
}

// 关机状态
- (void) offWithButton{
    myCircleView.hidden = YES;
    lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState2"];
    lbTemperature.font = [UIFont systemFontOfSize:80];
    CGRect temperatureLabelRect = HSGetLabelRect(lbTemperature.text, 0, 0, 1, 80);
    lbTemperature.frame = CGRectMake((kScreenWIDTH - temperatureLabelRect.size.width) / 2, GPPointY(396) + 64, temperatureLabelRect.size.width, temperatureLabelRect.size.height);
    modeImageView.hidden = YES;
    lbTemperatureType.hidden = YES;
    timer.fireDate = [NSDate distantFuture];
}

- (void) offState{
    for (int i=800; i<806; i++) {
        UIButton *button = [self.view viewWithTag:i];
        button.selected = NO;
        button.enabled = NO;
        if (i == 801) {
            button.enabled = YES;
        }
    }
}


- (void) operationButtonClicked:(UIButton *) sender{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef boolForKey:VIBRATE]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([userDef boolForKey:SOUND]) {
        SystemSoundID soundID = 1113;
        AudioServicesPlaySystemSound(soundID);
    }
    switch (sender.tag - 800) {
        case BimarOperateButtonTime:
        {
            _model.autoTime++;
            if ([_model setTimeToAutoOff:_model.autoTime % 16]) {
                switch (_model.autoTime % 16) {
                    case BimarAutoOffTimeNone:
                    {
                        _model.autoTime = BimarAutoOffTimeNone;
                        myCircleView.hidden = YES;
                        sender.selected = NO;
                        timer.fireDate = [NSDate distantFuture];
                        break;
                    }
//                    case BimarAutoOffTimeOne:
//                    case BimarAutoOffTimeTwo:
//                    case BimarAutoOffTimeThree:
//                    case BimarAutoOffTimeFour:
//                    case BimarAutoOffTimeFive:
//                    case BimarAutoOffTimeSix:
//                    case BimarAutoOffTimeSeven:
//                    case BimarAutoOffTimeEight:
//                    case BimarAutoOffTimeNine:
//                    case BimarAutoOffTimeTen:
//                    case BimarAutoOffTimeEleven:
//                    case BimarAutoOffTimeTwelve:
//                    case BimarAutoOffTimeThirteen:
//                    case BimarAutoOffTimeFourteen:
//                    case BimarAutoOffTimeFifteen:
//                        [self changeAutoOffLabelTitle:_model.autoTime % 16];
//                        break;
                    default:
                        [self changeAutoOffLabelTitle:_model.autoTime % 16];
                        break;
                }
            }
            break;
        }
        case BimarOperateButtonOnOff:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                if ([_model turnOnOrOffWithState:YES]) {
                    _model.workState = BimarWorkStateOnMode;
                    _model.autoTime = BimarAutoOffTimeNone;
                    _model.windState = NO;
                    [self showInfomation];
                    for (int i=800; i<806; i++) {
                        UIButton *button = [self.view viewWithTag:i];
                        button.enabled = YES;
                    }
                    lbTemperatureType.hidden = NO;
                    modeImageView.hidden = NO;
                }
            }
            else{
                if ([_model turnOnOrOffWithState:NO]) {
                    _model.workState = BimarWorkStateStandbyMode;
                    [self offWithButton];
                    [self offState];
                }
            }
            break;
        }
        case BimarOperateButtonIncreaseTemperature:
        {
            NSUInteger temp = [_model increaseTemperature];
            if (_model.temperatureFlag) {
                _model.Centigrade = temp;
            }
            else{
                _model.Fahrenheit = temp;
            }
            lbTemperature.text = [NSString stringWithFormat:@"%ld", temp];
            [self adjstFrameWithContent:lbTemperature.text];
            break;
        }
        case BimarOperateButtonWind:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                if ([_model changeWindState:YES]) {
                    _model.windState = YES;
                    NSLog(@"风速开关--  打开");
                }
            }
            else{
                if ([_model changeWindState:NO]) {
                    _model.windState = NO;
                    NSLog(@"风速开关--  已关闭");
                }
            }
            break;
        }
        case BimarOperateButtonMode:
        {
            currentWorkMode++;
            if ([_model changeWorkMode:currentWorkMode % 4]) {
                _model.workMode = currentWorkMode % 4;
                modeImageView.image = [UIImage imageNamed:modeImgNamesArray[_model.workMode]];
            }
            break;
        }
        case BimarOperateButtonDecreaseTemperature:
        {
            NSUInteger temp = [_model decreaseTemperature];
            if (_model.temperatureFlag) {
                _model.Centigrade = temp;
            }
            else{
                _model.Fahrenheit = temp;
            }
            lbTemperature.text = [NSString stringWithFormat:@"%ld", temp];
            [self adjstFrameWithContent:lbTemperature.text];
            break;
        }
        default:
            break;
    }
    [[DataBaseManager sharedManager] updateDeviceInfoWithdevice:_model];
}

- (void) changeAutoOffLabelTitle:(BimarAutoOffTime) time{
    UIButton *btnTime = (UIButton *)[self.view viewWithTag:800];
    _model.autoTime = time;
    myCircleView.hidden = NO;
    _model.endtime = [GPUtil nowTimeIntervalSince1970] + (int)time * 60 * 60;
    btnTime.selected = YES;
    timetotal = 15 * 60 * 60;
    timelong = (int)time * 60 * 60 + 1;
    myCircleView.progress = timelong / (CGFloat)timetotal;
    myCircleView.newtimeLabel.text = [NSString stringWithFormat:@"%dH", (int)time];
    timer.fireDate = [NSDate distantPast];
}

// 调整温度和温度单位的frame
- (void) adjstFrameWithContent:(NSString *) text{
    lbTemperature.font = [UIFont systemFontOfSize:97];
    CGRect temperatureLabelRect = HSGetLabelRect(text, 0, 0, 1, 97);
    lbTemperature.frame = CGRectMake((kScreenWIDTH - temperatureLabelRect.size.width) / 2, GPPointY(396) + 64, temperatureLabelRect.size.width, temperatureLabelRect.size.height - 30);
    CGRect Raa = lbTemperatureType.frame;
    Raa.origin.x = CGRectGetMaxX(lbTemperature.frame);
    lbTemperatureType.frame = Raa;
}

- (void) more:(UIBarButtonItem *) sender{
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    moreVC.model = self.model;
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void) back:(UIBarButtonItem *) sender{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    if (_userHandler) {
        _userHandler(_model);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
