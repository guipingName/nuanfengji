//
//  MoreViewController.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "MoreViewController.h"
#import "SettingTableViewCell.h"
#import "LeftVCTableViewCell.h"
#import "DeviceInfoViewController.h"


@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *imageNamesArray;
    NSArray *titleArray;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = [ChangeLanguage getContentWithKey:@"more0"];
    [GPUtil addBgImageViewWithImageName:@"bimar背景" SuperView:self.view];
    self.automaticallyAdjustsScrollViewInsets = NO;
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 64)];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:SETTINGCELL];
    [myTableView registerClass:[LeftVCTableViewCell class] forCellReuseIdentifier:LEFTCELL];
    myTableView.rowHeight = POINT_Y(231);
    imageNamesArray = @[@"设备信息", @"远程重启", @"bimar摄氏度"];
    titleArray = @[[ChangeLanguage getContentWithKey:@"more1"], [ChangeLanguage getContentWithKey:@"more2"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------- UITableViewDelegate ----------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return imageNamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == imageNamesArray.count - 1) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SETTINGCELL forIndexPath:indexPath];
        if (_model.temperatureFlag) {
            cell.leftImageName= @"bimar摄氏度";
            cell.rightSwitch.on = NO;
        }
        else{
            cell.leftImageName= @"bimar华氏度";
            cell.rightSwitch.on = YES;
        }
        [cell.rightSwitch addTarget:self action:@selector(changeTemperatureType:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    else{
        LeftVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LEFTCELL forIndexPath:indexPath];
        cell.isMore = YES;
        cell.imageName = imageNamesArray[indexPath.row];
        cell.title = titleArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DeviceInfoViewController *deviceInfoVC = [[DeviceInfoViewController alloc] init];
        deviceInfoVC.model = _model;
        [self.navigationController pushViewController:deviceInfoVC animated:YES];
    }
    else if (indexPath.row == 1) {
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"more3"]];
    }
    else{
        
    }
}


#pragma mark --------------- UISwitch事件 ----------------
- (void) changeTemperatureType:(UISwitch *) sender{
    BOOL temperatureFlag;
    if (sender.isOn) {
        temperatureFlag = NO;
        _model.temperatureFlag = NO;
    }
    else{
        temperatureFlag = YES;
        _model.temperatureFlag = YES;
    }
//    BOOL state = [[DataBaseManager sharedManager] updateDeviceInfoWithdevice:_model];
    BOOL state = [_model updateDeviceInfo];
    if (state) {
        [myTableView reloadData];
        NSNotification *note = [[NSNotification alloc] initWithName:@"temperatureFlag" object:@(temperatureFlag) userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
