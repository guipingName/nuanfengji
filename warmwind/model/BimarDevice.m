//
//  DeviceModel.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "BimarDevice.h"

@implementation BimarDevice

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


@end
