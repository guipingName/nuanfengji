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
        _CelsiusTemperature = --_CelsiusTemperature;
        if (_CelsiusTemperature < 5) {
            _CelsiusTemperature = 5;
            return 5;
        }
        return _CelsiusTemperature;
    }
    else{
        _Fahrenheit = --_Fahrenheit;
        if (_Fahrenheit < 41) {
            _Fahrenheit = 41;
            return 41;
        }
        
        return _Fahrenheit;
    }
}

-(NSUInteger)increaseTemperature{
    if (_temperatureFlag) {
        _CelsiusTemperature = ++_CelsiusTemperature;
        if (_CelsiusTemperature > 37) {
            _CelsiusTemperature = 37;
            return 37;
        }
        return _CelsiusTemperature;
    }
    else{
        _Fahrenheit = ++_Fahrenheit;
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

-(BOOL)changTemperatureFlag{
    _temperatureFlag = !_temperatureFlag;
    return !_temperatureFlag;
}

- (void) machineDefault{
    _workState = YES;
    _CelsiusTemperature = 20;
    _workMode = BimarWorkModeSmallFire;
    _indoorCelsiusTemperature = 18;
    _indoorFahrenheit = 48;
    _Fahrenheit = 30;
    _windState = NO;
    _autoTime = BimarAutoOffTimeNone;
}
@end
