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

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *dataArray;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"更多";
    [GPUtil backgroundImageView:self.view];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH, kScreenHEIGHT - 64)];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"SettingTableViewCell"];
    [myTableView registerClass:[LeftVCTableViewCell class] forCellReuseIdentifier:@"LeftVCTableViewCell"];
    myTableView.rowHeight = myY(231);
    dataArray = @[@"设备信息", @"远程重启", @"bimar摄氏度"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == dataArray.count - 1) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
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
        LeftVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftVCTableViewCell" forIndexPath:indexPath];
        cell.imageName = dataArray[indexPath.row];
        cell.title = dataArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < dataArray.count -1) {
        [GPUtil hintView:self.view message:@"该功能无法使用"];
    }
    else{
        
    }
}

- (void) changeTemperatureType:(UISwitch *) sender{
    BOOL temperatureFlag;
    if (sender.isOn) {
        //NSLog(@"华氏温度");
        temperatureFlag = NO;
        //_model.temperatureFlag = NO;
    }
    else{
        //NSLog(@"摄氏温度");
        temperatureFlag = YES;
        //_model.temperatureFlag = YES;
    }
    [myTableView reloadData];
    NSNotification *note = [[NSNotification alloc] initWithName:@"temperatureFlag" object:@(temperatureFlag) userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
