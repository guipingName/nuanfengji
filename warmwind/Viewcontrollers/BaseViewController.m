//
//  BaseViewController.m
//  warmwind
//
//  Created by guiping on 17/2/21.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bimar背景"]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = GPColor(250, 126, 20, 1.0);
    
    [self addNavigationItemImageName:@"返回" target:self action:@selector(back:) isLeft:YES];
}

-(void)addNavigationItemImageName:(NSString *) imageName target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isLeft) {
        btn.frame = CGRectMake(-13, 0.0, 43, 43);
    }
    else{
        btn.frame = CGRectMake(13, 0.0, 43, 43);
    }
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
    [view addSubview:btn];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
    else{
        self.navigationItem.rightBarButtonItem = item;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
}


- (void) back:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:YES];
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
