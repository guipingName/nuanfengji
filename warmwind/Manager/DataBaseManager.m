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
    
    if ([_fmdb open]) {
        //[_fmdb executeUpdate:@"create Table if not exists deviceList (deviceId int primary key,deviceName,password,workState int default 2,workMode int default 0,windState blob default 0,autoTime int default 0,temperatureFlag blob default 1,Centigrade int default 25,Fahrenheit int default 77,indoorCentigrade int default 21,indoorFahrenheit int default 70);"];
        [_fmdb executeUpdate:@"create Table if not exists deviceList (deviceId long long primary key,deviceName,password,workState int default 2,workMode int default 0,windState blob default 0,autoTime int default 0,endtime int default 0,temperatureFlag blob default 1,Centigrade int default 25,Fahrenheit int default 77,indoorCentigrade int default 21,indoorFahrenheit int default 70);"];
    }
}

-(BOOL)addDeviceWithDeviceId:(NSInteger)deviceId deviceName:(NSString *)deviceName password:(NSString *)password{
    return [_fmdb executeUpdate:@"insert into deviceList (deviceId, deviceName, password) values (?,?,?);", @(deviceId), deviceName, password];
}
//-(BOOL)addDeviceWithDeviceId:(long long)deviceId deviceName:(NSString *)deviceName password:(NSString *)password{
//    return [_fmdb executeUpdate:@"insert into deviceList (deviceId, deviceName, password) values (?,?,?);", @(deviceId), deviceName, password];
//}


-(NSArray *)loadDeviceInformation{
    FMResultSet *rs = [_fmdb executeQuery:@"select *from deviceList"];
    NSMutableArray *devices = [NSMutableArray array];
    while ([rs next]) {
        BimarDevice *model = [[BimarDevice alloc] init];
        //model.deviceId = [rs intForColumn:@"deviceId"];
        model.deviceId = [rs longLongIntForColumn:@"deviceId"];
        model.deviceName = [rs stringForColumn:@"deviceName"];
        model.password = [rs stringForColumn:@"password"];
        model.workState = [rs intForColumn:@"workState"];
        model.workMode = [rs intForColumn:@"workMode"];
        model.windState = [rs boolForColumn:@"windState"];
        model.autoTime = [rs intForColumn:@"autoTime"];
        model.endtime = [rs intForColumn:@"endtime"];
        model.temperatureFlag = [rs boolForColumn:@"temperatureFlag"];
        model.Centigrade = [rs intForColumn:@"Centigrade"];
        model.Fahrenheit = [rs intForColumn:@"Fahrenheit"];
        model.indoorCentigrade = [rs intForColumn:@"indoorCentigrade"];
        model.indoorFahrenheit = [rs intForColumn:@"indoorFahrenheit"];
        [devices addObject:model];
    }
    return [devices copy];
}


-(BOOL)deleteDeviceWithDeviceId:(NSInteger)deviceId{
    NSString *str= [NSString stringWithFormat:@"delete from deviceList where deviceId=%lld;", (long long)deviceId];
    return [_fmdb executeUpdate:str];
    return YES;
}


-(BOOL) updateDeviceNameWithDeviceId:(NSInteger) deviceId deviceName:(NSString *) deviceName{
    NSString *str = [NSString stringWithFormat:@"update deviceList set deviceName='%@' where deviceId=%lld;", deviceName, (long long)deviceId];
    return [_fmdb executeUpdate:str];
}

-(BOOL)updateDevicePasswordWithDeviceId:(NSInteger) deviceId password:(NSString *) password{
    NSString *str = [NSString stringWithFormat:@"update deviceList set password='%@' where deviceId=%lld;", password, (long long)deviceId];
    return [_fmdb executeUpdate:str];
}


-(BOOL) updateDeviceInfoWithdevice:(BimarDevice *) model{
    NSString *str = [NSString stringWithFormat:@"update deviceList set workState=%d, workMode=%d,windState=%d, autoTime=%d, endtime=%d,temperatureFlag=%d, Centigrade=%lu,Fahrenheit=%lu, indoorCentigrade=%d, indoorFahrenheit=%d where deviceId=%lld;", (int)model.workState , (int)model.workMode, (int)model.windState, (int)model.autoTime, (int)model.endtime, (int)model.temperatureFlag, model.Centigrade, model.Fahrenheit, (int)model.indoorCentigrade, (int)model.indoorFahrenheit, (long long)model.deviceId];
    return [_fmdb executeUpdate:str];
}

@end
