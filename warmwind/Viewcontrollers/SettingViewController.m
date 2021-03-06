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

typedef NS_ENUM(NSInteger, SettingType) {
    SettingTypeSound,       // 声音
    SettingTypeVibrate,     // 振动
};


@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *dataArray;
    NSUserDefaults *userDefaults;
}

@end


@implementation SettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = CURRENT_LANGUAGE(@"设置");
    [GPUtil addBgImageViewWithImageName:@"bimar背景" SuperView:self.view];
    userDefaults = [NSUserDefaults standardUserDefaults];
    self.automaticallyAdjustsScrollViewInsets = NO;
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 64)];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:SETTINGCELL];
    [myTableView registerClass:[SetLanguageTableViewCell class] forCellReuseIdentifier:LANGUAGECELL];
    myTableView.rowHeight =  POINT_Y(231);
    
    dataArray = @[@"bimar声音", @"bimar震动"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------- UITableViewDelegate ----------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        SetLanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LANGUAGECELL forIndexPath:indexPath];
        if ([[userDefaults objectForKey:@"language"] isEqualToString:@"Italian"]) {
            cell.imageName = @"bimar意大利语";
        }
        else if ([[userDefaults objectForKey:@"language"] isEqualToString:@"en"]){
            cell.imageName = @"bimar英语";
        }
        else{
            cell.imageName = @"bimar汉语";
        }
        return cell;
    }
    else{
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SETTINGCELL forIndexPath:indexPath];
        cell.leftImageName = dataArray[indexPath.row];
        [cell.rightSwitch addTarget:self action:@selector(doSwitch:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == 0) {
            if ([userDefaults boolForKey:SOUND]) {
                cell.rightSwitch.on = YES;
            }
            else{
                cell.rightSwitch.on = NO;
            }
        }
        else if (indexPath.row == 1) {
            if ([userDefaults boolForKey:VIBRATE]) {
                cell.rightSwitch.on = YES;
            }
            else{
                cell.rightSwitch.on = NO;
            }
        }
        cell.rightSwitch.tag = SWITCH_TAG + indexPath.row;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[GPPickerView class]]) {
                return;
            }
        }
        GPPickerView *pickerView = [[GPPickerView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH, POINT_Y(969))];
        [self.view addSubview:pickerView];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = pickerView.frame;
            rect.origin.y -= POINT_Y(969);
            pickerView.frame = rect;
        }];
        pickerView.block = ^(NSString *newLanguage) {
            [userDefaults setObject:newLanguage forKey:LANGUAGE];
            [userDefaults synchronize];
            [myTableView reloadData];
            if ([newLanguage isEqualToString:@"Italian"]) {
                newLanguage = @"en";
            }
            if (![newLanguage isEqualToString:[ChangeLanguage userLanguage]]) {
                [ChangeLanguage setUserlanguage:newLanguage];
                self.title = CURRENT_LANGUAGE(@"设置");
                [[NSNotificationCenter defaultCenter] postNotificationName:LANGUAGE_NOTIFICATION object:nil];
            }
        };
    }
    else{
        return;
    }
}

#pragma mark --------------- UISwitch事件 ----------------
- (void) doSwitch:(UISwitch *) sender{
    switch (sender.tag - SWITCH_TAG) {
        case SettingTypeSound:
        {
            if (sender.isOn) {
                [userDefaults setBool:YES forKey:SOUND];
            }
            else{
                [userDefaults setBool:NO forKey:SOUND];
            }
            [userDefaults synchronize];
            break;
        }
        case SettingTypeVibrate:
        {
            if (sender.isOn) {
                [userDefaults setBool:YES forKey:VIBRATE];
            }
            else{
                [userDefaults setBool:NO forKey:VIBRATE];
            }
            [userDefaults synchronize];
            break;
        }
        default:
            break;
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
