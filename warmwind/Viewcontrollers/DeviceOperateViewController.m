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
    NSTimer *timer;
    UILabel *temperatureTypeLabel;      // 设备温度单位标签
    UILabel *temperatureLabel;          // 温度标签
    UIImageView *modeImageView;         // 模式图片
    UIImageView *innerImageView;
}

@end

@implementation DeviceOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _model.deviceName;
    [GPUtil backgroundImageView:self.view];
    currentWorkMode = _model.workMode;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(more:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    // 室内温度图标
    innerImageView = [[UIImageView alloc] init];
    UIImage *innerImage = [UIImage imageNamed:@"室温144px"];
    innerImageView.image = innerImage;
    innerImageView.frame = CGRectMake(myX(51), myY(90), 48, 48);
    [self.view addSubview:innerImageView];
    
    // 创建4个温度标签
    for (int i=0; i<4; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = 888 + i;
        //label.backgroundColor = [UIColor redColor];
        [self.view addSubview:label];
        label.textColor = [UIColor whiteColor];
    }
    
    // 添加定时器进度条
    myCircleView = [[CircleView alloc] initWithFrame:CGRectMake(kScreenWIDTH - myX(51) - myY(206), myY(50), myY(206), myY(206))];
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
        button.frame = CGRectMake(myX(33) +(i % 3) * myX(399) , myY(1033) + (i / 3) * myY(346), myX(378), myY(316));
        button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        //[button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateSelected];
        //if ( i==2 || i == 4 || i == 5) {
        [button setImage:[UIImage imageNamed:imageNamesN[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageNamesH[i]] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:imageNamesH[i]] forState:UIControlStateHighlighted];
        //}
        button.tag = 800 + i;
        [button addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    //[self aaa];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTemperatureType:) name:@"temperatureFlag" object:nil];
    
    // 显示数据
    [self showInfomation];
}

// 开机状态下按钮状态
- (void) buttonState{
    UIButton *time = [self.view viewWithTag:800];
    UIButton *on = [self.view viewWithTag:801];
    UIButton *wind = [self.view viewWithTag:803];
    [wind setImage:[UIImage imageNamed:@"bimarBtn风速_gray"] forState:UIControlStateNormal];
    [wind setImage:[UIImage imageNamed:@"bimarBtn风速"] forState:UIControlStateSelected];
    [time setImage:[UIImage imageNamed:@"bimarBtn定时_gray"] forState:UIControlStateNormal];
    [time setImage:[UIImage imageNamed:@"bimarBtn定时"] forState:UIControlStateSelected];
    on.selected = YES;
    if (_model.autoTime == BimarAutoOffTimeNone) {
        time.selected = NO;
    }
    else{
        time.selected = YES;
    }
    if (_model.windState) {
        wind.selected = YES;
    }
    else{
        wind.selected = NO;
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
    UILabel *innerLabel = [self.view viewWithTag:888];
    UILabel *innerTypeLabel = [self.view viewWithTag:889];
    temperatureLabel = [self.view viewWithTag:890];
    temperatureTypeLabel = [self.view viewWithTag:891];
    //
    if (_model.workState == BimarWorkStateOnMode) {
        // 开机状态
        if (_model.temperatureFlag) {
            innerLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorCelsiusTemperature];
            innerTypeLabel.text = @"℃";
            temperatureLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.CelsiusTemperature];
            temperatureTypeLabel.text = @"℃";
        }
        else{
            innerLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorFahrenheit];
            innerTypeLabel.text = @"℉";
            temperatureLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.Fahrenheit];
            temperatureTypeLabel.text = @"℉";
        }
        [self buttonState];
    }
    else if (_model.workState == BimarWorkStateStandbyMode){
        // 关机状态
        if (_model.temperatureFlag) {
            innerLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorCelsiusTemperature];
            innerTypeLabel.text = @"℃";
            temperatureLabel.text = @"待机";
        }
        else{
            innerLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.indoorFahrenheit];
            innerTypeLabel.text = @"℉";
            temperatureLabel.text = @"待机";
        }
        [self guanjianniu];
    }
    else{
        // 离线
        temperatureLabel.text = @"离线";
        innerLabel.text = @"";
        innerTypeLabel.text = @"";
        temperatureTypeLabel.text = @"";
        [self guanjianniu];
    }
        
    // 室温
    innerLabel.font = [UIFont systemFontOfSize:17];
    CGRect innerLabelRect = HSGetLabelRect(innerLabel.text, 0, 0, 1, 17);
    innerLabel.frame = CGRectMake(CGRectGetMaxX(innerImageView.frame) + myX(24), CGRectGetMaxY(innerImageView.frame) - innerLabelRect.size.height, innerLabelRect.size.width, innerLabelRect.size.height);
    //NSLog(@"innerLabelRect  %@",NSStringFromCGRect(innerLabelRect));
    
    // 室温单位
    innerTypeLabel.font = [UIFont systemFontOfSize:12];
    CGRect innerTypeLabelRect = HSGetLabelRect(innerTypeLabel.text, 0, 0, 1, 12);
    innerTypeLabel.frame = CGRectMake(CGRectGetMaxX(innerLabel.frame), CGRectGetMaxY(innerLabel.frame) - innerTypeLabelRect.size.height, innerTypeLabelRect.size.width, innerTypeLabelRect.size.height);
    //NSLog(@"innerTypeLabelRect  %@",NSStringFromCGRect(innerTypeLabelRect));
    
    // 设备温度
    temperatureLabel.font = [UIFont systemFontOfSize:97];
    CGRect temperatureLabelRect = HSGetLabelRect(temperatureLabel.text, 0, 0, 1, 97);
    temperatureLabel.frame = CGRectMake((kScreenWIDTH - temperatureLabelRect.size.width) / 2, myY(396), temperatureLabelRect.size.width, temperatureLabelRect.size.height - 30);
    //NSLog(@"temperatureLabelRect  %@",NSStringFromCGRect(temperatureLabelRect));
    
    // 设备温度单位
    temperatureTypeLabel.font = [UIFont systemFontOfSize:20];
    CGRect temperatureTypeLabelRect = HSGetLabelRect(temperatureTypeLabel.text, 0, 0, 1, 20);
    temperatureTypeLabel.frame = CGRectMake(CGRectGetMaxX(temperatureLabel.frame), CGRectGetMaxY(temperatureLabel.frame) - temperatureTypeLabelRect.size.height, temperatureTypeLabelRect.size.width, temperatureTypeLabelRect.size.height);
    //NSLog(@"temperatureTypeLabelRect  %@",NSStringFromCGRect(temperatureTypeLabelRect));
    
    if (_model.workState == BimarWorkStateOnMode) {
        // 运行模式图片
        UIImage *imagea = [UIImage imageNamed:modeImgNamesArray[_model.workMode]];
        modeImageView.image = imagea;
        modeImageView.frame = CGRectMake((kScreenWIDTH - imagea.size.width) / 2, CGRectGetMaxY(temperatureLabel.frame) + myY(50), imagea.size.width, imagea.size.height);
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

- (void) guanjianniu{
    for (int i=800; i<806; i++) {
        UIButton *button = [self.view viewWithTag:i];
        button.selected = NO;
        button.enabled = NO;
        if (i == 801) {
            button.enabled = YES;
        }
    }
}

- (void) decreseTime:(NSTimer *) sender{
    timelong -= 30;
    myCircleView.progress = timelong / (CGFloat)timetotal;
    if (timelong % 60 == 0) {
        NSInteger hour = timelong / 60 / 60;
        NSInteger min = timelong / 60 % 60;
        NSString *str = nil;
        if (hour == 0) {
            str = [NSString stringWithFormat:@"%luM", min];
        }
        else{
            str = [NSString stringWithFormat:@"%luH%luM", hour, min];
        }
        myCircleView.newtimeLabel.text = str;
    }
    if (timelong == 0) {
        // 销毁timer
        UIButton *button = [self.view viewWithTag:801];
        button.selected = YES;
        [self offWithButton];
        [self guanjianniu];
    }
}

// 关机状态
- (void) offWithButton{
    myCircleView.hidden = YES;
    temperatureLabel.text = @"待机";
    temperatureLabel.font = [UIFont systemFontOfSize:80];
    CGRect temperatureLabelRect = HSGetLabelRect(temperatureLabel.text, 0, 0, 1, 80);
    temperatureLabel.frame = CGRectMake((kScreenWIDTH - temperatureLabelRect.size.width) / 2, myY(396), temperatureLabelRect.size.width, temperatureLabelRect.size.height);
    modeImageView.hidden = YES;
    temperatureTypeLabel.hidden = YES;
    timer.fireDate = [NSDate distantFuture];
}

- (void) operationButtonClicked:(UIButton *) sender{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef boolForKey:@"shakeState"]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([userDef boolForKey:@"soundState"]) {
        SystemSoundID soundID = 1113;
        AudioServicesPlaySystemSound(soundID);
    }
    switch (sender.tag - 800) {
        case BimarOperateButtonTime:
        {
            _model.autoTime++;
            if ([_model setTimeToAutoOff:_model.autoTime % 3]) {
                switch (_model.autoTime % 3) {
                    case BimarAutoOffTimeNone:
                        NSLog(@"关闭");
                        myCircleView.hidden = YES;
                        sender.selected = NO;
                        timer.fireDate = [NSDate distantFuture];
                        break;
                    case BimarAutoOffTimeOne:
                        NSLog(@"1H");
                        myCircleView.hidden = NO;
                        sender.selected = YES;
                        timetotal = 1 * 60 * 60;
                        timelong = timetotal;
                        myCircleView.newtimeLabel.text = @"1H";
                        myCircleView.progress = 1.0;
                        timer.fireDate = [NSDate distantPast];
                        break;
                    case BimarAutoOffTimeFifteen:
                        NSLog(@"15H");
                        myCircleView.hidden = NO;
                        sender.selected = YES;
                        timetotal = 15 * 60 * 60;
                        timelong = timetotal;
                        myCircleView.progress = 1.0;
                        timer.fireDate = [NSDate distantPast];
                        myCircleView.newtimeLabel.text = @"15H";
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        case BimarOperateButtonOnOff:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                NSLog(@"开机");
                if ([_model turnOnOrOffWithState:YES]) {
                    _model.workState = BimarWorkStateOnMode;
                    _model.autoTime = BimarAutoOffTimeNone;
                    _model.windState = NO;
                    [self showInfomation];
                    for (int i=800; i<806; i++) {
                        UIButton *button = [self.view viewWithTag:i];
                        button.enabled = YES;
                    }
                    temperatureTypeLabel.hidden = NO;
                    modeImageView.hidden = NO;
                }
            }
            else{
                NSLog(@"已关机");
                if ([_model turnOnOrOffWithState:NO]) {
                    _model.workState = BimarWorkStateStandbyMode;
                    [self offWithButton];
                    [self guanjianniu];
                }
            }
            break;
        }
        case BimarOperateButtonIncreaseTemperature:
        {
            NSUInteger temp = [_model increaseTemperature];
            if (_model.temperatureFlag) {
                _model.CelsiusTemperature = temp;
            }
            else{
                _model.Fahrenheit = temp;
            }
            temperatureLabel.text = [NSString stringWithFormat:@"%ld", temp];
            [self adjstFrameWithContent:temperatureLabel.text];
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
                _model.CelsiusTemperature = temp;
            }
            else{
                _model.Fahrenheit = temp;
            }
            temperatureLabel.text = [NSString stringWithFormat:@"%ld", temp];
            [self adjstFrameWithContent:temperatureLabel.text];
            break;
        }
        default:
            break;
    }
}

// 调整温度和温度单位的frame
- (void) adjstFrameWithContent:(NSString *) text{
    temperatureLabel.font = [UIFont systemFontOfSize:97];
    CGRect temperatureLabelRect = HSGetLabelRect(text, 0, 0, 1, 97);
    temperatureLabel.frame = CGRectMake((kScreenWIDTH - temperatureLabelRect.size.width) / 2, myY(396), temperatureLabelRect.size.width, temperatureLabelRect.size.height - 30);
    CGRect Raa = temperatureTypeLabel.frame;
    Raa.origin.x = CGRectGetMaxX(temperatureLabel.frame);
    temperatureTypeLabel.frame = Raa;
}

-(void)dealloc{
    NSLog(@"%s", object_getClassName(self));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
