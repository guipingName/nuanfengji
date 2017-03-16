//
//  DeviceInfoViewController.m
//  warmwind
//
//  Created by guiping on 17/3/10.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "DeviceInfoTableViewCell.h"

@interface DeviceInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *titleArray;
    NSArray *titleInfoArray;
}


@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = CURRENT_LANGUAGE(@"设备信息");
    //[GPUtil addBgImageViewWithImageName:@"bimar背景" SuperView:self.view];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:myTableView];
    myTableView.rowHeight = POINT_Y(231);
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[DeviceInfoTableViewCell class] forCellReuseIdentifier:DEVICEINFOCELL];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------- 加载数据 ----------------
- (void) loadData{
    if (!titleArray) {
        titleArray = [NSMutableArray array];
    }
    NSArray *systemInfo = @[CURRENT_LANGUAGE(@"序列号"), CURRENT_LANGUAGE(@"固件版本"), CURRENT_LANGUAGE(@"硬件版本"), CURRENT_LANGUAGE(@"升级包版本")];
    NSArray *systemInfo1 = @[[GPUtil splitString:[NSString stringWithFormat:@"%lu",_model.deviceId] splitNum:4], @"4.0.0(svn 209)", @"1.0.0", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    NSArray *WiFi = @[CURRENT_LANGUAGE(@"无线名称")];
    NSArray *WiFi1 = @[[GPUtil SSID]];
    NSArray *high = @[CURRENT_LANGUAGE(@"当前网关信道"), CURRENT_LANGUAGE(@"已连接手机数量")];
    NSArray *high1 = @[@"5", @"2"];
    titleArray = @[systemInfo, WiFi, high];
    titleInfoArray = @[systemInfo1, WiFi1, high1];
}


#pragma mark --------------- UITableViewDelegate ----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = titleArray[section];
    return array.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titles= @[CURRENT_LANGUAGE(@" 系统信息"), CURRENT_LANGUAGE(@" Wi-Fi信息"), CURRENT_LANGUAGE(@" 高级信息")];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = UICOLOR_RGBA(230, 231, 232, 1.0);
    label.text = titles[section];
    label.font = [UIFont systemFontOfSize:20];
    return label;
    
//    static NSString *headerSectionID = @"headerSectionID";
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
//    UILabel *label;
//    if (headerView == nil) {
//        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, myTableView.frame.size.width, GPPointY(150))];
//        label.font = [UIFont systemFontOfSize:20];
//        label.backgroundColor = [UIColor grayColor];
//        [headerView addSubview:label];
//    }
//    label.text = titles[section];
//    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UIHEIGHT(150);
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return UIHEIGHT(150);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DEVICEINFOCELL forIndexPath:indexPath];
    cell.title = titleArray[indexPath.section][indexPath.row];
    cell.titleInfo = titleInfoArray[indexPath.section][indexPath.row];
    return cell;
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
