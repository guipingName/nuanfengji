//
//  DeviceListTableViewCell.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "DeviceListTableViewCell.h"
#import "UIImage+RTTint.h"

@implementation DeviceListTableViewCell{
    UIImageView *ImvDeviceIcon;   // 设备图片
    UILabel *lbDeviceName;           // 设备名称
    UILabel *lbState;                // 开机状态
    UILabel *lbTemperature;          // 温度
    UILabel *lbTemperatureType;      // 温度单位
    UIView *lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(BimarDevice *)model{
    _model = model;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createSubViews];
    UIImage *leftImage = [UIImage imageNamed:@"设备信息"];
    ImvDeviceIcon.image = leftImage;
    ImvDeviceIcon.frame = CGRectMake(GPPointX(54), (CGRectGetHeight(self.frame) - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    ImvDeviceIcon.layer.cornerRadius = leftImage.size.width / 2;
    ImvDeviceIcon.layer.masksToBounds = YES;
    
    lbDeviceName.text = model.deviceName;
    CGRect titleR = HSGetLabelRect(lbDeviceName.text, 0, 0, 1, 17);
    lbDeviceName.frame = CGRectMake(CGRectGetMaxX(ImvDeviceIcon.frame) + GPPointX(39), GPPointY(30), titleR.size.width, titleR.size.height);

    if (model.autoTime != BimarAutoOffTimeNone) {
        if (_model.endtime < [GPUtil nowTimeIntervalSince1970]){
            _model.workState = BimarWorkStateStandbyMode;
        }
    }
    switch (model.workState) {
        case BimarWorkStateOnMode:
        {
            lbState.text = [ChangeLanguage getContentWithKey:@"deviceState1"];
            if (model.temperatureFlag) {
                lbTemperature.text = [NSString stringWithFormat:@"%ld",(long)model.Centigrade];
                lbTemperatureType.text = @"℃";
            }
            else{
                lbTemperature.text = [NSString stringWithFormat:@"%ld",(long)model.Fahrenheit];
                lbTemperatureType.text = @"℉";
            }
            lbState.textColor = GPColor(0, 200, 83, 1.0);
            lbTemperature.textColor = GPColor(0, 200, 83, 1.0);
            lbTemperatureType.textColor = GPColor(0, 200, 83, 1.0);
            break;
        }
        case BimarWorkStateOffMode:
        {
            lbState.text = [ChangeLanguage getContentWithKey:@"deviceState0"];
            lbState.textColor = GPColor(255, 0, 0, 1.0);
            break;
        }
        case BimarWorkStateStandbyMode:
        {
            lbState.text = [ChangeLanguage getContentWithKey:@"deviceState2"];
            if (model.temperatureFlag) {
                lbTemperature.text = [NSString stringWithFormat:@"%ld",(long)model.indoorCentigrade];
                lbTemperatureType.text = @"℃";
            }
            else{
                lbTemperature.text = [NSString stringWithFormat:@"%ld",(long)model.indoorFahrenheit];
                lbTemperatureType.text = @"℉";
            }
            lbState.textColor = GPColor(66, 66, 66, 1.0);
            lbTemperature.textColor = GPColor(66, 66, 66, 1.0);
            lbTemperatureType.textColor = GPColor(66, 66, 66, 1.0);
            break;
        }
        default:
            break;
    }
    CGRect stateLabelR = HSGetLabelRect(lbState.text, 0, 0, 1, 14);
    lbState.frame = CGRectMake(CGRectGetMinX(lbDeviceName.frame), CGRectGetMaxY(lbDeviceName.frame) + GPPointY(33), stateLabelR.size.width, stateLabelR.size.height);
    
    CGRect temperatureLabelR = HSGetLabelRect(lbTemperature.text, 0, 0, 1, 14);
    lbTemperature.frame = CGRectMake(CGRectGetMaxX(lbState.frame) + GPPointX(10), CGRectGetMinY(lbState.frame), temperatureLabelR.size.width, temperatureLabelR.size.height);
    
    CGRect temperatureTypeLabelR = HSGetLabelRect(lbTemperatureType.text, 0, 0, 1, 12);
    lbTemperatureType.frame = CGRectMake(CGRectGetMaxX(lbTemperature.frame), CGRectGetMaxY(lbTemperature.frame) - temperatureTypeLabelR.size.height, temperatureTypeLabelR.size.width, temperatureTypeLabelR.size.height);
}

- (void) createSubViews{
    if (!ImvDeviceIcon) {
        ImvDeviceIcon = [[UIImageView alloc]init];
        ImvDeviceIcon.backgroundColor = GPColor(250, 126, 20, 1.0);
        [self.contentView addSubview:ImvDeviceIcon];
    }
    if (!lbDeviceName) {
        lbDeviceName = [[UILabel alloc]init];
        lbDeviceName.font = [UIFont systemFontOfSize:17];
        lbDeviceName.textColor = GPColor(48, 48, 48, 1.0);
        [self.contentView addSubview:lbDeviceName];
    }
    if (!lbState) {
        lbState = [[UILabel alloc]init];
        lbState.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:lbState];
    }
    if (!lbTemperature) {
        lbTemperature = [[UILabel alloc]init];
        lbTemperature.font = [UIFont systemFontOfSize:14];
        lbTemperature.textColor = GPColor(66, 66, 66, 1.0);
        [self.contentView addSubview:lbTemperature];
    }
    if (!lbTemperatureType) {
        lbTemperatureType = [[UILabel alloc]init];
        lbTemperatureType.font = [UIFont systemFontOfSize:12];
        lbTemperatureType.textColor = GPColor(66, 66, 66, 1.0);
        [self.contentView addSubview:lbTemperatureType];
    }
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"问号"];
        UIImage *tintedImage = [image rt_tintedImageWithColor:GPColor(179, 179, 179, 1.0)];
        _moreButton.frame = CGRectMake(self.bounds.size.width - image.size.width - GPPointX(54), (CGRectGetHeight(self.frame) - image.size.height) / 2, image.size.width, image.size.height);
        [_moreButton setImage:tintedImage forState:UIControlStateNormal];
        _moreButton.layer.cornerRadius = image.size.width / 2;
        _moreButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_moreButton];
    }
    if (!lineView) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = GPColor(209, 209, 209, 1.0);
        [self.contentView addSubview:lineView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
