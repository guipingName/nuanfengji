//
//  DeviceModel.h
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BimarWorkMode) {
    BimarWorkModeSmallFire,      // 小火
    BimarWorkModeMiddleFire,     // 中火
    BimarWorkModeHighFire,       // 大火
    BimarWorkModePreventFrost    // 防霜冻
};

typedef NS_ENUM(NSInteger, BimarAutoOffTime) {
    BimarAutoOffTimeNone,       // 关闭
    BimarAutoOffTimeOne,        // 1小时
    BimarAutoOffTimeFifteen    // 15小时
};

typedef NS_ENUM(NSInteger, BimarWorkState) {
    BimarWorkStateOffMode,       // 离线
    BimarWorkStateOnMode,        // 在线
    BimarWorkStateStandbyMode    // 待机
};


@interface BimarDevice : NSObject

/**唯一标识*/
@property (nonatomic, assign) NSInteger deviceId;

/**名称*/
@property (nonatomic, copy) NSString *deviceName;

/**密码*/
@property (nonatomic, copy) NSString *password;

/**运行状态()*/
@property (nonatomic, assign) BimarWorkState workState;

/**运行模式*/
@property (nonatomic, assign) BimarWorkMode workMode;

/**风的使用状态*/
@property (nonatomic, assign) BOOL windState;

/**定时时长*/
@property (nonatomic, assign) BimarAutoOffTime autoTime;

/**温度单位标志(YES 摄氏温度, NO 华氏温度)*/
@property (nonatomic, assign) BOOL temperatureFlag;

/**摄氏温度值(5℃~37℃)*/
@property (nonatomic, assign) NSUInteger CelsiusTemperature;

/**华氏温度值(41℉~99℉)*/
@property (nonatomic, assign) NSUInteger Fahrenheit;

/**室内摄氏温度值*/
@property (nonatomic, assign) NSInteger indoorCelsiusTemperature;

/**室内华氏温度值*/
@property (nonatomic, assign) NSInteger indoorFahrenheit;



/**
 *  增加温度值
 */
- (NSUInteger) increaseTemperature;

/**
 *  降低温度值
 */
- (NSUInteger) decreaseTemperature;

/**
 *  改变运行模式
 *
 *  @return 当前运行模式
 */
- (BOOL) changeWorkMode:(BimarWorkMode) workMode;

/**
 *  改变风的使用状态
 *
 *  @return (YES 成功;  NO 失败)
 */
- (BOOL) changeWindState:(BOOL) on;

/**
 *  设置自动关闭
 *
 *  @return 返回设置的时长
 */
- (BOOL) setTimeToAutoOff:(BimarAutoOffTime) time;


/**
 *  打开或关闭
 *
 * @params on 状态
 *
 *  @return (YES 成功;  NO 失败)
 */
- (BOOL) turnOnOrOffWithState:(BOOL) on;

/**
 *  设置显示温度单位
 *
 *  @retuen (YES 摄氏温度;  NO 法式温度)
 */
- (BOOL) changTemperatureFlag;


@end
