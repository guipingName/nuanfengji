//
//  DataBaeManager.h
//  warmwind
//
//  Created by guiping on 17/2/27.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//



#import <Foundation/Foundation.h>

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
 *  @param deviceName  设备名称
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

@end
