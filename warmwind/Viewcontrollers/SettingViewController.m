//
//  SettingViewController.m
//  warmwind
//
//  Created by guiping on 17/2/22.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "SetLanguageTableViewCell.h"
#import "GPPickerView.h"

typedef enum {
    sounds,
    shake,
    language,
}type;

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *dataArray;
    NSUserDefaults *userDefaults;
}

@end

@implementation SettingViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"设置";
    [GPUtil backgroundImageView:self.view];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH, kScreenHEIGHT - 64)];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"SettingTableViewCell"];
    [myTableView registerClass:[SetLanguageTableViewCell class] forCellReuseIdentifier:@"SetLanguageTableViewCell"];
    myTableView.rowHeight =  myY(231);
    
    dataArray = @[@"bimar声音", @"bimar震动"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        SetLanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetLanguageTableViewCell" forIndexPath:indexPath];
        if (![userDefaults objectForKey:@"language"]) {
            cell.language = @"简体中文";
        }
        else{
            cell.language = [userDefaults objectForKey:@"language"];
        }
        return cell;
    }
    else{
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
        cell.leftImageName = dataArray[indexPath.row];
        [cell.rightSwitch addTarget:self action:@selector(doSwitch:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == 0) {
            if ([userDefaults boolForKey:@"soundState"]) {
                cell.rightSwitch.on = YES;
            }
            else{
                cell.rightSwitch.on = NO;
            }
        }
        else if (indexPath.row == 1) {
            if ([userDefaults boolForKey:@"shakeState"]) {
                cell.rightSwitch.on = YES;
            }
            else{
                cell.rightSwitch.on = NO;
            }
        }
        cell.rightSwitch.tag = 245 + indexPath.row;
        return cell;
    }
}

- (void) doSwitch:(UISwitch *) sender{
    switch (sender.tag - 245) {
        case 0:
        {
            if (sender.isOn) {
                [userDefaults setBool:YES forKey:@"soundState"];
                [GPUtil hintView:self.view message:@"请适当调节音量"];
            }
            else{
                [userDefaults setBool:NO forKey:@"soundState"];
            }
            [userDefaults synchronize];
            break;
        }
        case 1:
        {
            if (sender.isOn) {
                [userDefaults setBool:YES forKey:@"shakeState"];
                [GPUtil hintView:self.view message:@"请在设置中打开震动开关"];
            }
            else{
                [userDefaults setBool:NO forKey:@"shakeState"];
            }
            [userDefaults synchronize];
            break;
        }            
        default:
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == language) {
        GPPickerView *pickerView = [[GPPickerView alloc] initWithFrame:CGRectMake(0, kScreenHEIGHT - 64, kScreenWIDTH, myY(969))];
        [self.view addSubview:pickerView];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = pickerView.frame;
            rect.origin.y -= myY(969);
            pickerView.frame = rect;
        }];
        pickerView.block = ^(NSString *abc) {
            [userDefaults setObject:abc forKey:@"language"];
            [userDefaults synchronize];
            [myTableView reloadData];
            // todo:实现语言转换
        };
        
    }
    else{
        return;
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
