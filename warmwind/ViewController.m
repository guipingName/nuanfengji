//
//  ViewController.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "ViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "SearchDeviceViewController.h"
#import "AddDeviceViewController.h"
#import "DeviceListTableViewCell.h"
#import "SearchResultViewController.h"
#import "DeviceOperateViewController.h"
#import "GPButton.h"

@interface ViewController ()<UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    UIImageView *imageView;
    UIView *hintView;
    BimarDevice *operateModel;
    UITableView *deviceListTableView;
    UIButton *searchButton;
}
@end

static NSString *DeviceCell = @"DeviceListTableViewCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"暖风机";
    dataArray = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"列表更多"] style:UIBarButtonItemStylePlain target:self action:@selector(onLeftClicked:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加"] style:UIBarButtonItemStylePlain target:self action:@selector(addDevice:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    // 图片
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH, myY(620))];
    imageView.image = [UIImage imageNamed:@"banner_default"];
    //imageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imageView];
    
    // 搜索界面
    [self createSearchView];
    // 设备列表界面
    [self showDeviceUI];
    
    // 数据
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertANewDevice:) name:@"newDevice" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) insertANewDevice:(NSNotification *) sender{
//    BimarDevice *model = sender.object;
//    [dataArray addObject:model];
//    if (dataArray.count > 0) {
//        //[self showDeviceUI];
//        searchButton.hidden = YES;
//        deviceListTableView.hidden = NO;
//        [deviceListTableView reloadData];
//    }
    [self loadData];
}

- (void) loadData{
    dataArray = [[[DataBaseManager sharedManager] getAllDevices] mutableCopy];
    if (dataArray.count == 0) {
        searchButton.hidden = NO;
    }
    else{
        deviceListTableView.hidden = NO;
        [deviceListTableView reloadData];
    }
}

- (void) createSearchView{
    searchButton = [GPButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:searchButton];
    searchButton.hidden = YES;
    searchButton.frame = CGRectMake(0, 0, 100, 100);
    searchButton.center = self.view.center;
    [searchButton setTitle:@"搜索设备" forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"搜索设备"] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    searchButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(updateDeviceButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void) updateDeviceButton:(UIButton *) sender{
    [self.navigationController pushViewController:[[SearchDeviceViewController alloc] init] animated:YES];
}

// 设备tableView
- (void) showDeviceUI{
    //searchButton.hidden = YES;
    //if (!deviceListTableView) {
        deviceListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.bounds), kScreenWIDTH, kScreenHEIGHT-imageView.bounds.size.height- 64)];
    //}
    [self.view addSubview:deviceListTableView];
    deviceListTableView.hidden = YES;
    [deviceListTableView registerClass:[DeviceListTableViewCell class] forCellReuseIdentifier:DeviceCell];
    deviceListTableView.dataSource = self;
    deviceListTableView.delegate = self;
    deviceListTableView.rowHeight = myY(231);
    deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) dotap:(UITapGestureRecognizer *) sender{
    [self.navigationController pushViewController:[[SearchDeviceViewController alloc] init] animated:YES];
}

- (void) onLeftClicked:(UIBarButtonItem *) sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceCell forIndexPath:indexPath];
    cell.model = dataArray[indexPath.row];
    [cell.moreButton addTarget:self action:@selector(updateDeviceInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreButton.tag = 2500 + indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceOperateViewController *deviceVC = [[DeviceOperateViewController alloc] init];
    deviceVC.model = dataArray[indexPath.row];
    deviceVC.userHandler = ^(BimarDevice *device){
        for (BimarDevice *tempModel in dataArray) {
            if (tempModel.deviceId == device.deviceId) {
                NSInteger aaa = [dataArray indexOfObject:tempModel];
                [dataArray replaceObjectAtIndex:aaa withObject:device];
                [[DataBaseManager sharedManager] updateDeviceInfoWithdevice:device];
                break;
            }
        }
        [deviceListTableView reloadData];
    };
    [self.navigationController pushViewController:deviceVC animated:YES];
}

// 更多按钮
- (void) updateDeviceInfo:(UIButton *) sender{
    BimarDevice *model = dataArray[sender.tag - 2500];
    [self hintView:model];
}

- (void) hintView:(BimarDevice *) model{
    operateModel = model;
    hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH, kScreenHEIGHT)];
    hintView.backgroundColor = GPColor(0, 0, 0, 0.5);
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview:hintView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView:)];
    [hintView addGestureRecognizer:tap];
    hintView.userInteractionEnabled = YES;
    
    UIView *opView = [[UIView alloc] initWithFrame:CGRectMake(0, hintView.bounds.size.height - myY(375), hintView.bounds.size.width, myY(375))];
    opView.backgroundColor = [UIColor whiteColor];
    [hintView addSubview:opView];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, opView.bounds.size.width, myY(114))];
    [opView addSubview:idLabel];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.text = [NSString stringWithFormat:@"%lu",model.deviceId];
    idLabel.textColor = GPColor(128, 128, 128, 1.0);
    idLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, myY(114), opView.bounds.size.width, myY(2))];
    lineView.backgroundColor = GPColor(209, 209, 209, 1.0);
    [opView addSubview:lineView];
    
    NSArray *names = @[@"修改昵称", @"修改密码", @"删除"];
    for (int i=0; i<3; i++) {
        UIButton *button = [GPButton buttonWithType:UIButtonTypeCustom];
        [opView addSubview:button];
        button.frame = CGRectMake(myY(270)*i + myX(90), myY(150), myY(260), myY(147));
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:names[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 478 + i;
        [button addTarget:self action:@selector(updateDeviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) cancelView:(UITapGestureRecognizer *) sender{
    [hintView removeFromSuperview];
}

- (void) updateDeviceButtonClicked:(UIButton *) sender{
    [hintView removeFromSuperview];
    switch (sender.tag - 478) {
        case 0:
        {// 修改用户名
            SearchResultViewController *serVC = [[SearchResultViewController alloc] init];
            serVC.model = operateModel;
            serVC.isModifyName = YES;
            [self.navigationController pushViewController:serVC animated:YES];
            break;
        }
        case 1:
        {// 修改密码
            SearchResultViewController *serVC = [[SearchResultViewController alloc] init];
            serVC.model = operateModel;
            serVC.isModifyPassword = YES;
            [self.navigationController pushViewController:serVC animated:YES];
            break;
        }
        case 2:
        {// 删除设备
            BOOL state = [[DataBaseManager sharedManager] deleteDeviceWithDeviceId:operateModel.deviceId];
            if (state) {
                [dataArray removeObject:operateModel];
                [deviceListTableView reloadData];
                if (dataArray.count == 0) {
                    deviceListTableView.hidden = YES;
                    searchButton.hidden = NO;
                }
            }
            else{
                [GPUtil hintView:self.view message:@"删除失败"];
            }
            break;
        }
        default:
            break;
    }
}

- (void) addDevice:(UIBarButtonItem *) sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"新设备", @"已配置过的设备", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController pushViewController:[[SearchDeviceViewController alloc] init] animated:YES];
    }
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[[AddDeviceViewController alloc] init] animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
