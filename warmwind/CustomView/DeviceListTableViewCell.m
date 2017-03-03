//
//  DeviceListTableViewCell.m
//  warmwind
//
//  Created by guiping on 17/2/24.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "DeviceListTableViewCell.h"

@implementation DeviceListTableViewCell{
    UIImageView *deviceIconImageView;   // 设备图片
    UILabel *deviceNameLabel;           // 设备名称
    UILabel *stateLabel;                // 开机状态
    UILabel *temperatureLabel;          // 温度
    UILabel *temperatureTypeLabel;      // 温度单位
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
    deviceIconImageView.image = leftImage;
    deviceIconImageView.frame = CGRectMake(myX(54), (CGRectGetHeight(self.frame) - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    deviceIconImageView.layer.cornerRadius = leftImage.size.width / 2;
    deviceIconImageView.layer.masksToBounds = YES;
    
    deviceNameLabel.text = model.deviceName;
    CGRect titleR = HSGetLabelRect(deviceNameLabel.text, 0, 0, 1, 17);
    deviceNameLabel.frame = CGRectMake(CGRectGetMaxX(deviceIconImageView.frame) + myX(39), myY(30), titleR.size.width, titleR.size.height);

    switch (model.workState) {
        case BimarWorkStateOnMode:
        {
            stateLabel.text = @"在线";
            if (model.temperatureFlag) {
                temperatureLabel.text = [NSString stringWithFormat:@"%ld",(long)model.CelsiusTemperature];
                temperatureTypeLabel.text = @"℃";
            }
            else{
                temperatureLabel.text = [NSString stringWithFormat:@"%ld",(long)model.Fahrenheit];
                temperatureTypeLabel.text = @"℉";
            }
            stateLabel.textColor = GPColor(0, 200, 83, 1.0);
            temperatureLabel.textColor = GPColor(0, 200, 83, 1.0);
            temperatureTypeLabel.textColor = GPColor(0, 200, 83, 1.0);
            break;
        }
        case BimarWorkStateOffMode:
        {
            stateLabel.text = @"离线";
            stateLabel.textColor = GPColor(255, 0, 0, 1.0);
            break;
        }
        case BimarWorkStateStandbyMode:
        {
            stateLabel.text = @"待机";
            if (model.temperatureFlag) {
                temperatureLabel.text = [NSString stringWithFormat:@"%ld",(long)model.CelsiusTemperature];
                temperatureTypeLabel.text = @"℃";
            }
            else{
                temperatureLabel.text = [NSString stringWithFormat:@"%ld",(long)model.Fahrenheit];
                temperatureTypeLabel.text = @"℉";
            }
            stateLabel.textColor = GPColor(66, 66, 66, 1.0);
            temperatureLabel.textColor = GPColor(66, 66, 66, 1.0);
            temperatureTypeLabel.textColor = GPColor(66, 66, 66, 1.0);
            break;
        }
        default:
            break;
    }
    CGRect stateLabelR = HSGetLabelRect(stateLabel.text, 0, 0, 1, 14);
    stateLabel.frame = CGRectMake(CGRectGetMinX(deviceNameLabel.frame), CGRectGetMaxY(deviceNameLabel.frame) + myY(33), stateLabelR.size.width, stateLabelR.size.height);
    
    CGRect temperatureLabelR = HSGetLabelRect(temperatureLabel.text, 0, 0, 1, 14);
    temperatureLabel.frame = CGRectMake(CGRectGetMaxX(stateLabel.frame) + myX(10), CGRectGetMinY(stateLabel.frame), temperatureLabelR.size.width, temperatureLabelR.size.height);
    
    CGRect temperatureTypeLabelR = HSGetLabelRect(temperatureTypeLabel.text, 0, 0, 1, 12);
    temperatureTypeLabel.frame = CGRectMake(CGRectGetMaxX(temperatureLabel.frame), CGRectGetMaxY(temperatureLabel.frame) - temperatureTypeLabelR.size.height, temperatureTypeLabelR.size.width, temperatureTypeLabelR.size.height);
}

- (void) createSubViews{
    if (!deviceIconImageView) {
        deviceIconImageView = [[UIImageView alloc]init];
        deviceIconImageView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:deviceIconImageView];
    }
    if (!deviceNameLabel) {
        deviceNameLabel = [[UILabel alloc]init];
        deviceNameLabel.font = [UIFont systemFontOfSize:17];
        deviceNameLabel.textColor = GPColor(48, 48, 48, 1.0);
        [self.contentView addSubview:deviceNameLabel];
    }
    if (!stateLabel) {
        stateLabel = [[UILabel alloc]init];
        stateLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:stateLabel];
    }
    if (!temperatureLabel) {
        temperatureLabel = [[UILabel alloc]init];
        temperatureLabel.font = [UIFont systemFontOfSize:14];
        temperatureLabel.textColor = GPColor(66, 66, 66, 1.0);
        [self.contentView addSubview:temperatureLabel];
    }
    if (!temperatureTypeLabel) {
        temperatureTypeLabel = [[UILabel alloc]init];
        temperatureTypeLabel.font = [UIFont systemFontOfSize:12];
        temperatureTypeLabel.textColor = GPColor(66, 66, 66, 1.0);
        [self.contentView addSubview:temperatureTypeLabel];
    }
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"关于"];
        _moreButton.frame = CGRectMake(self.bounds.size.width - image.size.width - myX(54), (CGRectGetHeight(self.frame) - 40) / 2, 40, 40);
        [_moreButton setImage:image forState:UIControlStateNormal];
        _moreButton.layer.cornerRadius = 20;
        _moreButton.clipsToBounds = YES;
        _moreButton.backgroundColor = GPColor(179, 179, 179, 1.0);
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
