//
//  DeviceModel.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "BimarDevice.h"

@implementation BimarDevice{
    FMDatabase *_fmdb;
}

- (instancetype)init{
    if (self = [super init]) {
        NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [[documentsPath firstObject] stringByAppendingPathComponent:@"deviceList.db"];
        //NSLog(@"%@",dbPath);
        if (!_fmdb) {
            _fmdb = [[FMDatabase alloc] initWithPath:dbPath];
        }
        if ([_fmdb open]) {

        }
    }
    return self;
}

-(BOOL)turnOnOrOffWithState:(BOOL)on{
    return YES;
}

-(BOOL)changeWorkMode:(BimarWorkMode)workMode{
    return YES;
}

-(BOOL)changeWindState:(BOOL)on{
    return YES;
}

-(NSUInteger)decreaseTemperature{
    if (_temperatureFlag) {
        _Centigrade = --_Centigrade;
        _Fahrenheit = _Centigrade * 1.8 + 32;
        if (_Centigrade < 5) {
            _Centigrade = 5;
            _Fahrenheit = 41;
            return 5;
        }
        return _Centigrade;
    }
    else{
        _Fahrenheit = --_Fahrenheit;
        _Centigrade = (_Fahrenheit - 32) / 1.8;
        if (_Fahrenheit < 41) {
            _Fahrenheit = 41;
            _Centigrade = 32;
            return 41;
        }
        return _Fahrenheit;
    }
}

-(NSUInteger)increaseTemperature{
    if (_temperatureFlag) {
        _Centigrade = ++_Centigrade;
        _Fahrenheit = _Centigrade * 1.8 + 32;
        if (_Centigrade > 37) {
            _Centigrade = 37;
            _Fahrenheit = 99;
            return 37;
        }
        return _Centigrade;
    }
    else{
        _Fahrenheit = ++_Fahrenheit;
        _Centigrade = (_Fahrenheit - 32) / 1.8;
        if (_Fahrenheit > 99) {
            _Fahrenheit = 99;
            return 99;
        }
        return _Fahrenheit;
    }
}

-(BOOL)setTimeToAutoOff:(BimarAutoOffTime)time{
    return YES;
}

-(BOOL) renameWithDeviceName:(NSString *) deviceName{
    NSString *str = [NSString stringWithFormat:@"update deviceList set deviceName='%@' where deviceId=%lld;", deviceName, (long long)_deviceId];
    return [_fmdb executeUpdate:str];
}

-(BOOL) modifyPasswordWithPassword:(NSString *) password{
    NSString *str = [NSString stringWithFormat:@"update deviceList set password='%@' where deviceId=%lld;", password, (long long)_deviceId];
    return [_fmdb executeUpdate:str];
}

-(BOOL) updateDeviceInfo{
    NSString *str = [NSString stringWithFormat:@"update deviceList set workState=%d, workMode=%d,windState=%d, autoTime=%d, endtime=%d,temperatureFlag=%d, Centigrade=%lu,Fahrenheit=%lu, indoorCentigrade=%d, indoorFahrenheit=%d where deviceId=%lld;", (int)_workState , (int)_workMode, (int)_windState, (int)_autoTime, (int)_endtime, (int)_temperatureFlag, _Centigrade, _Fahrenheit, (int)_indoorCentigrade, (int)_indoorFahrenheit, (long long)_deviceId];
    return [_fmdb executeUpdate:str];
}
@end
