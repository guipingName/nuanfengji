//
//  SearchResultViewController.h
//  warmwind
//
//  Created by guiping on 17/2/22.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultViewController : BaseViewController

@property (nonatomic, strong) BimarDevice *model;

@property (nonatomic, assign) BOOL isAddDevice;
@property (nonatomic, assign) BOOL isModifyName;
@property (nonatomic, assign) BOOL isModifyPassword;


@end
