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

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *dataArray;
}

@end

static NSString *leftCell = @"LeftVCTableViewCell";

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, myY(644), myX(759), myY(342))];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight = myY(171);
    [myTableView registerClass:[LeftVCTableViewCell class] forCellReuseIdentifier:leftCell];
    [self createImageView];
    
    dataArray = @[@"关于我们", @"设置"];
}


- (void) createImageView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"左侧边栏logo"]];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.frame = CGRectMake((myX(759) - myY(180))/2, myY(192), myY(180), myY(180));
    imageView.layer.cornerRadius = myY(180) / 2;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 2;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暖风机";
    [self.view addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    CGRect labelR = HSGetLabelRect(label.text, 0, 0, 1, 15);
    label.frame = CGRectMake((myX(759) - labelR.size.width)/2, CGRectGetMaxY(imageView.frame) + myY(30), labelR.size.width, labelR.size.height);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCell forIndexPath:indexPath];
    cell.imageName = @"bimar关于";
    cell.title = dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        //NSLog(@"跳转到设置界面");
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
            UINavigationController *cen = (UINavigationController*)self.mm_drawerController.centerViewController;
            [cen pushViewController:settingVC animated:YES];
        }];
    }
    else{
        [GPUtil hintView:self.view message:@"该功能无法使用"];
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
