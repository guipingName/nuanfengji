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
    BimarOperateButtonDecreaseTemperature,          // 减小温度
    BimarOperateButtonMAX
};

@interface DeviceOperateViewController (){
    CircleView *myCircleView;           // 倒计时进度
    NSArray *modeImgNamesArray;         // 模式图片资源
    NSUInteger timetotal;               // 设置总时长
    NSUInteger timelong;                // timer对应的时长 repeat
    NSTimer *timer;                     // 定时器
    UILabel *lbTemperature;             // 温度标签
    UIImageView *modeImageView;         // 模式图片
    UIImageView *innerImageView;
    UILabel *lbIndoorTemperature;
}

@end

@implementation DeviceOperateViewController


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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --------------- 通知事件处理 ----------------
- (void) changeTemperatureType:(NSNotification *) sender{
    if ([sender.object boolValue]) {
        _model.temperatureFlag = YES;
    }
    else{
        _model.temperatureFlag = NO;
    }
    [self showInfomation];
}

#pragma mark --------------- 数据刷新 ----------------
- (void) showInfomation{
    if (_model.workState == BimarWorkStateOnMode) {
        // 开机状态
        CGRect temperatureLabelRect = CGRectZero;
        if (_model.temperatureFlag) {
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld℃",(long)_model.indoorCentigrade];
            lbTemperature.text = [NSString stringWithFormat:@"%ld℃",(long)_model.Centigrade];
            temperatureLabelRect = [GPUtil attributedLabel:lbTemperature String:@"℃" firstSize:97 lastSize:20];
        }
        else{
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld℉",(long)_model.indoorFahrenheit];
            lbTemperature.text = [NSString stringWithFormat:@"%ld℉",(long)_model.Fahrenheit];
            temperatureLabelRect = [GPUtil attributedLabel:lbTemperature String:@"℉" firstSize:97 lastSize:20];
        }
        lbTemperature.frame = CGRectMake((KSCREEN_WIDTH - temperatureLabelRect.size.width) / 2, POINT_Y(588), temperatureLabelRect.size.width, temperatureLabelRect.size.height - 30);
        [self onlineButtonState];
    }
    else if (_model.workState == BimarWorkStateStandbyMode){
        // 关机状态
        if (_model.temperatureFlag) {
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld℃",(long)_model.indoorCentigrade];
            lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState2"];
        }
        else{
            lbIndoorTemperature.text = [NSString stringWithFormat:@"%ld℉",(long)_model.indoorFahrenheit];
            lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState2"];
        }
        [self offState];
        [self offWithButton];
    }
    else{
        // 离线
        lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState0"];
        lbIndoorTemperature.text = @"";
        [self offState];
        [self offWithButton];
    }
    NSString *tempFlag = nil;
    if (_model.temperatureFlag) {
        tempFlag = @"℃";
    }
    else{
        tempFlag = @"℉";
    }
    CGRect lbIndoorTemperatureRect = [GPUtil attributedLabel:lbIndoorTemperature String:tempFlag firstSize:17 lastSize:8.5];
    lbIndoorTemperature.frame = CGRectMake(CGRectGetMaxX(innerImageView.frame) + GPWIDTH(24), CGRectGetMaxY(innerImageView.frame) - lbIndoorTemperatureRect.size.height + 3, lbIndoorTemperatureRect.size.width, lbIndoorTemperatureRect.size.height);
    
    if (_model.workState == BimarWorkStateOnMode) {
        // 运行模式图片
        UIImage *imagea = [UIImage imageNamed:modeImgNamesArray[_model.workMode]];
        modeImageView.image = imagea;
        //modeImageView.frame = CGRectMake((KSCREEN_WIDTH - imagea.size.width) / 2, CGRectGetMaxY(lbTemperature.frame) + POINT_Y(50), imagea.size.width, imagea.size.height);
        modeImageView.frame = CGRectMake((KSCREEN_WIDTH - imagea.size.width) / 2, POINT_Y(959), GPHEIGHT(150), GPHEIGHT(150));
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

// 开机状态下按钮状态
- (void) onlineButtonState{
    UIButton *btnTime = [self.view viewWithTag:BTN_TIME_TAG];
    UIButton *btnIsOn = [self.view viewWithTag:BTN_ONOFF_TAG];
    UIButton *btnWind = [self.view viewWithTag:BTN_WIND_TAG];
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

// 关机状态UI隐藏
- (void) offWithButton{
    myCircleView.hidden = YES;
    lbTemperature.text = [ChangeLanguage getContentWithKey:@"deviceState2"];
    lbTemperature.font = [UIFont systemFontOfSize:80];
    CGRect temperatureLabelRect = LABEL_RECT(lbTemperature.text, 0, 0, 1, 80);
    lbTemperature.frame = CGRectMake((KSCREEN_WIDTH - temperatureLabelRect.size.width) / 2, POINT_Y(588), temperatureLabelRect.size.width, temperatureLabelRect.size.height);
    modeImageView.hidden = YES;
    timer.fireDate = [NSDate distantFuture];
}

// 关机状态禁用按钮
- (void) offState{
    for (int i=BTN_TIME_TAG; i<BTN_TIME_TAG + BimarOperateButtonMAX; i++) {
        UIButton *button = [self.view viewWithTag:i];
        button.selected = NO;
        button.enabled = NO;
        if (i == BTN_ONOFF_TAG) {
            button.enabled = YES;
        }
    }
}

#pragma mark --------------- NSTimer事件 ----------------
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
        UIButton *button = [self.view viewWithTag:BTN_ONOFF_TAG];
        button.selected = YES;
        [self offWithButton];
        [self offState];
    }
}


#pragma mark --------------- 控制按钮点击事件 ----------------
- (void) operationButtonClicked:(UIButton *) sender{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef boolForKey:VIBRATE]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([userDef boolForKey:SOUND]) {
        SystemSoundID soundID = 1113;
        AudioServicesPlaySystemSound(soundID);
    }
    switch (sender.tag - BTN_TIME_TAG) {
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
                    for (int i=BTN_TIME_TAG; i<BTN_TIME_TAG + BimarOperateButtonMAX; i++) {
                        UIButton *button = [self.view viewWithTag:i];
                        button.enabled = YES;
                    }
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
            NSString *tempFlag = nil;
            if (_model.temperatureFlag) {
                _model.Centigrade = temp;
                tempFlag = @"℃";
            }
            else{
                _model.Fahrenheit = temp;
                tempFlag = @"℉";
            }
            lbTemperature.text = [NSString stringWithFormat:@"%ld%@", temp,tempFlag];
            [self adjstFrameWithContentString:tempFlag];
            break;
        }
        case BimarOperateButtonWind:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                if ([_model changeWindState:YES]) {
                    _model.windState = YES;
                    //NSLog(@"风速开关--  打开");
                }
            }
            else{
                if ([_model changeWindState:NO]) {
                    _model.windState = NO;
                    //NSLog(@"风速开关--  已关闭");
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
            NSString *tempFlag = nil;
            if (_model.temperatureFlag) {
                _model.Centigrade = temp;
                tempFlag = @"℃";
            }
            else{
                _model.Fahrenheit = temp;
                tempFlag = @"℉";
            }
            lbTemperature.text = [NSString stringWithFormat:@"%ld%@", temp,tempFlag];
            [self adjstFrameWithContentString:tempFlag];
            break;
        }
        default:
            break;
    }
    //[[DataBaseManager sharedManager] updateDeviceInfoWithdevice:_model];
    [_model updateDeviceInfo];
}

// 显示定时器时长
- (void) changeAutoOffLabelTitle:(BimarAutoOffTime) time{
    UIButton *btnTime = (UIButton *)[self.view viewWithTag:BTN_TIME_TAG];
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
- (void) adjstFrameWithContentString:(NSString *) searchString{
    //CGRect temperatureLabelRect = [self abc:lbTemperature FontOfSize:97 FontOfSize1:20];
    CGRect temperatureLabelRect = [GPUtil attributedLabel:lbTemperature String:searchString firstSize:97 lastSize:20];
    lbTemperature.frame = CGRectMake((KSCREEN_WIDTH - temperatureLabelRect.size.width) / 2, POINT_Y(588), temperatureLabelRect.size.width, temperatureLabelRect.size.height - 30);
}

- (void) creatSubviews{
    // 室内温度图标
    innerImageView = [[UIImageView alloc] init];
    UIImage *innerImage = [UIImage imageNamed:@"室温144px"];
    innerImageView.image = innerImage;
    innerImageView.frame = CGRectMake(POINT_X(51), POINT_Y(90) + 64, GPHEIGHT(92), GPHEIGHT(92));
    //innerImageView.frame = CGRectMake(myX(51), myY(90), innerImage.size.width, innerImage.size.height);
    [self.view addSubview:innerImageView];
    
    // 创建温度及温度单位标签
    lbIndoorTemperature = [[UILabel alloc] init];
    [self.view addSubview:lbIndoorTemperature];
    lbIndoorTemperature.textColor = [UIColor whiteColor];
    //lbIndoorTemperature.backgroundColor = [UIColor redColor];
    
    lbTemperature = [[UILabel alloc] init];
    [self.view addSubview:lbTemperature];
    lbTemperature.textColor = [UIColor whiteColor];
    //lbTemperature.backgroundColor = [UIColor redColor];
    
    // 添加定时器进度条
    myCircleView = [[CircleView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH - POINT_X(51) - POINT_Y(206), POINT_Y(50) + 64, GPHEIGHT(206), GPHEIGHT(206))];
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
    for (int i=0; i<BimarOperateButtonMAX; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.frame = CGRectMake(POINT_X(33) +(i % 3) * POINT_X(399) , POINT_Y(1226) + (i / 3) * GPHEIGHT(346), GPWIDTH(378), GPHEIGHT(316));
        button.backgroundColor = UICOLOR_RGBA(255, 255, 255, 0.25);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setImage:[UIImage imageNamed:imageNamesN[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageNamesH[i]] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:imageNamesH[i]] forState:UIControlStateHighlighted];
        button.tag = BTN_TIME_TAG + i;
        [button addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark --------------- NavigationItem事件 ----------------
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
