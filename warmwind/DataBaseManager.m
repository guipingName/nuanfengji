//
//  DataBaeManager.h
//  warmwind
//
//  Created by guiping on 17/2/27.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDB.h"


@implementation DataBaseManager{
    FMDatabase *_fmdb;
}

- (instancetype) init{
    @throw [NSException exceptionWithName:@"初始化对象异常" reason:@"不允许通过初始化方法创建对象" userInfo:nil];
    return self;
}

- (instancetype) initPrivate{
    if (self = [super init]) {
        [self creatDataBase];
    }
    return self;
}

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static DataBaseManager *dataManager = nil;
    dispatch_once(&onceToken, ^{
        if (!dataManager) {
            dataManager = [[DataBaseManager alloc] initPrivate];
        }
    });
    return dataManager;
}

- (void) creatDataBase{
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[documentsPath firstObject] stringByAppendingPathComponent:@"deviceList.db"];
    //NSLog(@"%@",dbPath);
    
    if (!_fmdb) {
        _fmdb = [[FMDatabase alloc] initWithPath:dbPath];
    }
    
    // 打开数据库
    if ([_fmdb open]) {
        // 创建一个数据库表
        [_fmdb executeUpdate:@"create Table if not exists deviceList (deviceId int primary key,deviceName,password,workState int default 0,workMode int default 0,windState blob default 0,autoTime int default 0,temperatureFlag blob default 1,CelsiusTemperature int default 23,Fahrenheit int default 55,indoorCelsiusTemperature int default 18,indoorFahrenheit int default 39);"];
    }
}

-(BOOL)insertDeviceWithDeviceId:(NSInteger)deviceId deviceName:(NSString *)deviceName password:(NSString *)password{
    return [_fmdb executeUpdate:@"insert into deviceList (deviceId, deviceName, password) values (?,?,?);", @(deviceId), deviceName, password];
}


-(NSArray *)getAllDevices{
    FMResultSet *rs = [_fmdb executeQuery:@"select *from deviceList"];
    NSMutableArray *devices = [NSMutableArray array];
    while ([rs next]) {
        BimarDevice *model = [[BimarDevice alloc] init];
        model.deviceId = [rs intForColumn:@"deviceId"];
        model.deviceName = [rs stringForColumn:@"deviceName"];
        model.password = [rs stringForColumn:@"password"];
        model.workState = [rs intForColumn:@"workState"];
        model.workMode = [rs intForColumn:@"workMode"];
        model.windState = [rs boolForColumn:@"windState"];
        model.autoTime = [rs intForColumn:@"autoTime"];
        model.temperatureFlag = [rs boolForColumn:@"temperatureFlag"];
        model.CelsiusTemperature = [rs intForColumn:@"CelsiusTemperature"];
        model.Fahrenheit = [rs intForColumn:@"Fahrenheit"];
        model.indoorCelsiusTemperature = [rs intForColumn:@"indoorCelsiusTemperature"];
        model.indoorFahrenheit = [rs intForColumn:@"indoorFahrenheit"];
        [devices addObject:model];
    }
    return [devices copy];
}


-(BOOL)deleteDeviceWithDeviceId:(NSInteger)deviceId{
    NSString *str= [NSString stringWithFormat:@"delete from deviceList where deviceId=%lu;", deviceId];
    return [_fmdb executeUpdate:str];
    return YES;
}


-(BOOL) updateDeviceNameWithDeviceId:(NSInteger) deviceId deviceName:(NSString *) deviceName{
    NSString *str = [NSString stringWithFormat:@"update deviceList set deviceName='%@' where deviceId=%lu;", deviceName, deviceId];
    return [_fmdb executeUpdate:str];
}

-(BOOL)updateDevicePasswordWithDeviceId:(NSInteger) deviceId password:(NSString *) password{
    NSString *str = [NSString stringWithFormat:@"update deviceList set password='%@' where deviceId=%lu;", password, deviceId];
    return [_fmdb executeUpdate:str];
}


-(BOOL) updateDeviceInfoWithdevice:(BimarDevice *) model{
    NSString *str = [NSString stringWithFormat:@"update deviceList set workState=%d, workMode=%d,windState=%d, autoTime=%d, temperatureFlag=%d, CelsiusTemperature=%lu,Fahrenheit=%d, indoorCelsiusTemperature=%d, indoorFahrenheit=%d where deviceId=%d;", (int)model.workState , (int)model.workMode, (int)model.windState, (int)model.autoTime, (int)model.temperatureFlag, (unsigned long)model.CelsiusTemperature, (int)model.Fahrenheit, (int)model.indoorCelsiusTemperature, (int)model.indoorFahrenheit, (int)model.deviceId];
    return [_fmdb executeUpdate:str];
}

@end
