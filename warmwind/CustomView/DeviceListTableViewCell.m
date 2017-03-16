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
    UIImageView *ImvDeviceIcon;      // 设备图片
    UILabel *lbDeviceName;           // 设备名称
    UILabel *lbState;                // 开机状态
    UILabel *lbTemperature;          // 温度
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
    ImvDeviceIcon.frame = CGRectMake(POINT_X(54), (CGRectGetHeight(self.frame) - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    ImvDeviceIcon.layer.cornerRadius = leftImage.size.width / 2;
    ImvDeviceIcon.layer.masksToBounds = YES;
    
    lbDeviceName.text = model.deviceName;
    CGRect titleR = LABEL_RECT(lbDeviceName.text, 0, 0, 1, 17);
    lbDeviceName.frame = CGRectMake(CGRectGetMaxX(ImvDeviceIcon.frame) + POINT_X(39), POINT_Y(30), titleR.size.width, titleR.size.height);

    if (model.autoTime != BimarAutoOffTimeNone) {
        if (_model.endtime < [GPUtil nowTimeIntervalSince1970]){
            _model.workState = BimarWorkStateStandbyMode;
        }
    }
    switch (model.workState) {
        case BimarWorkStateOnMode:
        {
            switch (model.workMode) {
                case BimarWorkModeSmallFire:
                    lbState.text = CURRENT_LANGUAGE(@"小火");
                    break;
                case BimarWorkModeMiddleFire:
                    lbState.text = CURRENT_LANGUAGE(@"中火");
                    break;
                case BimarWorkModeHighFire:
                    lbState.text = CURRENT_LANGUAGE(@"大火");
                    break;
                case BimarWorkModePreventFrost:
                    lbState.text = CURRENT_LANGUAGE(@"防霜冻");
                    break;
                default:
                    lbState.text = CURRENT_LANGUAGE(@"在线");
                    break;
            }
            if (model.temperatureFlag) {
                lbTemperature.text = [NSString stringWithFormat:@"%ld℃",(long)model.Centigrade];
            }
            else{
                lbTemperature.text = [NSString stringWithFormat:@"%ld℉",(long)model.Fahrenheit];
            }
            lbState.textColor = UICOLOR_RGBA(0, 200, 83, 1.0);
            lbTemperature.textColor = UICOLOR_RGBA(0, 200, 83, 1.0);
            break;
        }
        case BimarWorkStateOffMode:
        {
            lbState.text = CURRENT_LANGUAGE(@"离线");
            lbState.textColor = UICOLOR_RGBA(255, 0, 0, 1.0);
            break;
        }
        case BimarWorkStateStandbyMode:
        {
            lbState.text = CURRENT_LANGUAGE(@"待机");
            if (model.temperatureFlag) {
                lbTemperature.text = [NSString stringWithFormat:@"%ld℃",(long)model.indoorCentigrade];
            }
            else{
                lbTemperature.text = [NSString stringWithFormat:@"%ld℉",(long)model.indoorFahrenheit];
            }
            lbState.textColor = UICOLOR_RGBA(66, 66, 66, 1.0);
            lbTemperature.textColor = UICOLOR_RGBA(66, 66, 66, 1.0);
            break;
        }
        default:
            break;
    }
    CGRect stateLabelR = LABEL_RECT(lbState.text, 0, 0, 1, 14);
    lbState.frame = CGRectMake(CGRectGetMinX(lbDeviceName.frame), CGRectGetMaxY(lbDeviceName.frame) + POINT_Y(33), stateLabelR.size.width, stateLabelR.size.height);
    NSString *tempFlag = nil;
    if (model.temperatureFlag) {
        tempFlag = @"℃";
    }
    else{
        tempFlag = @"℉";
    }
    CGRect temperatureLabelR = [GPUtil attributedLabel:lbTemperature String:tempFlag firstSize:14 lastSize:12];
    lbTemperature.frame = CGRectMake(CGRectGetMaxX(lbState.frame) + POINT_X(10), CGRectGetMinY(lbState.frame), temperatureLabelR.size.width, temperatureLabelR.size.height);
}

- (void) createSubViews{
    if (!ImvDeviceIcon) {
        ImvDeviceIcon = [[UIImageView alloc]init];
        ImvDeviceIcon.backgroundColor = THEME_COLOR;
        [self.contentView addSubview:ImvDeviceIcon];
    }
    if (!lbDeviceName) {
        lbDeviceName = [[UILabel alloc]init];
        lbDeviceName.font = [UIFont systemFontOfSize:17];
        lbDeviceName.textColor = UICOLOR_RGBA(48, 48, 48, 1.0);
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
        lbTemperature.textColor = UICOLOR_RGBA(66, 66, 66, 1.0);
        [self.contentView addSubview:lbTemperature];
    }
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"问号"];
        UIImage *tintedImage = [image rt_tintedImageWithColor:UICOLOR_RGBA(179, 179, 179, 1.0)];
        _moreButton.frame = CGRectMake(self.bounds.size.width - image.size.width - POINT_X(54), (CGRectGetHeight(self.frame) - image.size.height) / 2, image.size.width, image.size.height);
        [_moreButton setImage:tintedImage forState:UIControlStateNormal];
        _moreButton.layer.cornerRadius = image.size.width / 2;
        _moreButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_moreButton];
    }
    if (!lineView) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = UICOLOR_RGBA(209, 209, 209, 1.0);
        [self.contentView addSubview:lineView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
