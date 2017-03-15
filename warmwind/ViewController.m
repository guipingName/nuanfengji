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
#import "ModifyPasswordViewController.h"
#import "DeviceOperateViewController.h"
#import "GPButton.h"
#import "SearchView.h"

typedef NS_ENUM(NSInteger, DeviceInfoButon) {
    DeviceInfoButonRename,
    DeviceInfoButonPawssword,
    DeviceInfoButonDelete,
    DeviceInfoButonMAX
};

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    UIImageView *Imv;
    UIView *hintView;
    BimarDevice *operateModel;
    UITableView *tbviewDeviceList;
    SearchView *searchView;
}
@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dataArray = [NSMutableArray array];
    
    [self addNavigationItemImageName:@"列表更多" target:self action:@selector(onLeftClicked:) isLeft:YES];
    [self addNavigationItemImageName:@"添加" target:self action:@selector(addDevice:) isLeft:NO];
    
    // 图片
    Imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, GPHEIGHT(620))];
    Imv.image = [UIImage imageNamed:@"banner_default"];
    [self.view addSubview:Imv];
    
    // 搜索界面
    [self createSearchView];
    // 设备列表界面
    [self createDeviceListView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:LANGUAGE_NOTIFICATION object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --------------- 数据更新 ----------------
- (void) loadData{
    dataArray = [[[DataBaseManager sharedManager] loadDeviceInformation] mutableCopy];
    if (dataArray.count == 0) {
        searchView.hidden = NO;
    }
    else{
        tbviewDeviceList.hidden = NO;
        [tbviewDeviceList reloadData];
    }
    [self changeLanguage];
}

#pragma mark --------------- 界面更新 ----------------
- (void) changeLanguage{
    self.title = [ChangeLanguage getContentWithKey:@"title"];
    searchView.title = [ChangeLanguage getContentWithKey:@"search0"];
    [tbviewDeviceList reloadData];
}

#pragma mark --------------- UITableViewDelegate ----------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DEVICELISTCELL forIndexPath:indexPath];
    cell.model = dataArray[indexPath.row];
    [cell.moreButton addTarget:self action:@selector(updateDeviceInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreButton.tag = BTN_DEVICE_MORE_TAG + indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceOperateViewController *deviceVC = [[DeviceOperateViewController alloc] init];
    deviceVC.model = dataArray[indexPath.row];
    [self.navigationController pushViewController:deviceVC animated:YES];
}


#pragma mark --------------- 设备更多按钮 ----------------
- (void) updateDeviceInfo:(UIButton *) sender{
    BimarDevice *model = dataArray[sender.tag - BTN_DEVICE_MORE_TAG];
    [self hintView:model];
}

- (void) cancelView:(UITapGestureRecognizer *) sender{
    [hintView removeFromSuperview];
}

- (void) updateDeviceButtonClicked:(UIButton *) sender{
    [hintView removeFromSuperview];
    switch (sender.tag - BTN_RENAME_TAG) {
        case DeviceInfoButonRename:
        {
            SearchResultViewController *serVC = [[SearchResultViewController alloc] init];
            serVC.model = operateModel;
            serVC.isModifyName = YES;
            [self.navigationController pushViewController:serVC animated:YES];
            break;
        }
        case DeviceInfoButonPawssword:
        {
            ModifyPasswordViewController *serVC = [[ModifyPasswordViewController alloc] init];
            serVC.model = operateModel;
            [self.navigationController pushViewController:serVC animated:YES];
            break;
        }
        case DeviceInfoButonDelete:
        {
            BOOL state = [[DataBaseManager sharedManager] deleteDeviceWithDeviceId:operateModel.deviceId];
            if (state) {
                [dataArray removeObject:operateModel];
                [tbviewDeviceList reloadData];
                if (dataArray.count == 0) {
                    tbviewDeviceList.hidden = YES;
                    //btnSearch.hidden = NO;
                    searchView.hidden = NO;
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


#pragma mark --------------- 创建View ----------------
- (void) createSearchView{
    searchView = [[SearchView alloc]init];
    searchView.frame = CGRectMake(0, CGRectGetMaxY(Imv.frame), KSCREEN_WIDTH, KSCREEN_HEIGHT - Imv.bounds.size.height - 64);
    searchView.hidden = YES;
    [self.view addSubview:searchView];
    [searchView createHintViewWithBlock:^{
        [self.navigationController pushViewController:[[SearchDeviceViewController alloc] init] animated:YES];
    }];
}

- (void) createDeviceListView{
    tbviewDeviceList = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(Imv.frame), KSCREEN_WIDTH, KSCREEN_HEIGHT - Imv.bounds.size.height - 64)];
    [self.view addSubview:tbviewDeviceList];
    tbviewDeviceList.hidden = YES;
    [tbviewDeviceList registerClass:[DeviceListTableViewCell class] forCellReuseIdentifier:DEVICELISTCELL];
    tbviewDeviceList.dataSource = self;
    tbviewDeviceList.delegate = self;
    tbviewDeviceList.rowHeight = GPHEIGHT(231);
    tbviewDeviceList.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) hintView:(BimarDevice *) model{
    operateModel = model;
    hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    hintView.backgroundColor = UICOLOR_RGBA(0, 0, 0, 0.5);
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview:hintView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView:)];
    [hintView addGestureRecognizer:tap];
    hintView.userInteractionEnabled = YES;
    
    UIView *opView = [[UIView alloc] initWithFrame:CGRectMake(0, hintView.bounds.size.height - GPHEIGHT(375), hintView.bounds.size.width, GPHEIGHT(375))];
    opView.backgroundColor = [UIColor whiteColor];
    [hintView addSubview:opView];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, opView.bounds.size.width, GPHEIGHT(114))];
    [opView addSubview:idLabel];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.text = [GPUtil splitString:[NSString stringWithFormat:@"%lu",model.deviceId] splitNum:4];
    idLabel.textColor = UICOLOR_RGBA(128, 128, 128, 1.0);
    idLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, POINT_Y(114), opView.bounds.size.width, GPHEIGHT(2))];
    lineView.backgroundColor = UICOLOR_RGBA(209, 209, 209, 1.0);
    [opView addSubview:lineView];
    NSArray *buttonImgNames = @[@"修改昵称", @"修改密码", @"删除"];
    NSArray *names = @[[ChangeLanguage getContentWithKey:@"button0"], [ChangeLanguage getContentWithKey:@"button1"], [ChangeLanguage getContentWithKey:@"button2"]];
    for (int i=0; i<DeviceInfoButonMAX; i++) {
        UIButton *button = [GPButton buttonWithType:UIButtonTypeCustom];
        [opView addSubview:button];
        button.frame = CGRectMake(POINT_X(70) + GPWIDTH(270) * i, POINT_Y(150), GPWIDTH(250), GPHEIGHT(150));
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:buttonImgNames[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = BTN_RENAME_TAG + i;
        [button addTarget:self action:@selector(updateDeviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark --------------- NavigationItem事件 ----------------
- (void) onLeftClicked:(UIBarButtonItem *) sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) addDevice:(UIBarButtonItem *) sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *new = [UIAlertAction actionWithTitle:[ChangeLanguage getContentWithKey:@"button3"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[[SearchDeviceViewController alloc] init] animated:YES];
    }];
    UIAlertAction *old = [UIAlertAction actionWithTitle:[ChangeLanguage getContentWithKey:@"button4"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[[AddDeviceViewController alloc] init] animated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[ChangeLanguage getContentWithKey:@"button5"] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:new];
    [alertController addAction:old];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
