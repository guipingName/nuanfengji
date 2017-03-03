//
//  GPUtil.m
//  warmwind
//
//  Created by guiping on 17/3/1.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "GPUtil.h"

@implementation GPUtil

+(void)hintView:(UIView *)superView message:(NSString *) message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:superView animated:YES];
    });
}

+(void) backgroundImageView:(UIView *) superView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:superView.frame];
    imageView.image = [UIImage imageNamed:@"bimar背景"];
    [superView addSubview:imageView];
}

@end
