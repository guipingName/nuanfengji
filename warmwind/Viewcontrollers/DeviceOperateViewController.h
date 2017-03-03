//
//  DeviceOperateViewController.h
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "BaseViewController.h"

@interface DeviceOperateViewController : BaseViewController

@property (nonatomic, strong) BimarDevice *model;

@property (nonatomic, copy) void(^userHandler)(BimarDevice *);

@end
