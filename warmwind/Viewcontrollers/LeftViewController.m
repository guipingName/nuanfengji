//
//  LeftViewController.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "LeftViewController.h"
#import "SettingViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "LeftVCTableViewCell.h"
#import "AboutUsViewController.h"

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *dataArray;
    NSArray *imageNamesArray;
    UIImageView *imageView;
    UILabel *lbTitle;
}

@end

@implementation LeftViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GPUtil addBgImageViewWithImageName:@"左侧栏背景" SuperView:self.view];
    dataArray = [NSArray array];
    imageNamesArray = @[@"关于", @"设置"];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, GPPointY(644), GPWidth(759), GPHeight(342))];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight = GPHeight(171);
    [myTableView registerClass:[LeftVCTableViewCell class] forCellReuseIdentifier:LEFTCELL];
    [self createImageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:@"changeLanguage" object:nil];
    
    // 显示数据
    [self changeLanguage:nil];
}

- (void) changeLanguage:(NSNotification *) sender{
    lbTitle.text = [ChangeLanguage getContentWithKey:@"title"];
    CGRect labelR = HSGetLabelRect(lbTitle.text, 0, 0, 1, 15);
    lbTitle.frame = CGRectMake((GPPointX(759) - labelR.size.width) / 2, CGRectGetMaxY(imageView.frame) + GPPointY(30), labelR.size.width, labelR.size.height);
    dataArray = @[[ChangeLanguage getContentWithKey:@"leftvc0"], [ChangeLanguage getContentWithKey:@"leftvc1"]];
    [myTableView reloadData];
}

- (void) createImageView{
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"左侧边栏logo"]];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.frame = CGRectMake((GPPointX(759) - GPHeight(180)) / 2, GPPointY(192), GPHeight(180), GPHeight(180));
    imageView.layer.cornerRadius = GPHeight(90);
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 2;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    lbTitle = [[UILabel alloc] init];
    [self.view addSubview:lbTitle];
    lbTitle.textColor = [UIColor whiteColor];
    lbTitle.font = [UIFont systemFontOfSize:15];
    lbTitle.textAlignment = NSTextAlignmentCenter;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LEFTCELL forIndexPath:indexPath];
    cell.isSetting = YES;
    cell.imageName = imageNamesArray[indexPath.row];
    cell.title = dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
            UINavigationController *cen = (UINavigationController*)self.mm_drawerController.centerViewController;
            [cen pushViewController:aboutUsVC animated:YES];
        }];
    }
    else if (indexPath.row == 1){
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
            UINavigationController *cen = (UINavigationController*)self.mm_drawerController.centerViewController;
            [cen pushViewController:settingVC animated:YES];
        }];
    }
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
