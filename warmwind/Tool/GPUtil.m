//
//  GPUtil.m
//  warmwind
//
//  Created by guiping on 17/3/1.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "GPUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation GPUtil

+(void)hintView:(UIView *)superView message:(NSString *) message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:superView animated:YES];
    });
}

+(void)addBgImageViewWithImageName:(NSString *)imageName SuperView:(UIView *)superView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:superView.frame];
    imageView.image = [UIImage imageNamed:imageName];
    [superView addSubview:imageView];
}

+ (NSString *) splitString:(NSString *) str splitNum:(NSInteger) splitNum{
    int arrayNum = 0;
    NSString *tempStr = @"";
    int yuShu = (int)str.length % splitNum;
    if (yuShu == 0) {
        arrayNum = (int)str.length / splitNum;
    }
    else{
        arrayNum = (int)str.length / splitNum + 1;
    }
    for (int i = 0; i < arrayNum - 1; i++) {
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr,[str substringToIndex:splitNum]];
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr, @" "];
        str = [str substringFromIndex:splitNum];
    }
    return [NSString stringWithFormat:@"%@%@",tempStr,str];
}


+ (NSInteger) nowTimeIntervalSince1970{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return [timeSp integerValue];
}


// 获取SSID
+ (NSString *) SSID{
    id info = nil;
    NSString *str;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        str = info[@"SSID"];
    }
    if (str) {
        return str;
    }
    else{
        return [ChangeLanguage getContentWithKey:@"search14"];
    }
}
@end
