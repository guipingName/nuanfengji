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
    BimarAutoOffTimeNone,           // 关闭
    BimarAutoOffTimeOne,            // 1小时
    BimarAutoOffTimeTwo,            // 2小时
    BimarAutoOffTimeThree,          // 3小时
    BimarAutoOffTimeFour,           // 4小时
    BimarAutoOffTimeFive,           // 5小时
    BimarAutoOffTimeSix,            // 6小时
    BimarAutoOffTimeSeven,          // 7小时
    BimarAutoOffTimeEight,          // 8小时
    BimarAutoOffTimeNine,           // 9小时
    BimarAutoOffTimeTen,            // 10小时
    BimarAutoOffTimeEleven,         // 11小时
    BimarAutoOffTimeTwelve,         // 12小时
    BimarAutoOffTimeThirteen,       // 13小时
    BimarAutoOffTimeFourteen,       // 14小时
    BimarAutoOffTimeFifteen         // 15小时
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

/**运行状态*/
@property (nonatomic, assign) BimarWorkState workState;

/**运行模式*/
@property (nonatomic, assign) BimarWorkMode workMode;

/**风的使用状态*/
@property (nonatomic, assign) BOOL windState;

/**定时时长*/
@property (nonatomic, assign) BimarAutoOffTime autoTime;

/**定时器结束时间(1970)*/
@property (nonatomic, assign) NSInteger endtime;

/**温度单位标志(YES 摄氏温度, NO 华氏温度)*/
@property (nonatomic, assign) BOOL temperatureFlag;

/**摄氏温度值(5℃~37℃)*/
@property (nonatomic, assign) NSUInteger Centigrade;

/**华氏温度值(41℉~99℉)*/
@property (nonatomic, assign) NSUInteger Fahrenheit;

/**室内摄氏温度值*/
@property (nonatomic, assign) NSInteger indoorCentigrade;

/**室内华氏温度值*/
@property (nonatomic, assign) NSInteger indoorFahrenheit;


/**
 *  打开或关闭
 *
 *  @param isOn 状态:YES打开 NO关闭
 *
 *  @return 操作状态:YES 成功; NO 失败
 */
- (BOOL) turnOnOrOffWithState:(BOOL) isOn;

/**
 *  设置自动关闭
 *
 *  @param time 设置的时长
 *
 *  @return 操作状态:YES 成功; NO 失败
 */
- (BOOL) setTimeToAutoOff:(BimarAutoOffTime) time;

/**
 *  改变风的使用状态
 *
 *  @param isOn 打开状态:YES打开 NO关闭
 *
 *  @return 操作状态:YES 成功; NO 失败
 */
- (BOOL) changeWindState:(BOOL) isOn;

/**
 *  改变运行模式
 *
 *  @return 当前运行模式
 */
- (BOOL) changeWorkMode:(BimarWorkMode) workMode;


/**
 *  增加温度值
 *
 *  @return 当前温度值
 */
- (NSUInteger) increaseTemperature;

/**
 *  降低温度值
 *
 *  @return 当前温度值
 */
- (NSUInteger) decreaseTemperature;

/**
 *  修改设备名称
 *
 *  @param deviceName  设备名称
 *
 *  @return 成功返回YES
 */
-(BOOL) renameWithDeviceName:(NSString *) deviceName;

/**
 *  修改设备名称
 *
 *  @param password  设备密码
 *
 *  @return 成功返回YES
 */
-(BOOL) modifyPasswordWithPassword:(NSString *) password;

/**
 *  修改设备名称
 *
 *  @return 成功返回YES
 */
- (BOOL) updateDeviceInfo;

@end
