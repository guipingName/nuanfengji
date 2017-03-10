//
//  DataBaeManager.h
//  warmwind
//
//  Created by guiping on 17/2/27.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//



#import <Foundation/Foundation.h>

@class BimarDevice;
@interface DataBaseManager : NSObject

/**
 *  创建单例对象
 *
 *  @return DataBaseManager对象
 */
+ (instancetype) sharedManager;


/**
 *  添加一个设备
 *
 *  @param deviceId  设备标识
 *  @param deviceName    设备名称
 *  @param password 设备密码
 *
 *  @return 成功返回YES
 */
- (BOOL) addDeviceWithDeviceId:(NSInteger)deviceId deviceName:(NSString *)deviceName password:(NSString *)password;

/**
 *  获取所有设备
 *
 *  @return 数组
 */
- (NSArray *) loadDeviceInformation;


/**
 *  删除一台设备
 *
 *  @param deviceId  设备标识
 *
 *  @return 成功返回YES
 */
- (BOOL) deleteDeviceWithDeviceId:(NSInteger) deviceId;

/**
 *  修改设备名称
 *
 *  @param deviceId  设备标识
 *  @param deviceName  设备名称
 *
 *  @return 成功返回YES
 */
- (BOOL) updateDeviceNameWithDeviceId:(NSInteger) deviceId deviceName:(NSString *) deviceName;

/**
 *  修改设备名称
 *
 *  @param deviceId  设备标识
 *  @param password  设备密码
 *
 *  @return 成功返回YES
 */
- (BOOL) updateDevicePasswordWithDeviceId:(NSInteger) deviceId password:(NSString *) password;

/**
 *  修改设备名称
 *
 *  @param model  设备对象
 *
 *  @return 成功返回YES
 */
- (BOOL) updateDeviceInfoWithdevice:(BimarDevice *) model;


@end
